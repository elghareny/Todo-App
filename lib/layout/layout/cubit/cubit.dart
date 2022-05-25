import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_application/layout/layout/cubit/states.dart';
import 'package:my_application/modules/todo/archived.dart';
import 'package:my_application/modules/todo/done.dart';
import 'package:my_application/modules/todo/tasks.dart';
import 'package:sqflite/sqflite.dart';

class ToDoCubit extends Cubit<ToDoStates>
{
  ToDoCubit() : super(ToDoInitialState());
  static ToDoCubit get(context)=>BlocProvider.of(context);


  ////////////////////   Bottom NAv Bar   /////////////////////////


  List<Widget>screens=
  [
    Tasks(),
    Done(),
    Archived(),
  ];

  List<String>titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];


  int currentIndex =0;
  List<BottomNavigationBarItem>bottomItems=
  [
    BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      label: 'Tasks',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.check_circle),
      label: 'Done',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.archive),
      label: 'Archived',
    )
  ];

  void currentItem(index)
  {
    currentIndex=index;
    emit(ChangeNavBarState());
  }

  //////////////////  Database   ///////////////////////

  Database database;
  List <Map> newTasks=[];
  List <Map> doneTasks=[];
  List <Map> archivedTasks=[];

  void createDataBase()
  {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version)
        {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, time TEXT, date TEXT,status TEXT)'
          ).then((value)
          {
            print('table created');
          }).catchError((error)
          {
            print('error on table created ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('database opened');
        },
    ).then((value)
     {
       database = value;
       emit(CreateDatabaseState());
     });
  }

  insertToDatabase({
    @required title,
    @required time,
    @required date,
  })async
  {
    await database.transaction((txn){
      txn.rawInsert('INSERT INTO tasks(title ,time, date ,status ) VALUES("$title"," $time"," $date","new")'
      ).then((value){
        print('inserted successfully ${value.toString()}');
        emit(InsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('Error When inserted Table ${error.toString()}');
      });
      return null;
    });
  }


  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(GetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new')
        {
          newTasks.add(element);
        }else if(element['status'] == 'done')
        {
          doneTasks.add(element);
        }else
          {
            archivedTasks.add(element);
          }
      });

      emit(GetDatabaseState());
    });
  }


  void updateData({
  @required String status,
    @required int id
})async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }


  void deleteData({
    @required int id
  })async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }


  ////////////////////////  Fab Icon   ////////////////////////////////////

  bool isBottomSheetShown = false;
  IconData sheetIcon = Icons.edit;

  void changeBottomSheetState({
  @required bool isShow,
    @required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    sheetIcon = icon;

    emit(ChangeBottomSheetState());
  }


}