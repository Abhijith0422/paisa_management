import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:paisa_management/database/category/db_catfn.dart';
import 'package:paisa_management/database/transactions/db_tranfn.dart';
import 'package:paisa_management/models/category/categorymodel.dart';
import 'package:paisa_management/models/transaction/transaction_model.dart';

class TransactionAddPage extends StatefulWidget {
  static const routename = 'transactionadd';
  @override
  _TransactionAddPageState createState() => _TransactionAddPageState();
}

class _TransactionAddPageState extends State<TransactionAddPage> {
  DateTime? _selectedDate;
  CategoryType? _selectedType;
  CategoryModel? _selectedCategory;
  String? _selectedCategoryid;
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  void initState() {
    _selectedType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _purposeController,
              decoration: InputDecoration(
                  hintText: 'Purpose',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Amount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
                onPressed: () async {
                  final _selectedDatetemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365 * 10)),
                    lastDate: DateTime.now(),
                  );

                  if (_selectedDatetemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _selectedDatetemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : DateFormat.yMMMd().format(_selectedDate!))),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: CategoryType.income,
                            groupValue: _selectedType,
                            onChanged: (newvalue) {
                              setState(() {
                                _selectedType = CategoryType.income;
                                _selectedCategoryid = null;
                              });
                            }),
                        const Text('Income'),
                        Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedType,
                            onChanged: (newvalue) {
                              setState(() {
                                _selectedType = CategoryType.expense;
                                _selectedCategoryid = null;
                              });
                            }),
                        const Text('Expense')
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
                hint: const Text('Category'),
                value: _selectedCategoryid,
                items: (_selectedType == CategoryType.income
                        ? CategoriesDB.instance.incomeCategories
                        : CategoriesDB.instance.expenseCategories)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    onTap: () {
                      setState(() {
                        _selectedCategory = e;
                      });
                    },
                    value: e.id,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (selectedvalue) {
                  setState(() {
                    _selectedCategoryid = selectedvalue;
                  });
                }),
            const SizedBox(height: 7),
            ElevatedButton.icon(
              onPressed: () {
                addTrasaction();
              },
              icon: const Icon(Icons.input_rounded),
              label: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Future addTrasaction() async {
    final _purposeText = _purposeController.text;
    final _amountText = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_selectedCategoryid == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategory == null) {
      return;
    }
    final amount = double.tryParse(_amountText);
    if (amount == null) {
      return;
    }
    final _model = TransactionModel(
        purpose: _purposeText,
        amount: amount,
        date: _selectedDate!,
        type: _selectedType!,
        category: _selectedCategory!);

    await Transactiondb.instance.addTransaction(_model);
    Navigator.of(context).pop();
    Transactiondb.instance.refresh();
  }
}
