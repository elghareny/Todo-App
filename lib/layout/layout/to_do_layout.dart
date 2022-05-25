import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_application/layout/layout/cubit/cubit.dart';
import 'package:my_application/layout/layout/cubit/states.dart';
import 'package:my_application/shared/components/components.dart';

// ignore: must_be_immutable
class DefaultLayout extends StatelessWidget{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ToDoCubit()..createDataBase(),
      child: BlocConsumer<ToDoCubit,ToDoStates>(
        listener: ( context, state) {
          if(state is InsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: ( context, state) {
          var cubit= ToDoCubit.get(context);
          return Scaffold(
            key: scaffoldKey ,
            appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
              actions: [
                IconButton(icon: Icon(Icons.search),
                    onPressed: ()
                    {

                    })
              ],
            ),
            body: ConditionalBuilder(
              condition: state is !GetDatabaseLoadingState,
              builder: (context)=> cubit.screens[cubit.currentIndex],
              fallback: (context)=>Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                items: cubit.bottomItems,
                onTap: (index)
                {
                  cubit.currentItem(index);
                }
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.sheetIcon),
              onPressed: ()
              {
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value)
                    // {
                    //   getDataFromDatabase(database).then((value)
                    //   {
                    //     // setState(() {
                    //     //   Navigator.pop(context);
                    //     //   isBottomSheetShown = false;
                    //     //   sheetIcon =Icons.edit;
                    //     //   tasks= value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    //
                    // });
                  }
                }else
                {
                  scaffoldKey.currentState.showBottomSheet(
                        (context)=>Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft:Radius.circular(10.0) ,
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.zero,
                            topRight: Radius.circular(10.0)
                        ),
                        border: Border.all(
                            color: Colors.grey
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(20.0),

                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                                label: 'Title',
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                prefixIcon: Icons.title,
                                validate: (String value)
                                {
                                  if(value.isEmpty)
                                  {
                                    return 'please enter the title';
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(height: 20.0,),
                            defaultTextFormField(
                                label: 'Time',
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                prefixIcon: Icons.watch_later_outlined,
                                validate: (String value)
                                {
                                  if(value.isEmpty)
                                  {
                                    return 'please enter the time';
                                  }
                                  return null;
                                },
                                onTap: ()
                                {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value)
                                  {
                                    timeController.text =value.format(context).toString();
                                  });
                                }
                            ),
                            SizedBox(height: 20.0,),
                            defaultTextFormField(
                                label: 'Date',
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                prefixIcon: Icons.calendar_today,
                                validate: (String value)
                                {
                                  if(value.isEmpty)
                                  {
                                    return 'please enter the date';
                                  }
                                  return null;
                                },
                                onTap: ()
                                {
                                  showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2021-12-30'),
                                  ).then((value)
                                  {
                                    dateController.text = DateFormat.yMMMMd().format(value);
                                  });
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 50.0,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }

              },
            ),
          );
        },

      ),
    );
  }
}
