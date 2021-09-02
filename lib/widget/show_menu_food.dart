import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stoerrmutl/model/cart_model.dart';
import 'package:stoerrmutl/model/food_model.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';
import 'package:stoerrmutl/utility/normal_dialog.dart';
import 'package:stoerrmutl/utility/sqlite_helper.dart';
import 'package:toast/toast.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  ShowMenuFood({Key key, this.userModel}) : super(key: key);
  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel userModel;
  String idShop;
  List<FoodModel> foodModels = List();
  int amount = 1;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;

    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        '${MyConstant().domain}/StoresRMUTL/API/getFoodWhereidshop.php?isAdd=true&id_store=$idShop';
    Response response = await Dio().get(url);
    // print('response = $response');

    var result = json.decode(response.data);
    // print('result = $result');
    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                print('Clic index = $index');
                amount = 1;
                confirmOrder(index);
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: <Widget>[
                    showFoodImage(context, index),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 - 16,
                      height: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'ชื่อเมนู ${foodModels[index].nameManu}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(foodModels[index].quantity),
                          Text('ราคา ${foodModels[index].price} บาท'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.5 - 16.0,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image:
              NetworkImage('${MyConstant().domain}${foodModels[index].images}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                title: Column(
                  children: [
                    Text('คุณต้องการซื้อ'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(foodModels[index].nameManu),
                      ],
                    ),
                  ],
                ),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    width: 150,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${MyConstant().domain}${foodModels[index].images}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'จำนวน',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 36,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            amount++;
                          });
                        },
                      ),
                      Text(amount.toString()),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: 36,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (amount > 1) {
                            setState(() {
                              amount--;
                            });
                          }
                        },
                      )
                    ],
                  ),
                  MyStyle().mySizebox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          print(
                              'Order ${foodModels[index].nameManu} = $amount');
                          addOrderToCart(index);
                        },
                        child: Text(
                          'Order',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ));
  }

  Future<Null> addOrderToCart(int index) async {
    String nameStore = userModel.nameStore;
    String idFood = foodModels[index].id;
    String nameFood = foodModels[index].nameManu;
    String price = foodModels[index].price;

    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;

    print(
        'idstore = $idShop, namestore = $nameStore, idFood = $idFood, nameFood = $nameFood, price = $price, sum =$sumInt');

    Map<String, dynamic> map = Map();
    map['idStore'] = idShop;
    map['nameStore'] = nameStore;
    map['idFood'] = idFood;
    map['nameFood'] = nameFood;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();

    print('map ==> ${map.toString()}');
    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFromSQLite();
    print('##########  object = ${object.length}');

    await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
      print('######  Insert Success');
    });
  }

  void showToast(String string) {
    // Toast.show(
    //   string,
    //   context,
    //   duration: Toast.LENGTH_LONG,
    // );
  }
}
