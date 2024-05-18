import 'package:flutter/material.dart';

import 'package:paisa_management/screens/category/category.dart';
import 'package:paisa_management/screens/category/pop_up.dart';
import 'package:paisa_management/screens/transactions/transaction.dart';
import 'package:paisa_management/screens/transactions/transactionadd.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  static ValueNotifier<int> selectedIndexN = ValueNotifier(0);

  final _pages = [const TransactionPage(), const Category()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paisa Manager'),
      ),
      bottomNavigationBar: const PMBN(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexN,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexN.value == 0) {
            Navigator.of(context).pushNamed(TransactionAddPage.routename);
          } else {
            showCategoryPop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PMBN extends StatelessWidget {
  const PMBN({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Homescreen.selectedIndexN,
      builder: (BuildContext context, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
            currentIndex: updatedIndex,
            onTap: (newindex) {
              Homescreen.selectedIndexN.value = newindex;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category')
            ]);
      },
    );
  }
}
