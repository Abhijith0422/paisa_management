import 'package:flutter/material.dart';
import 'package:paisa_management/database/category/db_catfn.dart';
import 'package:paisa_management/screens/category/expenseclist.dart';
import 'package:paisa_management/screens/category/icomeclist.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoriesDB().refreshUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'INCOME',
            ),
            Tab(
              text: 'EXPENSE',
            )
          ],
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: const [IncomeList(), ExpenseList()]))
      ],
    );
  }
}
