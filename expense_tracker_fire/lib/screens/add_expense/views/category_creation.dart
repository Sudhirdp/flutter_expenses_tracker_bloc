import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_expenses_app/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:uuid/uuid.dart';

  List<IconData> myCategoryIcons = [
    Icons.tv,
    Icons.food_bank_outlined,
    Icons.home_work,
    Icons.pets_rounded,
    Icons.shopping_bag_rounded,
    Icons.devices,
    Icons.commute_sharp,
  ];
Future getCategoryCreation(BuildContext context) {

  return showDialog(
    context: context,
    builder: (context1) {
      bool isExtended = false;
      IconData? iconSelected = CupertinoIcons.chevron_down;
      Color categoryColor = Colors.white;
      final TextEditingController categoryNameController =
          TextEditingController();
      final TextEditingController categoryIconController =
          TextEditingController();
      final TextEditingController categotyColorController =
          TextEditingController();
      bool isLoading = false;
      Category category = Category.empty;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (context1, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySucess) {
                  Navigator.pop(context1,category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Create Category',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: categoryNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                              color: Colors.black54, fontSize: 22),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: categoryIconController,
                        onTap: () {
                          setState(() {
                            isExtended = !isExtended;
                          });
                        },
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            iconSelected,
                            size: 22,
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Icon',
                          hintStyle: const TextStyle(
                              color: Colors.black54, fontSize: 22),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: isExtended
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(20))
                                : BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      isExtended
                          ? Container(
                              padding: const EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20))),
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5),
                                  itemCount: myCategoryIcons.length,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: IconButton(
                                          onPressed: () {
                                            iconSelected =
                                                myCategoryIcons[index];
                                            setState(() {
                                              isExtended = false;
                                            });
                                          },
                                          icon: Icon(myCategoryIcons[index]),
                                          iconSize: 32,
                                          splashRadius: 2,
                                        ));
                                  })),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: categotyColorController,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: categoryColor,
                          hintText: 'Color',
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                            fontSize: 22,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context2) {
                              categoryColor = Colors.blue;
                              return BlocProvider.value(
                                value: context.read<CreateCategoryBloc>(),
                                child: AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ColorPicker(
                                        pickerColor: categoryColor,
                                        onColorChanged: (value) {
                                          setState(() {
                                            categoryColor = value;
                                          });
                                        },
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            transform:
                                                const GradientRotation(pi / 4),
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context2);
                                          },
                                          child: const Text(
                                            'SAVE Color',
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            transform: const GradientRotation(pi / 4),
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: isLoading == true
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : TextButton(
                                onPressed: () {
                                  //create category object and pop
                                  setState((){
                                    category.categoryId = const Uuid().v1();
                                    category.name = categoryNameController.text;
                                    category.color = categoryColor.value;
                                    category.icon = iconSelected!.codePoint;
                                  });
                                  context
                                      .read<CreateCategoryBloc>()
                                      .add(CreateCategory(category));
                                  // Navigator.pop(context1);
                                },
                                child: const Text(
                                  'SAVE',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
