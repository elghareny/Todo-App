
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_application/layout/layout/cubit/cubit.dart';
import 'package:my_application/layout/layout/cubit/states.dart';
import 'package:my_application/shared/components/components.dart';

class Tasks extends StatelessWidget {

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ToDoCubit,ToDoStates>(
      listener: ( context, state) {  },
      builder: ( context, state) {

        var tasks =ToDoCubit.get(context).newTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}