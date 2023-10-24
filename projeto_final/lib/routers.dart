import 'package:nuvigator/nuvigator.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

@nuRouter
class MainRouter extends NuRouter {

  @NuRoute()
  ScreenRoute myRoute() => ScreenRoute(
    builder: (_) => MyScreen(),
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$screensMap;
}
