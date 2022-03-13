import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_cubit.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tasksItem(list: ToDoCubit.get(context).newTask);
  }
}
