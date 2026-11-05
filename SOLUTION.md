# SOLUTION

Refreshi is a time-boxed, web-first Flutter checkout slice. A customer picks services, chooses a delivery window, and confirms with a saved card token. The app places a **temporary hold** (not a real charge) and shows order details with a Created → Fulfilled timeline. There is no separate backend: a typed GraphQL client talks to an in-repo schema resolved by an in-app mock store.

This document maps the implementation to the take-home brief, starting with architecture.

## Clean architecture

Clean architecture (Uncle Bob) is a **dependency rule**: source code dependencies point inward. Inner layers know nothing about UI, GraphQL, or GetIt. Outer layers implement the contracts the inner layers declare.

| Layer | Owns | Must not know |
| --- | --- | --- |
| **Domain** | Entities, failures, repository *interfaces* | Flutter, GraphQL, GetIt, blocs |
| **Application** | Use cases (`UseCase<Entity, Params>` → `TaskEither<BaseFailure, T>`) | GraphQL models, widgets |
| **Infrastructure** | GraphQL client, generated types, mock store, repository *implementations*, AutoMappr | Screens, theme |
| **Presentation** | Screens, blocs, widgets | GraphQL generated types, mock store |
| **Bootstrap** | Composition root: router, theme, `GlobalProvider`, `configureDependencies()` | Business rules |

The runtime flow is one direction:

```
Screen → Bloc → UseCase → IRepository → Repository + GraphClient + AutoMappr → Entity
```

How those principles are upheld here:

1. **Independent domain.** `lib/domain` is plain Dart: `CartEntity`, `PaymentEntity`, `ICartRepository`, `BaseFailure`. No Flutter widgets, no `package:graphql`, no GetIt.
2. **Use cases as the application API.** Blocs call `GetCartUseCase`, `UpdateCartUseCase`, `UpdatePaymentUseCase`, and so on. They never call repositories or GraphQL clients. A use case delegates; it does not map GraphQL JSON.
3. **Dependency inversion.** Domain declares `IPaymentRepository`. Infrastructure provides `PaymentRepository` (`@LazySingleton(as: IPaymentRepository)`). Presentation depends on the abstract use case, not the concrete Graph client.
4. **Boundaries at mapping.** Generated GraphQL types (`Query$GetCart$getCart`, …) stay in `infrastructure`. Repositories convert them to entities with `GraphModelMapper` + AutoMappr. UI never sees a `Map<String, dynamic>` from the wire.
5. **Errors as values.** Failures are domain types (`CartFailure`, `InvalidEmailFailure`). GraphQL errors (`BaseGraphError`) are mapped with `toCartFailure()` / `toPaymentFailure()` before they leave infrastructure. Call sites use `TaskEither.fold`, not thrown exceptions, as the normal control flow.

That split is what makes the slice grow: swapping the mock `Link` for a real HTTP GraphQL endpoint should not change a screen or a use case.

## Project structure

```
lib/
  bootstrap/          # wiring only (router, theme, GlobalProvider)
  domain/             # entities, failures, I*Repository
  application/        # use cases
    use_cases/
      cart/
      cart_item/
      payment/
      delivery/
      ...
  infrastructure/
    datasources/graphql/   # schema, operations, mock link/store, typed clients
    repositories/          # I*Repository implementations
    mappers/               # GraphQL error → domain failure, AutoMappr
    shared/                # GraphModelMapper
  presentation/
    screens/               # Login, Catalog, Checkout, Order Summary
    state/bloc/            # Auth, CatalogItems, Cart, DeliveryTimes, OrderSummary
    shared/                # formatRand, CartItemEntity display extensions
  main.dart
  get_it.dart
```

Generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.graphql.dart`, `*.auto_mappr.dart`, `lib/get_it.config.dart`) are gitignored and rebuilt with `fvm flutter pub run build_runner build`.

## Task 1 — Web-first UI and navigation

### Screens

| Route | Path | Role |
| --- | --- | --- |
| `LoginScreen` | `/` | Simulated sign-in (`test@user.com` / `Test1234`) |
| `CatalogScreen` | `/catalog` | Browse/search services, quantity, cart count |
| `CheckoutScreen` | `/checkout` | Address, saved card token, **one** delivery window, Complete |
| `OrderSummaryScreen` | `/order-summary/:id` | Order id, items, details, Created → Fulfilled timeline |

Checkout is **not** a payment action. **Complete** is: it finalizes the cart (`placedAt`) and navigates to order details. Payment is created earlier with `fulfilled: false` (the hold). The details page waits ~10 seconds, then sets `fulfilled: true` once.

The cart *is* the order. There is no separate `Order` type. Order number is `cart.id`. That keeps the GraphQL surface small and matches “create order with a temporary hold, then fetch order details.”

Web UX: light theme, 24px inset, checkout stacks below 900px width, primary actions are `Size(230, 52)`. The same codebase runs on iOS/Android.

### URL-based navigation and refresh

Routes are declared with **auto_route** (`MaterialApp.router`). Order details is a path parameter, not a nameless push:

```
/order-summary/:id
```

Complete does `push(OrderSummaryRoute(id: cart.id))`. Opening or refreshing `/order-summary/3` means **fetch cart 3** — items, delivery, and payment — through use cases (`GetCartUseCase`, `GetCartItemsUseCase`, `GetPaymentsUseCase`, `GetDeliveriesUseCase`), filtered by `cartId`. The screen does **not** paint leftover `CartBloc` memory.

Carts, items, deliveries, payments, and id counters are serialized to SharedPreferences after each mutation (on web this is **localStorage**). `GraphqlClient` hydrates the mock store in its constructor. Catalog seed data stays hardcoded. A browser refresh can therefore reload `/order-summary/3` and still resolve order 3.

### Simulated sign-in

`AuthGuard` sits on `/catalog`, `/checkout`, and `/order-summary/:id`. If `AuthBloc` is not logged in, navigation is replaced with `LoginRoute`. Sign-in is `SignInUseCase` only (no auth repository): email must be `test@user.com` and password `Test1234`.

**Gap:** after a successful login the app currently `push`es `/catalog`, rather than restoring the original deep link. Guarding the order route is in place; returning the user to that exact URL after sign-in is the remaining piece.

## Task 2 — Typed GraphQL (local schema)

- **Schema** lives in `lib/infrastructure/datasources/graphql/schema.graphql`.
- **Operations** live in `operations/*.graphql` (create/get/update cart, cart items, delivery, payment, catalog, delivery times).
- **`graphql_codegen`** (`clients: [graphql]`) generates typed documents. App code calls `query$GetCart` / `mutate$UpdatePayment`, not dynamic maps.
- **No server.** `mockGraphqlLink()` is a `Link.function` that dispatches by operation name onto `MockGraphqlStore`. Query/Mutation roots and each item include `__typename` so generated `fromJson` works.
- Graph clients return `TaskEither<BaseGraphError, T>`. Repositories map to entities.

Minimum flow the brief asked for:

| Brief | Implementation |
| --- | --- |
| Create order with a temporary hold | `updateCart(placedAt)` + `createPayment(..., fulfilled: false)` |
| Fetch order details | `getCart(id)` + items / delivery / payments for that `cartId` |
| Hold confirmation can arrive later | Order Summary shows **Pending**, waits 10s, then `updatePayment(fulfilled: true)` |

## Repeated actions (no duplicate financial outcomes)

This is the behaviour the assignment asked to explain.

A hold is a **one-shot authorization** on a saved token (`tok_visa_4242`). The design treats “place order” and “confirm hold” as **idempotent transitions**, not as “create another payment.”

### 1. Complete cannot fire twice

`canComplete` is false when the cart is already placed, while a mutation is in flight, or when no delivery window is selected. The button is disabled (`onPressed: null`).

`CartEvent.placeOrder` also no-ops if `cart.placedAt != null`. Navigation to order summary listens for the *transition* `!previous.isPlaced && current.isPlaced`, so a second Complete does not push a second order route.

### 2. One payment per cart

`ensureCheckoutDetails` creates delivery and payment only when they are missing. A second visit to checkout reuses the existing payment; it does not `createPayment` again.

### 3. Hold confirmation runs once

Order Summary loads by id, then (only if the cart is placed and the payment is not yet fulfilled) dispatches `OrderSummaryEvent.fulfillPayment`.

That handler:

- returns immediately if `payment == null`, `payment.fulfilled`, or `fulfillmentRequested`;
- sets `fulfillmentRequested` **before** the 10s delay, so a rebuild / second event cannot start another update;
- after the delay, calls `UpdatePaymentUseCase` once.

The mock store **latches** fulfillment: once `fulfilled` is true, later `updatePayment` calls cannot turn it back to false.

Refreshing `/order-summary/3` while the hold is already confirmed loads `fulfilled: true` from the persisted store and **does not** schedule another 10s update.

### 4. Refresh mid-checkout

Checkout itself is not identified in the URL (catalog still pushes `/checkout` with no cart args). The mock store *is* persisted, so quantities, the cart id, delivery, and the unfulfilled payment survive a refresh of the running app. Re-entering checkout via the in-app flow continues the same cart rather than minting a second payment.

Together: double-click Complete, double-dispatch fulfill, and refresh on the details URL cannot create a second hold or a second fulfilled payment for the same cart.

## Dependency management

- **GetIt + injectable** at the composition root (`configureDependencies()` before `runApp`).
- App-wide blocs are `@lazySingleton` and provided with `BlocProvider.value` so disposing a screen does not close the singleton.
- SharedPreferences is `@preResolve` so `GraphqlClient` can hydrate synchronously in its constructor.
- Presentation depends on blocs/use cases; tests mock use cases (mocktail) or the Graph client, not the UI.

## How to run

FVM Flutter **3.38.5** / Dart **3.10.4**.

```sh
fvm flutter pub get
fvm flutter pub run build_runner build
fvm flutter run -d chrome    # web-first
fvm flutter run              # iOS / Android
fvm flutter test
```

Sign-in: `test@user.com` / `Test1234`.
