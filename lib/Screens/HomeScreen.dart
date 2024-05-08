import 'package:expense_tracking/Screens/Login_Screen/login_screen.dart';
import 'package:expense_tracking/Screens/add_transactionScreen.dart';
import 'package:expense_tracking/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await signOutGoogle();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));

                  Fluttertoast.showToast(msg: "Logout Success full ");

                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTransactionScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Hive.box<Transaction>('transactions').listenable(),
        builder: (context, box, _) {
          List<Transaction> transactions =
              box.values.toList().cast<Transaction>();

          return Column(
            children: [
              // Summary Widgets
              _buildSummaryWidgets(transactions),
              // Transactions List
              Expanded(
                child: transactions.isEmpty
                    ? Center(child: Text("No transactions added yet."))
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final transactionKey = box.keyAt(index);

                          return Dismissible(
                            key: Key(transactionKey.toString()),
                            onDismissed: (direction) {
                              // Perform the actual deletion of the item from the box
                              box.delete(transactionKey);

                              // Update UI by removing the item from the list used by ListView.builder
                              transactions.removeAt(index);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              color: transaction.isExpense
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              margin: EdgeInsets.only(bottom: 5),
                              child: ListTile(
                                leading: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: transaction.isExpense
                                        ? Colors.red.shade200
                                        : Colors.green.shade200,
                                  ),
                                  child: Icon(Icons.money),
                                ),
                                title: Text(
                                    '${transaction.category}: \$${transaction.amount.toStringAsFixed(2)}'),
                                subtitle: Text(
                                    '${DateFormat.yMMMd().format(transaction.date)} - ${transaction.description}'),
                                trailing: Icon(transaction.isExpense
                                    ? Icons.clear
                                    : Icons.done),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryWidgets(List<Transaction> transactions) {
    double totalIncome = transactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
    double totalExpense = transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
    double balance = totalIncome - totalExpense;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryTile("Income", totalIncome),
          _buildSummaryTile("Expense", totalExpense),
          _buildSummaryTile("Balance", balance),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(String title, double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text('\$${value.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: Colors.green)),
      ],
    );
  }
}
