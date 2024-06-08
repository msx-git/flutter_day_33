class Expense {
  final int id;
  String title;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      title: map['title'].toString(),
      amount: map['amount'] as double,
      date: DateTime.parse(
        map['date'],
      ),
    );
  }
}
