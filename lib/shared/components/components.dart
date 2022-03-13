import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_cubit.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_states.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 40.0,
  Color color = Colors.blueAccent,
  @required Function function,
  @required String text,
  double radius = 0.0,
}) =>
    Container(
      width: width,
      height: height,
      child: TextButton(
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
      ),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
    );

Widget defaultTextFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required String label,
  @required Icon prefix,
  @required Function valid,
  bool correct = true,
  bool focus = true,
  bool isPassword = false,
  Icon suffix,
  Function onChanged,
  Function onSubmitted,
  Function suffixPressed,
  Function onTap,
}) =>
    TextFormField(
      validator: valid,
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      autocorrect: true,
      autofocus: true,
      textAlign: TextAlign.start,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        prefixIcon: prefix,
        suffixIcon: suffix != null
            ? IconButton(
                icon: suffix,
                onPressed: suffixPressed,
              )
            : null,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );

Widget buildTaskItem({Map model, context}) => Dismissible(
    child: Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                "${model['time']}",
                style: TextStyle(color: Colors.black),
              ),
              radius: 44,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 4,
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  ToDoCubit.get(context)
                      .update(status: 'done', id: model['id']);
                }),
            SizedBox(
              width: 4,
            ),
            IconButton(
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                ),
                onPressed: () {
                  ToDoCubit.get(context)
                      .update(status: 'archive', id: model['id']);
                }),
          ],
        ),
      ),
    ),
    key: Key(model['id'].toString()),
    //UniqueKey()
    onDismissed: (direction) {
      ToDoCubit.get(context).deleteData(id: model['id']);
    },
    direction: DismissDirection.horizontal,
    background: Container(
        child: Icon(
          Icons.all_inclusive,
          color: Colors.white,size: 40,
        ),
        color: Color(0xFF51205A)),
    secondaryBackground: Container(
        child: Icon(
          Icons.all_inclusive,
          color: Colors.black,
          size: 40,
        ),
        color: Colors.red));

Widget tasksItem({@required List<Map> list}) =>
    BlocConsumer<ToDoCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: list.length > 0,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskItem(model: list[index], context: context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, bottom: 8),
              child: Container(
                width: double.infinity,
                height: 2,
                color: Colors.grey,
              ),
            ),
            itemCount: list.length,
          ),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                  "No Task yet , please Add Some Tasks",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
