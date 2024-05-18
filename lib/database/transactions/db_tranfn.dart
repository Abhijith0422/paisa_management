import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:paisa_management/models/transaction/transaction_model.dart';

const transactiondbname = 'transactions-db';

abstract class Transactiondbfn {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel obj);
  Future<void> deletetrans(String id);
}

class Transactiondb implements Transactiondbfn {
  Transactiondb._internal();
  static Transactiondb instance = Transactiondb._internal();
  factory Transactiondb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactions = ValueNotifier([]);
  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final transdb = await Hive.openBox<TransactionModel>(transactiondbname);
    await transdb.put(obj.id, obj);

    refresh();
  }

  Future<void> refresh() async {
    final allTransaction = await getTransactions();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    transactions.value.clear();
    transactions.value.addAll(allTransaction);
    transactions.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final transdb = await Hive.openBox<TransactionModel>(transactiondbname);
    return transdb.values.toList();
  }

  @override
  Future<void> deletetrans(String id) async {
    final transdb = await Hive.openBox<TransactionModel>(transactiondbname);
    await transdb.delete(id);
    refresh();
  }
}
