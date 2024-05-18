import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paisa_management/models/category/categorymodel.dart';
import 'package:paisa_management/models/transaction/transaction_model.dart';
import 'package:paisa_management/screens/home.dart';
import 'package:paisa_management/screens/transactions/transactionadd.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(const PaisaManagement());
}

class PaisaManagement extends StatelessWidget {
  const PaisaManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paisa Manager',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.red),
        colorSchemeSeed: Colors.red,
      ),
      home: Homescreen(),
      routes: {
        TransactionAddPage.routename: (ctx) {
          return TransactionAddPage();
        }
      },
    );
  }
}
