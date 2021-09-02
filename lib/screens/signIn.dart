import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/screens/main_shop.dart';
import 'package:stoerrmutl/screens/main_user.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';
import 'package:stoerrmutl/utility/normal_dialog.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String gender, name, username, password, phone, profile, token, chooseType;

  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<Null> checkPreferance() async {
    try {
      findLatLng();
    } catch (e) {}
  }

  Future<Null> findLatLng() async {
    await Firebase.initializeApp().then((value) async {
      print('#### inisial Success ####');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.getToken().then((value) => token = value.trim());
      print('Token == $token');
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String chooseType = preferences.getString(MyConstant().keyType);
    String idLogin = preferences.getString(MyConstant().keyid);
    print('##### chooseType == $chooseType ######');
    print('#####    idLogin == $idLogin    ######');
    if (idLogin != Null && idLogin.isNotEmpty) {
      String url =
          '${MyConstant().domain}/StoresRMUTL/API/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';
      await Dio()
          .get(url)
          .then((value) => print('#### Update Token Success ####'));
    }
    if (chooseType != null && chooseType.isNotEmpty) {
      if (chooseType == 'customer') {
        profile == null
            ? MyStyle().showProgress()
            : routeTuService1(MainUser());
      } else if (chooseType == 'store') {
        profile == null
            ? MyStyle().showProgress()
            : routeTuService1(MainShop());
      } else {
        normalDialog(context, 'Error User Type');
      }
    }
  }

  void routeTuService1(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กรุณาทำการ Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyStyle().showLogo(),
              MyStyle().mySizebox(),
              MyStyle().showTitle('Stores RMUTL'),
              MyStyle().mySizebox(),
              userForm(),
              MyStyle().mySizebox(),
              passwordForm(),
              MyStyle().mySizebox(),
              loginButton(),
              builsignup(),
            ],
          ),
        ),
      ),
    );
  }

  Row builsignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ไม่ได้สมัครสมาชิก ?'),
        TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routesignUp),
            child: Text('สมัครสมาชิก'))
      ],
    );
  }

  Widget loginButton() => Container(
      width: 250.0,
      child: RaisedButton(
        color: MyStyle().darkColor,
        onPressed: () {
          if (username == null ||
              username.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'กรุณกรอก username หรือ password ให้ครบ');
          } else {
            checkAuthen();
          }
        },
        child: Text('Loging', style: TextStyle(color: Colors.white)),
      ));

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/StoresRMUTL/API/getUserWhereUser.php?isAdd=true&username=$username';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      var result = json.decode(response.data);
      print('res = $result');
      if (result == null) {
        normalDialog(context, 'user ผิดกรุณาลองใหม่');
      }
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String chooseType = userModel.chooseType;
          if (chooseType == 'customer') {
            routeTuService(MainUser(), userModel);
          } else if (chooseType == 'store') {
            routeTuService(MainShop(), userModel);
          } else {
            normalDialog(context, 'มีข้อผิดพลาดกรุณาลองใหม่');
          }
        } else {
          normalDialog(context, 'Password ผิดกรุณาลองใหม่');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MyConstant().keyid, userModel.id);
    preferences.setString(MyConstant().keyType, userModel.chooseType);
    preferences.setString(MyConstant().keyname, userModel.name);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => username = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'password :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
}
