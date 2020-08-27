import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get/src/instance/get_instance.dart';
import 'package:get/src/navigation/dialog/dialog_route.dart';
import 'package:get/src/navigation/routes/default_route.dart';
import 'package:get/src/navigation/snackbar/snack_route.dart';

class Routing {
  String current;
  String previous;
  Object args;
  String removed;
  Route<dynamic> route;
  bool isBack;
  bool isSnackbar;
  bool isBottomSheet;
  bool isDialog;
  Routing({
    this.current = '',
    this.previous = '',
    this.args,
    this.removed = '',
    this.route,
    this.isBack,
    this.isSnackbar,
    this.isBottomSheet,
    this.isDialog,
  });

  void update(void fn(Routing value)) {
    fn(this);
  }
}

class GetObserver extends NavigatorObserver {
  final Function(Routing) routing;

  GetObserver([this.routing, this._routeSend]);
  final Routing _routeSend;

  Route<dynamic> route;
  bool isBack;
  bool isSnackbar;
  bool isBottomSheet;
  bool isDialog;
  String current;
  String previous;
  Object args;
  // String previousArgs;
  String removed;

  String name(Route<dynamic> route) {
    if (route?.settings?.name != null) {
      return route?.settings?.name;
    } else if (route is GetPageRoute) {
      return route.routeName;
    } else if (route is GetDialogRoute) {
      return route.name;
    } else if (route is GetModalBottomSheetRoute) {
      return route.name;
    } else {
      return route?.settings?.name;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    bool isGetPageRoute = route is GetPageRoute;
    bool isSnackbar = route is SnackRoute;
    bool isDialog = route is GetDialogRoute;
    bool isBottomSheet = route is GetModalBottomSheetRoute;
    String routeName = name(route);

    if (isSnackbar) {
      GetConfig.log("OPEN SNACKBAR $routeName", name: '[GETX]');
    } else if (isBottomSheet) {
      GetConfig.log("OPEN $routeName", name: '[GETX]');
    } else if (isDialog) {
      GetConfig.log("OPEN $routeName", name: '[GETX]');
    } else if (isGetPageRoute) {
      GetConfig.log("GOING TO ROUTE $routeName", name: '[GETX]');
    }
    GetConfig.currentRoute = routeName;

    _routeSend.update((value) {
      if (route is PageRoute) value.current = routeName;
      value.args = route?.settings?.arguments;
      value.route = route;
      value.isBack = false;
      value.removed = '';
      value.previous = '${previousRoute?.settings?.name}';
      value.isSnackbar = isSnackbar;
      value.isBottomSheet = isBottomSheet;
      value.isDialog = isDialog;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    bool isGetPageRoute = route is GetPageRoute;
    bool isSnackbar = route is SnackRoute;
    bool isDialog = route is GetDialogRoute;
    bool isBottomSheet = route is GetModalBottomSheetRoute;
    String routeName = name(route);

    if (isSnackbar) {
      GetConfig.log("CLOSE SNACKBAR $routeName", name: '[GETX]');
    } else if (isBottomSheet) {
      GetConfig.log("CLOSE $routeName", name: '[GETX]');
    } else if (isDialog) {
      GetConfig.log("CLOSE $routeName", name: '[GETX]');
    } else if (isGetPageRoute) {
      GetConfig.log("CLOSE TO ROUTE $routeName", name: '[GETX]');
    }
    GetConfig.currentRoute = routeName;

    _routeSend.update((value) {
      if (previousRoute is PageRoute)
        value.current = '${previousRoute?.settings?.name}';
      value.args = route?.settings?.arguments;
      value.route = previousRoute;
      value.isBack = true;
      value.removed = '';
      value.previous = '${route?.settings?.name}';
      value.isSnackbar = false;
      value.isBottomSheet = false;
      value.isDialog = false;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    GetConfig.log("REPLACE ROUTE ${oldRoute?.settings?.name}", name: '[GETX]');
    GetConfig.log("NEW ROUTE ${newRoute?.settings?.name}", name: '[GETX]');

    GetConfig.currentRoute = name(newRoute);

    _routeSend.update((value) {
      if (newRoute is PageRoute) value.current = '${newRoute?.settings?.name}';
      value.args = newRoute?.settings?.arguments;
      value.route = newRoute;
      value.isBack = false;
      value.removed = '';
      value.previous = '${oldRoute?.settings?.name}';
      value.isSnackbar = false;
      value.isBottomSheet = false;
      value.isDialog = false;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    GetConfig.log("REMOVING ROUTE ${route?.settings?.name}", name: '[GETX]');

    _routeSend.update((value) {
      value.route = previousRoute;
      value.isBack = false;
      value.removed = '${route?.settings?.name}';
      value.previous = '${route?.settings?.name}';
    });
    if (routing != null) routing(_routeSend);
  }
}
