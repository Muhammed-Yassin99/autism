import 'package:auto_route/auto_route.dart';
import '../util/auth_service.dart';

class RouteGuard extends AutoRedirectGuard {
  final AuthService authService;
  RouteGuard(this.authService) {
    authService.addListener(() {
      if (!authService.authenticated) {
        reevaluate();
      }
    });
  }
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authService.authenticated) return resolver.next();
    // ignore: todo
    // TODO: Navigate to login screen
  }

  @override
  Future<bool> canNavigate(RouteMatch route) {
    // ignore: todo
    // TODO: implement canNavigate
    throw UnimplementedError();
  }
}
