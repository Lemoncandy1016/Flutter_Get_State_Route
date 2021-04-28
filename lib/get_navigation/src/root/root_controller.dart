import 'package:flutter/material.dart';
import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../routes/custom_transition.dart';
import '../routes/observers/route_observer.dart';
import '../routes/transitions_type.dart';
import 'parse_route.dart';

class GetMaterialController extends GetxController {
  bool testMode = false;
  Key? unikey;
  ThemeData? theme;
  ThemeData? darkTheme;
  ThemeMode? themeMode;

  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;

  Transition? defaultTransition;
  Duration defaultTransitionDuration = Duration(milliseconds: 300);
  Curve defaultTransitionCurve = Curves.easeOutQuad;

  Curve defaultDialogTransitionCurve = Curves.easeOutQuad;

  Duration defaultDialogTransitionDuration = Duration(milliseconds: 300);

  final routing = Routing();

  Map<String, String?> parameters = {};

  late ParseRouteTree routeTree;

  CustomTransition? customTransition;

  GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  Map<dynamic, GlobalKey<NavigatorState>> keys = {};

  void setTheme(ThemeData value) {
    if (darkTheme == null) {
      theme = value;
    } else {
      if (value.brightness == Brightness.light) {
        theme = value;
      } else {
        darkTheme = value;
      }
    }
    update();
  }

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    update();
  }

  void restartApp() {
    unikey = UniqueKey();
    update();
  }
}
