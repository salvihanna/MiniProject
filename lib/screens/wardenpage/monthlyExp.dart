import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/supabase_config.dart';

class MonthlyExp extends StatefulWidget {
  final String? uid;
  const MonthlyExp({Key? key, this.uid}) : super(key: key);

  @override
  State<MonthlyExp> createState() => _MonthlyExpState();
}

class _MonthlyExpState extends State<MonthlyExp> {
  List<ExpenseItem> expenses = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  @override
  void dispose() {
    dateController.dispose();
    amountController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  Future<void> addExpense() async {
    final String date = dateController.text;
    final double amount = double.tryParse(amountController.text) ?? 0;
    final String remark = remarkController.text;

    if (date.isNotEmpty && amount > 0) {
      // Save expense to Supabase
      final response = await supabase.from('daily_expense').insert([
        {
          'date': date,
          'amount': amount,
          'remark': remark,
          'u_id': widget.uid,
        }
      ]).execute();

      if (response.error == null) {
        // Expense saved successfully
        final insertedExpense = response.data?.first;
        setState(() {
          expenses.add(ExpenseItem(
            date: insertedExpense['date'],
            amount: insertedExpense['amount'],
            remark: insertedExpense['remark'],
          ));
        });

        // Clear the text fields after adding an expense
        dateController.clear();
        amountController.clear();
        remarkController.clear();
        selectedDate = null;
      } else {
        // Error occurred while saving the expense
        print('Error: ${response.error?.message}');
      }
    }
  }

  Future<void> fetchExpenses() async {
    final response = await supabase.from('daily_expense').select().execute();

    if (response.error == null) {
      final data = response.data;
      print(data.toString());
      if (data != null && data.isNotEmpty) {
        final newExpenses = data
            .map((expense) => ExpenseItem(
                  date: expense['date'] as String,
                  amount: (expense['amount'] as num).toDouble(),
                  remark: expense['remark'] as String,
                ))
            .toList();

        setState(() {
          expenses = newExpenses;
        });
      }
    } else {
      print('Error: ${response.error?.message}');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expenses'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Amount',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: remarkController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Remark',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: addExpense,
                  child: const Text('Add'),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Generate Bill"))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Remark')),
                  ],
                  rows: expenses.map((expense) {
                    return DataRow(
                      cells: [
                        DataCell(Text(expense.date)),
                        DataCell(Text(expense.amount.toString())),
                        DataCell(Text(expense.remark)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> userDetails() async {
    final response = await supabase.from('users').select().execute();
    print(response.data.toString());
  }
}

class ExpenseItem {
  final String date;
  final double amount;
  final String remark;

  ExpenseItem({
    required this.date,
    required this.amount,
    required this.remark,
  });
}