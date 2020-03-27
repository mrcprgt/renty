import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/ui/views/accounts_view.dart';
import 'package:renty_crud_version/ui/views/home_tab_view.dart';
import 'package:renty_crud_version/ui/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/ui/views/item_details_view.dart';
import 'package:renty_crud_version/ui/views/item_lend_view.dart';
import 'package:renty_crud_version/ui/views/item_transaction_view.dart';
import 'package:renty_crud_version/ui/views/login_view.dart';
import 'package:renty_crud_version/ui/widgets/onboarding.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: OnboardingPage(),
      );

    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );

    case AccountViewPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AccountsView(),
      );

    case HomeTabViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeTabView(),
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

    case ItemTransactionViewRoute:
      // var receivedItem = settings.arguments;
      // var rentChosen = settings.arguments;
      // var startTime = settings.arguments;
      // var endTime = settings.arguments;
      // var startDate = settings.arguments;
      // var endDate = settings.arguments;

      var receivedArguments = settings.arguments;

      return MaterialPageRoute(
          builder: (_) =>
              ItemTransactionView(receivedArguments: receivedArguments));

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
