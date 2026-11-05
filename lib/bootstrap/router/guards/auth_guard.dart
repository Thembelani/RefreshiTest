import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  const AuthGuard(this._authBloc);

  final AuthBloc _authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthenticated = _authBloc.state.isLoggedIn != false;
    if (isAuthenticated) {
      resolver.next();
    } else {
      router.replaceAll([const LoginRoute()]);
    }
  }
}
