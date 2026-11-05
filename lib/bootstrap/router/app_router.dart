import 'package:auto_route/auto_route.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/router/guards/auth_guard.dart';
import 'package:refreshi_test/get_it.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, path: '/', initial: true),
        AutoRoute(page: CatalogRoute.page, path: '/catalog',guards: [_authGuard]),
        AutoRoute(page: CheckoutRoute.page, path: '/checkout', guards: [_authGuard]),
        AutoRoute(page: OrderSummaryRoute.page, path: '/order-summary', guards: [_authGuard]),
      ];
      
  AuthGuard get _authGuard => getIt<AuthGuard>();

}
