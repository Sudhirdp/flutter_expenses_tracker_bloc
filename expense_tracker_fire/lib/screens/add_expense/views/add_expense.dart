import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expenses_app/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:flutter_expenses_app/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:flutter_expenses_app/screens/add_expense/views/category_creation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool isLoading = false;

  late Expense expense;

  @override
  void initState() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId=const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if(state is CreateExpenseSuccess){
          Navigator.pop(context,expense);
        } else if(state is CreateExpenseLoading){
          setState(() {
            isLoading=true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Add Expenses',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _expenseController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: const Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 22,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.dollarSign,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: _categoryController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: expense.category == Category.empty
                                    ? Colors.white
                                    : Color(expense.category.color),
                                hintText: 'Category',
                                hintStyle: const TextStyle(
                                    color: Colors.black54, fontSize: 22),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                prefixIcon: expense.category == Category.empty
                                    ? const Icon(
                                        size: 20,
                                        FontAwesomeIcons.listCheck,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        size: 32,
                                        IconData(expense.category.icon,
                                            fontFamily: 'MaterialIcons'),
                                      ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    var newCategory =
                                        await getCategoryCreation(context);
                                    setState(() {
                                      state.categories.insert(0, newCategory);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20)),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Card(
                                    child: ListView.builder(
                                        itemCount: state.categories.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ListTile(
                                              leading: Icon(
                                                IconData(
                                                    state
                                                        .categories[index].icon,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Colors.black,
                                                size: 32,
                                              ),
                                              title: Text(
                                                  state.categories[index].name),
                                              tileColor: Color(state
                                                  .categories[index].color),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  expense.category =
                                                      state.categories[index];
                                                  _categoryController.text =
                                                      expense.category.name;
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _noteController,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Note',
                                hintStyle: const TextStyle(
                                    color: Colors.black54, fontSize: 22),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: const Icon(
                                  size: 20,
                                  FontAwesomeIcons.noteSticky,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textAlign: TextAlign.center,
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Today',
                                hintStyle: const TextStyle(
                                    color: Colors.black54, fontSize: 22),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: const Icon(
                                  size: 20,
                                  FontAwesomeIcons.calendarDay,
                                  color: Colors.black54,
                                ),
                              ),
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                if (newDate != null) {
                                  setState(() {
                                    _dateController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(newDate);
                                    expense.date = newDate;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        // const Spacer(),
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
                          child:isLoading
                            ? const Center(child:CircularProgressIndicator()) :TextButton(
                            onPressed: () {
                              setState(() {
                                expense.amount =
                                    int.parse(_expenseController.text);
                                expense.note=_noteController.text;
                              });
                              context
                                  .read<CreateExpenseBloc>()
                                  .add(CreateExpense(expense: expense));
                            },
                            child: const Text(
                              'SAVE',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
