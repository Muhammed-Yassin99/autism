import 'package:Autism_Helper/HomePage/ParentView/parentHomePage.dart';
import 'package:auto_route/annotations.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      page: HomePage,
      name: 'homeRoute',
      path: '/',
    ),
    /* AutoRoute(
      page: DashboardScreen,
      name: 'DashboardRoute',
      path: '/dashboard',
      children: <AutoRoute>[
        AutoRoute<EmptyRouterPage>(
          name: 'ProductsRoute',
          path: 'products',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              page: ProductsScreen,
              path: '',
            ),
            AutoRoute(
                page: AddProductsScreen,
                name: 'AddProductsRoute',
                path: 'add_products'),
          ],
        ),
        AutoRoute(page: ProfileScreen, name: 'ProfileRoute', path: 'profile')
      ],
    ),
    AutoRoute(page: AboutScreen, name: 'AboutRouter', path: '/about')*/
  ],
)
class $AppRouter {}
