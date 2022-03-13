import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/todo_app/archive/archive.dart';
import 'package:todo_app/modules/todo_app/done/done_tasks.dart';
import 'package:todo_app/modules/todo_app/tasks/new_task.dart';
import 'package:todo_app/shared/cubit/todo_app/todo_states.dart';

class ToDoCubit extends Cubit<ToDoAppStates> {
  // ignore: non_constant_identifier_names
  ToDoCubit(ToDoAppStates InitialState) : super(InitialState);
  List<Widget> screen = [
    NewTaskScreen(),
    DoneTasksScreen(),
    ArchiveScreen(),
  ];
  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archiveTask = [];
  int currentIndex = 0;
  IconData flotingAction = Icons.edit;
  bool bottomSheet = false;
  Database database;

  static ToDoCubit get(context) => BlocProvider.of(context);

  void changeIndexBottomNavigationBar(int index) {
    currentIndex = index;
    emit(ChangeIndexBottomNavigationBar());
  }

  void changeIconBottomSheet(
      {@required bool bottomSheetShow, @required IconData flotingIcon}) {
    flotingAction = flotingIcon;
    bottomSheet = bottomSheetShow;
    emit(ChangeIconBottomSheet());
  }

  void createDatabase() {
    openDatabase(
      "todoapp.db",
      version: 1,
      onCreate: (database, version) {
        print("database created ");
        database
            .execute(
                'CREATE TABLE task (id INTEGER PRIMARY KEY,title TEXT ,date TEXT ,time TEXT,status TEXT )')
            .then((value) {
          print("table created");
        }).catchError((error) {
          print('Error on created Table${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(CreateDatabase());
    });
  }

  insertToDatabase(
      {@required String tittle,
      @required String date,
      @required String time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO task (title,date,time,status) VALUES("$tittle","$date","$time","new")')
          .then((value) {
        print("$value insert Successfully");
        emit(InsertToDatabase());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("${error.toString()}");
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTask.clear();
    doneTask.clear();
    archiveTask.clear();
    emit(GetFromDatabaseLoading());
    database.rawQuery('SELECT * FROM task').then((List<Map> value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTask.add(element);
        } else if (element['status'] == 'done') {
          doneTask.add(element);
        } else {
          archiveTask.add(element);
        }
      });
      emit(GetFromDatabase());
    });
  }

  void update({@required status, @required int id}) async {
    database.rawUpdate('UPDATE task SET status = ? WHERE id = ?', [
      '$status',
      id
    ]).then((value) => {
          emit(UbDateDataBase()),
          getDataFromDatabase(database),
        });
  }

  void deleteData({@required int id}) async {
    database.rawDelete('DELETE FROM task  WHERE id = ?', [id]).then((value) => {
          emit(DeleteDataBase()),
          getDataFromDatabase(database),
        });
  }
}
