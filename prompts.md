# Critical prompts

Curated from this project’s Cursor chats (4–5 Nov 2026). Not every UI tweak is listed — only prompts that set architecture, reversed a decision, or blocked a bad default.

**Mode** is inferred from the prompt: **Agent** asked for a code change; **Ask** asked for an explanation or a decision. Cursor’s Ask/Agent toggle is not stored in the transcripts.

**Pushback** means the prompt rejected a suggested implementation, a previous agent output, or an invented extra.

---

## Bootstrap and stack

| # | Mode | Prompt |
| --- | --- | --- |
| 1 | Agent | Bootstrap `refreshi-test` into a Flutter app. Use flutter-red-till for folder organisation. Do not add any code except minimal `main.dart`. |
| 2 | Ask | What version of Flutter is used in manzi-flutter-mono? |
| 3 | Agent | Use that version in refreshi_test. |
| 4 | Ask | Does auto_route support URL-based routing? |
| 5 | Agent | Add auto_route to the project with build_runner. |
| 6 | Agent | Simply add these dependencies: fpdart, freezed_annotation, injectable, flutter_bloc, and get_it. |
| 7 | Agent | Add generated files to `.gitignore`. |

**Pushback**

- **Agent** — Undo last *(white catalog background; later also used for mapper collapse and a too-aggressive `add bloc`)*.
- **Agent** — Undo last command. Then: simply add these dependencies *(rejected a larger bloc scaffold)*.
- **Agent** — Undo this, added a gitignore `files.exclude` for `*.freezed.dart` / `*.gr.dart` / `*.g.dart` *(rejected hiding generated files in the editor)*.

---

## Product screens (catalog → checkout → order summary)

| # | Mode | Prompt |
| --- | --- | --- |
| 8 | Agent | Create a catalog screen for selecting services. Make it the landing screen. |
| 9 | Agent | Add a new catalog screen: search in a top nav, tiles, cart icon with count. |
| 10 | Agent | In checkout, show selected items (scrollable), Complete at the bottom. Dummy cart items for now (15). |
| 11 | Ask | What does this mean to you? “picks a schedule time.” |
| 12 | Agent | Add titles: Address, Card Details, Select Delivery Times, Cart. |
| 13 | Agent | Add an Order Summary screen. When Complete is clicked, transition to that screen. |
| 14 | Agent | Replace start screen with a login screen. |

**Pushback**

- **Ask → Agent overreach** — I didn’t say implement this last change. I wanted the text in understandable language. *(agent had implemented a cascade layout after an Ask about checkout layout)*.
- **Agent** — Too short. / not this much. / wider. *(search field and Checkout button sizing)*.
- **Agent** — Undo last command, I meant each tile’s footer. *(wrong split target)*.

---

## Typed GraphQL and clean architecture

| # | Mode | Prompt |
| --- | --- | --- |
| 15 | Ask | Show me what a typed GraphQL client with code generation looks like. |
| 16 | Agent | Add graphql and graphql_codegen deps. Add codegen config. |
| 17 | Ask | Okay, there is no backend for our graph query. How do we mock the data? |
| 18 | Agent | Implement *(mock GraphQL link / in-app store)*. |
| 19 | Ask | Where do we fire off getCatalogItems in a safe way? Are you sure we have access to `context.read` in `initState`? |
| 20 | Agent | Create Cart and CartItem entities. Cart item should have a `cart_id`. Add interfaces with CRUD. |
| 21 | Ask | If I wanted to create rules for future features based on already done work, what should I do? |
| 22 | Agent | Implement rules. / is this thorough? / I want the full playbook. |
| 23 | Agent | Finish the cart and cart item feature based on rules: start cart on catalog, click creates cart item, +/- updates quantity, no widget cart state, cart icon = item count, total = accumulated sellingPrice, Checkout disabled until the cart has items. |

**Pushback**

- **Agent** — Undo last *(after collapsing GraphQL mappers)*.
- **Ask then Agent** — What about this `_mapCreate2<T, M>` generic? Then: **No keep functions as it, don’t reduce further. Just make them accessible to the repositories using static functions from class.**
- **Agent** — CatalogItem: this is a duplication of CatalogItemEntity. Remove.
- **Agent** — This formatter looks misplaced. It should be in the presentation layer.

---

## Naming, widgets, and display helpers

| # | Mode | Prompt |
| --- | --- | --- |
| 24 | Ask | Should things like CartLine be called viewModels? |
| 25 | Agent | Can we move all these items to a folder, rather than dumping them in widgets? Implement. |
| 26 | Agent | Change to CartLineItem. |
| 27 | Agent | Put `CartItemEntityX` in `view_model_extensions` inside shared. File: `cart_item_extension`. |
| 28 | Agent | 1 widget per file, make it a rule. Rather add part files than many widgets in the same file. |

**Pushback**

- **Ask** — Why the name CatalogService?
- **Agent** — CartLine and CartLineItem are ambiguous.
- **Ask** — Can’t CartLine’s functionality be an extension on CartItemEntity?
- **Ask** — What is this `_DummyCopy`? Is it used? **I hate the name.**

---

## Delivery, payment, hold, and the order

| # | Mode | Prompt |
| --- | --- | --- |
| 29 | Ask | When the user transitions to checkout they have a cart. I want to associate address and selected delivery times. What can I call the entity that will hold this? |
| 30 | Ask | If I get an instruction like “confirms payment using a saved card token,” what does it mean? Then: simpler language, expand. |
| 31 | Agent | Add DeliveryEntity and PaymentEntity, link via cartId. Dummy address. Payment holds a token. DeliveryTimes repository; user must choose 1. Adhere to rules. |
| 32 | Agent | Simulate sign-in with SignInUseCase. Do not call a repository. Valid email in the use case; password `Test1234`. |
| 33 | Agent | Add a `fulfilled` field on PaymentEntity (false at create). Created → Hold Placed reads from it. On order summary wait 10s, then set fulfilled and update the UI. Rename the interface to Created → Fulfilled. |
| 34 | Agent | Valid email is `test@user.com`. |
| 35 | Agent | Add a loading overlay while waiting for the hold on Order Summary. |
| 36 | Agent | Serialize MockGraphqlStore (carts, items, deliveries, payments, id counters) to localStorage after each mutation; hydrate in the GraphqlClient constructor. Catalog seed can stay hardcoded. |
| 37 | Agent | Change `/order-summary` to `/order-summary/:id`. Complete should `push(OrderSummaryRoute(id: cart.id))`. Order Summary loads that cart through use cases — not leftover CartBloc state. Refresh of `/order-summary/3` means fetch cart 3. |

**Pushback (strongest product reversals)**

- **Agent** — Implement: Complete does **not** place an order. Checkout Complete only pushes OrderSummaryRoute. No create-order mutation, no hold.
- **Agent** — Place order when Complete pressed. *(reverses the prompt above)*.
- **Ask** — Why can’t the cart be the order? Why do we need a new entity altogether?
- **Agent** — Make the cart behave like the order and undo the Order functionality creation.
- **Ask** — Checkout Complete updates the cart (`deletedAt`). This makes **NO** sense. Under what circumstance does completing a cart signal its deletion?
- **Agent** — Under **NO** circumstance should delete or soft-delete happen unless an entity is explicitly deleted. Cart item may be the only exception (quantity = 0 at checkout). Make this a hard rule.
- **Agent** — This appears to be missing from order summary. There is no order id, no Created → Hold Placed timeline, no pending/confirmed hold UI.
- **Agent** — A hold is a temporary reservation of money on the card, not a completed charge. Show pending, then flip.
- **Agent** — Stalling, finish this instruction. *(hold overlay was incomplete)*.

---

## Assignment wrap-up

| # | Mode | Prompt |
| --- | --- | --- |
| 38 | Ask | Has this document been fulfilled? *(full take-home brief: web-first checkout, typed GraphQL, deep links, simulated auth, hold timeline)*. |
| 39 | Ask | What is this hold in “Created → Hold Placed timeline”? |
| 40 | Ask | Will adding hydrated_bloc fix surviving refresh? Then how do we fix the reload issue? |
| 41 | Agent | Prepare SOLUTION.md from the interviewer instructions. Explain clean architecture and how the principles are upheld. |
| 42 | Agent | Add run instructions to the README. |

---

## Pushback, short list

These are the prompts that most clearly rejected an agent suggestion or a previous output:

1. I didn’t say implement this last change. I wanted the text in understandable language.
2. Undo last / undo last command *(used several times: background, bloc scaffold, mapper collapse, editor gitignore)*.
3. No keep functions as is, don’t reduce further. Static functions on a class.
4. CatalogItem is a duplication of CatalogItemEntity. Remove.
5. This formatter belongs in presentation.
6. Why the name CatalogService? CartLine / CartLineItem are ambiguous. I hate the name `_DummyCopy`.
7. Can’t CartLine be an extension on CartItemEntity?
8. Complete does not place an order → then **Place order when Complete pressed**.
9. Why can’t the cart be the order? Undo Order entity.
10. Completing a cart must not set `deletedAt`. Hard no-delete rule.
11. Stalling, finish this instruction.
