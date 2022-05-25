
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_application/layout/layout/cubit/cubit.dart';

Widget defaultTextFormField({
  bool isPassword =false,
  @required String label,
  Function onTap,
  Function onSubmit,
  @required Function validate,
  @required TextEditingController controller,
  @required TextInputType keyboardType ,
  @required IconData prefixIcon,
  IconData suffixIcon,
})=> TextFormField(
obscureText: isPassword,
onTap: onTap,
onFieldSubmitted: onSubmit,
validator: validate,
controller: controller,
keyboardType: keyboardType,
decoration: InputDecoration(
labelText: label,
prefixIcon: Icon(prefixIcon),
suffixIcon:suffixIcon !=null ?Icon(suffixIcon):null,
border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 10.0),
borderRadius: BorderRadius.circular(10.0)
),
),
);

Widget defaultButton({
  Color backcolor = Colors.blue,
  double width=double.infinity,
  String text,
  Function onPressed,
}) =>
    Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
        topLeft:Radius.zero ,
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
        topRight: Radius.circular(20.0)),
    color: backcolor,
  ),
  width: width,
  height: 55.0,
  child: MaterialButton(
    child: Text(text,
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          color: Colors.white
      ),
    ),
    onPressed: onPressed,
  ),
);

//////////////////////////////////////////////////////////////////////////


Widget buildTaskItem (Map model ,context)=>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {
    ToDoCubit.get(context).deleteData(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.deepPurpleAccent,
          child: Text('${model['time']}',
            style: TextStyle(
                color: Colors.white
            ),),
          radius: 40.0,
        ),
  
        SizedBox(width: 20.0,),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text('${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 20.0,
  
                  fontWeight: FontWeight.w400,
  
                ),),
  
              SizedBox(height: 10.0,),
  
              Text('${model['date']}',
  
                style: TextStyle(
  
                    color: Colors.grey
  
                ),),
  
            ],
  
          ),
  
        ),
  
        SizedBox(width: 20.0,),
  
        IconButton(
  
            icon: Icon(
  
              Icons.check_box,
  
              color: Colors.green,),
  
            onPressed: ()
  
            {
  
              ToDoCubit.get(context).updateData(
  
                  status: 'done',
  
                  id: model['id']);
  
            }),
  
        IconButton(
  
            icon: Icon(
  
              Icons.archive,
  
              color: Colors.black45,),
  
            onPressed: ()
  
            {
  
              ToDoCubit.get(context).updateData(
  
                  status: 'archive',
  
                  id: model['id']);
  
            }),
  
      ],
  
    ),
  
  ),
);


////////////////////////////////////////   Tasks Builder /////////////////////////////////////////////


Widget tasksBuilder({
  @required List<Map>tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index) =>Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,
          size: 120.0,
          color: Colors.grey,),
        Text('No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),)
      ],
    ),
  ),
);