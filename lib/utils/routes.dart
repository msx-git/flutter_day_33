
import '../views/screens/home_screen.dart';
import '../views/screens/manage_expense_screen.dart';

class AppRoute {
  static final routes = {
    RouteNames.home: (ctx) => const HomeScreen(),
    RouteNames.manageExpense: (ctx) => const ManageExpenseScreen(),
  };
}

class RouteNames {
  static const String home = "/";
  static const String manageExpense = "/manage-expense";
}
