import 'package:flutter/material.dart';

import '../../models/expense.dart';
import '../../utils/extensions.dart';

class ManageExpenseScreen extends StatefulWidget {
  const ManageExpenseScreen({super.key});

  @override
  State<ManageExpenseScreen> createState() => _ManageExpenseScreenState();
}

class _ManageExpenseScreenState extends State<ManageExpenseScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> expenseData = {};

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Navigator.pop(context, expenseData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expense = ModalRoute.of(context)!.settings.arguments as Expense?;
    if (expense != null) {
      expenseData = {
        "title": expense.title,
        "amount": expense.amount,
        "date": expense.date,
      };
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          expense == null ? "Xarajat kiritish" : "Xajaratni tahrirlash",
        ),
        actions: [
          IconButton(
            onPressed: submit,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              initialValue: expenseData['title'],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Xarajat nomi",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Iltimos xarajat nomini kiriting";
                }

                return null;
              },
              onSaved: (value) {
                expenseData['title'] = value;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: expenseData['amount']?.toString(),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Xarajat miqdori",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Iltimos xarajat miqdorini kiriting";
                }

                return null;
              },
              onSaved: (value) {
                expenseData['amount'] = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expenseData['date'] == null
                      ? "Xarajat kuni tanlanmagan"
                      : (expenseData['date'] as DateTime).format(),
                ),
                TextButton(
                  onPressed: () async {
                    final response = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                    );

                    if (response != null) {
                      expenseData['date'] = response;
                      setState(() {});
                    }
                  },
                  child: const Text("Kunni tanlash"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
