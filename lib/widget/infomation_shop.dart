import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/screens/add_info_shop.dart';
import 'package:stoerrmutl/screens/edit_info_shop.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';

class InfomationShop extends StatefulWidget {
  @override
  _InfomationShopState createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url =
        '${MyConstant().domain}/StoresRMUTL/API/getUserWhereID.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      //print('value = $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('namestoer = ${userModel.nameStore}');
      }
    });
  }

  void routeToAddInfo() {
    Widget widget =
        userModel.nameStore.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel.nameStore.isEmpty
                ? showNoData(context)
                : showListinfoShop(),
        addAnEditButton(),
      ],
    );
  }

  Widget showListinfoShop() => Column(
        children: <Widget>[
          MyStyle().showTitle('รายละเอียดของร้าน ${userModel.nameStore}'),
          showImage(),
          MyStyle().showTitleH1('ชื่อเจ้าของร้าน ${userModel.name}'),
          Row(
            children: [
              MyStyle().showTitleH2('เบอร์โทรติดต่อ'),
            ],
          ),
          Row(
            children: [
              Text(userModel.phoneNumber),
            ],
          ),
        ],
      );

  Container showImage() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network('${MyConstant().domain}${userModel.profile}'),
    );
  }

  Widget showNoData(BuildContext context) => MyStyle().titleCenter(context,
      'ยังไม่มีข้อมูลกรุณาเพิ่มข้อมูลแล้วทำการ Sign out แล้ว Sign in ใหม่ด้วย');

  Row addAnEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 16.0,
                bottom: 16.0,
              ),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  print('you click floating');
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
