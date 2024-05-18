import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:paisa_management/database/category/db_catfn.dart';
import 'package:paisa_management/database/transactions/db_tranfn.dart';
import 'package:paisa_management/models/category/categorymodel.dart';
import 'package:paisa_management/models/transaction/transaction_model.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Transactiondb.instance.refresh();
    CategoriesDB.instance.refreshUi();
    return ValueListenableBuilder(
        valueListenable: Transactiondb.instance.transactions,
        builder: (BuildContext ctx, List<TransactionModel> newlist, Widget? _) {
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final value = newlist[index];
              final date = DateFormat.yMMMd().format(value.date);

              return Slidable(
                key: Key(value.id!),
                startActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      Transactiondb.instance.deletetrans(value.id!);
                    },
                    icon: Icons.delete,
                  )
                ]),
                child: Card(
                  child: ListTile(
                    tileColor: (value.type == CategoryType.income
                        ? (Colors.green)
                        : Colors.red),
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow,
                      radius: 30,
                      child: Text(
                        date.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value.purpose),
                        Text(
                          '₹ ${value.amount}',
                        ),
                      ],
                    ),
                    textColor: Colors.white,
                    subtitle: Text(value.category.name),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newlist.length,
          );
        });
  }
}
