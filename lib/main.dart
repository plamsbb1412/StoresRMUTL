import 'package:flutter/material.dart';
import 'package:stoerrmutl/screens/home.dart';
import 'package:stoerrmutl/screens/signIn.dart';
import 'package:stoerrmutl/screens/signup.dart';
import 'package:stoerrmutl/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/signin': (BuildContext context) => SignIn(),
  '/signup': (BuildContext context) => SignUp(),
};

String initlalRoute;

void main() {
  initlalRoute = MyConstant.routesignIN;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlalRoute,
    );
  }
}
