import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/todo_app/archive/archive.dart';
import 'package:todo_app/modules/todo_app/done/done_tasks.dart';
import 'package:todo_app/modules/todo_app/tasks/new_task.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_cubit.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var tittle = TextEditingController();
  var date = TextEditingController();
  var time = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ToDoCubit(InitialState())..createDatabase(),
      child: BlocConsumer<ToDoCubit, ToDoAppStates>(
        listener: (context, state) {
          if(state is InsertToDatabase){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          ToDoCubit cubit = ToDoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                "ToDo App",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              centerTitle: true,
            ),
            body: ConditionalBuilder(
              condition: state is !GetFromDatabaseLoading,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    label: "Tasks", icon: Icon(Icons.menu_outlined)),
                BottomNavigationBarItem(
                    label: "Done", icon: Icon(Icons.check_circle_outline)),
                BottomNavigationBarItem(
                    label: "Archive", icon: Icon(Icons.archive_outlined)),
              ],
              currentIndex: cubit.currentIndex,
              onTap: (index) => {cubit.changeIndexBottomNavigationBar(index)},
              elevation: 10.0,
              type: BottomNavigationBarType.fixed,
              iconSize: 25,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.flotingAction),
              splashColor: Colors.black26,
              onPressed: () {
                if (cubit.bottomSheet) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(tittle: tittle.text,
                        date: date.text,
                        time: time.text);
                    cubit.bottomSheet = false;
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                    label: "Tittle Task ",
                                    controller: tittle,
                                    type: TextInputType.text,
                                    prefix: Icon(Icons.title),
                                    valid: (String value) {
                                      if (value.isEmpty)
                                        return ' tittle must no\'t be Empty';
                                    },
                                    focus: true,
                                    correct: true,
                                    onTap: () {}),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                    label: "Time Task",
                                    controller: time,
                                    type: TextInputType.datetime,
                                    prefix: Icon(Icons.watch_later_outlined),
                                    valid: (String value) {
                                      if (value.isEmpty)
                                        return ' Time must no\'t be Empty';
                                    },
                                    focus: false,
                                    correct: false,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        time.text =
                                            value.format(context).toString();
                                      }).catchError((error) {
                                        print(error.toString());
                                      });
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                    label: "Date Task",
                                    controller: date,
                                    type: TextInputType.datetime,
                                    prefix: Icon(Icons.calendar_today_outlined),
                                    valid: (String value) {
                                      if (value.isEmpty)
                                        return ' Date must no\'t be Empty';
                                    },
                                    focus: false,
                                    correct: false,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-01-01'))
                                          .then((value) {
                                        date.text =
                                            DateFormat.yMMMd().format(value);
                                      }).catchError((error) {
                                        print(error.toString());
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                        elevation: 40.0,
                      ).closed
                      .then((value) {
                    cubit.changeIconBottomSheet(
                        bottomSheetShow: false, flotingIcon: Icons.edit);
                  });
                  cubit.changeIconBottomSheet(
                      bottomSheetShow: true, flotingIcon: Icons.add);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
