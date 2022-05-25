import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_application/shared/components/components.dart';

import 'layout/layout/to_do_layout.dart';

void main ()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 5.0,
          backwardsCompatibility: false,
          titleTextStyle: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 25.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 4.0,
          ),
          iconTheme: IconThemeData(
            color: Colors.deepPurpleAccent,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 20.0,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: Colors.deepPurpleAccent
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 10.0
        ),
      ),
      home: DefaultLayout(),
    );
  }

}