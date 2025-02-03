import 'package:crudapp/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CrudApp());
}

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textColor: Colors.black,
          tileColor: Colors.pink.shade100,
        ),
        scaffoldBackgroundColor: Colors.pink.shade50,
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 48),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          iconSize: 30,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.pink,
          actionsIconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.pink),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink, width: 2),
          ),
        ),
      ),
      title: 'Crud App',
      home: HomePage(),
    );
  }
}
