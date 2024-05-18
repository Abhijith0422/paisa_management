import 'package:flutter/material.dart';
import 'package:paisa_management/database/category/db_catfn.dart';

import 'package:paisa_management/models/category/categorymodel.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryPop(BuildContext context) async {
  final _nameEditingcontroller = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: _nameEditingcontroller,
                  decoration: const InputDecoration(
                      hintText: 'Category Name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                          borderRadius: BorderRadius.all(Radius.circular(5))))),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: 'Expense', type: CategoryType.expense)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingcontroller.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategory.value;
                  final _category = CategoryModel(
                      id: DateTime.now().millisecond.toString(),
                      name: _name,
                      type: _type);
                  CategoriesDB.instance.insertCategory(_category);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add'),
              ),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  //final CategoryType selectedCategoryType;
  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategory,
            builder:
                (BuildContext context, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategory.value = value;
                    selectedCategory.notifyListeners();
                  });
            }),
        Text(title)
      ],
    );
  }
}
