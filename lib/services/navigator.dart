import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateTo(String routeName, {dynamic arguments}) async {
    await navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateBack({dynamic result}) async {
    return navigatorKey.currentState!.pop(result);
  }

  void replaceWith(String routeName, {dynamic arguments}) {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }
}
