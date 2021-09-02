import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoerrmutl/model/cart_model.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';
import 'package:stoerrmutl/utility/normal_dialog.dart';
import 'package:stoerrmutl/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  int total = 0;
  bool status = true;
  bool load = true;
  List<CartModel> cartModels = [];

  List<String> nameProducts = [];
  List<String> prices = [];
  List<String> amounts = [];
  List<String> sums = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    if (cartModels.length != 0) {
      cartModels.clear();
      total = 0;
      nameProducts.clear();
      prices.clear();
      amounts.clear();
      sums.clear();
    }

    await SQLiteHelper().readAllDataFromSQLite().then((value) {
      print('object length ==> ${value.length}');
      setState(() {
        load = false;
      });
      if (value.length != 0) {
        for (var model in value) {
          String sumString = model.sum;
          int sumInt = int.parse(sumString);

          nameProducts.add(model.nameFood);
          prices.add(model.price);
          amounts.add(model.amount);
          sums.add(sumString);

          setState(() {
            status = false;
            cartModels = value;
            total = total + sumInt;
          });
        }
      } else {
        setState(() {
          status = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: load
          ? MyStyle().showProgress()
          : cartModels.length == 0
              ? Center(child: MyStyle().showTitleH1('ไม่มี สินค้าใน ตระกล้า'))
              : Column(
                  children: <Widget>[
                    buildHead(),
                    buildListFood(),
                    buildTotal(),
                    buildOrder(),
                  ],
                ),
    );
  }

  Row buildOrder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            // idSeller, nameSeller, dateSeller, listNameProduct, listPrice, listAmount, listSum, total, status
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String idSeller = preferences.getString('id');
            String nameSeller = preferences.getString('name');
            String dateSeller = DateTime.now().toString();
            String listNameProduct = nameProducts.toString();
            String listPrice = prices.toString();
            String listAmount = amounts.toString();
            String listSum = sums.toString();

            print(
                '##### idSeller = $idSeller, nameSeller = $nameSeller, dateSeller = $dateSeller');
            print('### listnameProduct = $listNameProduct');
            print('### listPrice = $listPrice');
            print('### listAmount = $listAmount');
            print('### listSum = $listSum');

            String apiGetUserWhereId =
                '${MyConstant().domain}/StoresRMUTL/API/getUserWhereId.php?isAdd=true&id=$idSeller';
            await Dio().get(apiGetUserWhereId).then((value) async {
              for (var item in json.decode(value.data)) {
                UserModel model = UserModel.fromJson(item);

                String apiAddOrder =
                    'https://04d2db38b589.ngrok.io/StoresRMUTL/API/addOrder.php?isAdd=true&idSeller=$idSeller&nameSeller=$nameSeller&dateSeller=$dateSeller&listNameProduct=$listNameProduct&listPrice=$listPrice&listAmount=$listAmount&listSum=$listSum&total=$total';
                await Dio().get(apiAddOrder).then((value) async {
                  if (value.toString() == 'true') {
                    await SQLiteHelper()
                        .deleteAll()
                        .then((value) => Navigator.pop(context));
                  } else {}
                });
              }
            });
          },
          icon: Icon(Icons.money),
          label: Text('สั่งซื้อ'),
        ),
      ],
    );
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Total :'),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(total.toString()),
        ),
      ],
    );
  }

  Row buildHead() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text('Product'),
        ),
        Expanded(
          flex: 1,
          child: Text('Price'),
        ),
        Expanded(
          flex: 1,
          child: Text('Amount'),
        ),
        Expanded(
          flex: 1,
          child: Text('Sum'),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(cartModels[index].nameFood),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].price),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].amount),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].sum),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () async {
                  print('#### You Delete id ===> ${cartModels[index].id}');
                  await SQLiteHelper()
                      .deleteSQLiteWhereId(cartModels[index].id)
                      .then((value) => readSQLite());
                },
                icon: Icon(Icons.delete_forever),
              ),
            ),
          ],
        ),
      );
}
