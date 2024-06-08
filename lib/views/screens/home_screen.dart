import 'package:flutter/material.dart';
import 'package:flutter_day_33/utils/extensions.dart';

import '../../models/expense.dart';
import '../../utils/routes.dart';
import '../../viewmodels/expenses_viewmodel.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final expensesViewModel = ExpensesViewmodel();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
  }

  void addExpense() async {
    final response = await Navigator.pushNamed(
      context,
      RouteNames.manageExpense,
    );

    if (response != null) {
      await expensesViewModel.addExpense(
        (response as Map)['title'],
        double.parse(response['amount']),
        response['date'],
      );
      setState(() {});
    }
  }

  void editExpense(Expense expense) async {
    final response = await Navigator.pushNamed(
      context,
      RouteNames.manageExpense,
      arguments: expense,
    );

    if (response != null) {
      await expensesViewModel.editExpense(
        expense.id,
        (response as Map)['title'],
        double.parse(response['amount']),
        response['date'],
      );
      setState(() {});
    }
  }

  void deleteExpense(Expense expense) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ishonchingiz komilmi?"),
          content: Text("Siz ${expense.title} xarajatini o'chirmoqchisiz."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Bekor qilish"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Ha, ishonchim komil"),
            ),
          ],
        );
      },
    );

    if (response) {
      await expensesViewModel.deleteExpense(expense.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xarajatlar"),
        actions: [
          IconButton(
            onPressed: addExpense,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              final response = await showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
                initialDate: selectedDate,
              );
              if (response != null) {
                selectedDate = response;
                setState(() {});
              }
            },
            child: Text(
              selectedDate.format(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: expensesViewModel.list(selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                final expenses = snapshot.data;
                return expenses == null || expenses.isEmpty
                    ? const Center(
                        child: Text("Xajaratlar mavjud emas."),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: expenses.length,
                        itemBuilder: (ctx, index) {
                          return ExpenseItem(
                            expense: expenses[index],
                            onEdit: () {
                              editExpense(expenses[index]);
                            },
                            onDelete: () {
                              deleteExpense(expenses[index]);
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
