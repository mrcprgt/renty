import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/ui/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/ui/views/item_details_view.dart';
import 'package:renty_crud_version/ui/views/item_lend_view.dart';
import 'package:renty_crud_version/ui/views/login_view.dart';
import 'package:renty_crud_version/ui/views/signup_view.dart';
import 'package:renty_crud_version/viewmodels/item_lend_view_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case ItemLendViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ItemLendView(),
      );
    case ItemDetailViewRoute:
      var receivedItem = settings.arguments as Item;
      return MaterialPageRoute(
          builder: (_) => ItemDetailView(receivedItem: receivedItem));
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
