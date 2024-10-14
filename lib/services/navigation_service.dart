import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String route) {
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  Future<dynamic> navigateToRoute(String route, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  void navigateToPage(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
