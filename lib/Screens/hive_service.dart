import 'package:expense_tracking/transaction.dart';
import 'package:hive/hive.dart';


class HiveService {
  static late Box<Transaction> _box;

  static Future<void> openBox() async {
    _box = await Hive.openBox<Transaction>('transactions');
  }

  static Box<Transaction> get box {
    return _box;
  }

  static Future<void> closeBox() async {
    await _box.close();
  }
}
