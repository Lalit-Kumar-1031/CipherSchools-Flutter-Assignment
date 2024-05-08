import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_tracking/Screens/hive_service.dart';
import 'package:expense_tracking/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Travel';
  final List<String> categories = [
    'Travel',
    'Food',
    'Subscription',
    'Shopping'
  ];
  bool loading=false;
  bool _isExpense = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _addTransaction() {
    loading=true;
    setState(() {});

    if (formKey.currentState!.validate()) {
      final double amount = double.tryParse(_amountController.text) ?? 0.0;
      var uuid = Uuid();
      String newKey = uuid.v1(); // Generate a unique key for each transaction

      final double totalIncome = HiveService.box.values
          .where((transaction) => !transaction.isExpense)
          .fold(
              0.0, (previousValue, element) => previousValue + element.amount);
      final double totalExpense = HiveService.box.values
          .where((transaction) => transaction.isExpense)
          .fold(
              0.0, (previousValue, element) => previousValue + element.amount);
      final double currentBalance = totalIncome - totalExpense;

      if (_isExpense && amount > currentBalance) {
        _showErrorDialog('This expense exceeds your available balance.');
        return;
      }

      final newTransaction = Transaction(
          amount: amount,
          description: _descriptionController.text,
          date: _selectedDate,
          category: _selectedCategory,
          isExpense: _isExpense,
          key: newKey);

      HiveService.box.add(newTransaction);
      Navigator.of(context).pop();
    }
    loading=false;
    setState(() {

    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid number greater than zero';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items:
                    categories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              SwitchListTile(
                title: Text('Is Expense'),
                value: _isExpense,
                onChanged: (bool value) {
                  setState(() {
                    _isExpense = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _addTransaction,
                child:loading?CircularProgressIndicator(color: Colors.white,) :Text(
                  'Add Transaction',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                        MediaQuery.of(context).size.height * 0.07)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
