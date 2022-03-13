import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_cubit.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_states.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tasksItem(list: ToDoCubit.get(context).archiveTask);
  }
}
