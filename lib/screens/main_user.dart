import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/screens/show_cart.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';
import 'package:stoerrmutl/utility/signout_process.dart';
import 'package:stoerrmutl/widget/show_list_shop_all.dart';
import 'package:stoerrmutl/widget/show_status_food_order.dart';
import 'package:stoerrmutl/widget/showprofileUser.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser, profile, phoneNumber;
  String money;
  Widget currentWidget;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    findUser();
    currentWidget = ShowListShopAll();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String apiGetUserWhereId =
        '${MyConstant().domain}/StoresRMUTL/API/getUserWhereID.php?isAdd=true&id=${preferences.getString('id')}';
    await Dio().get(apiGetUserWhereId).then((value) {
      // print('value = $value');
      var result = json.decode(value.data);
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('name = ${userModel.name}');
        print('profile2 = ${userModel.profile}');

        nameUser = userModel.name;
        profile = userModel.profile;
        phoneNumber = userModel.phoneNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          MyStyle().iconShowCart(context),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                infoUser(),
                menuListShop(),
                menuCart(),
                menuStatusFoodOrder(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                menuSignOut(),
              ],
            ),
          ],
        ),
      );

  ListTile infoUser() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = infoprofileUser();
        });
      },
      leading: Icon(Icons.restaurant_menu),
      title: Text('รายละเอียดของ $nameUser'),
      subtitle: Text('แสดงรายเอียดต่าง ๆ ของ $nameUser'),
    );
  }

  ListTile menuListShop() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListShopAll();
        });
      },
      leading: Icon(Icons.home),
      title: Text('แสดงร้านค้า'),
      subtitle: Text('แสดงร้านค้า ที่สามารถสั่งอาหารได้'),
    );
  }

  ListTile menuStatusFoodOrder() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowStatusFoodOrder();
        });
      },
      leading: Icon(Icons.restaurant_menu),
      title: Text('แสดงรายการอาหารที่สั่ง'),
      subtitle: Text('แสดงรายการอาหารที่สั่ง และ หรือ ดูสถานะของอาหารที่สั่ง'),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade700),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'การออกจากแอพ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      accountName: Text('ผู้ใช่งาน: $nameUser'),
      accountEmail: Text('เบอร์โทรติดต่อ: $phoneNumber'),
      decoration: MyStyle().myBoxDecoration('guest.jpg'),
      currentAccountPicture: CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant().domain}${userModel.profile}')),
    );
  }

  Widget menuCart() {
    return ListTile(
      leading: Icon(Icons.add_shopping_cart),
      title: Text('ตะกร้า ของฉัน'),
      subtitle: Text('รายการอาหาร ที่อยู่ใน ตะกร้า ยังไม่ได้ Order'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }
}
