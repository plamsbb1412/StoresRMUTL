import 'package:flutter/material.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  AboutShop({Key key, this.userModel}) : super(key: key);
  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(16.0),
              width: 150.0,
              height: 150.0,
              child:
                  Image.network('${MyConstant().domain}${userModel.profile}'),
            ),
          ],
        ),
        ListTile(
          leading: MyStyle().showTitleH2('ชื่อร้าน'),
          title: Text(userModel.nameStore),
        ),
        ListTile(
          leading: MyStyle().showTitleH2('ชื่อคนขาย'),
          title: Text(userModel.name),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(userModel.phoneNumber),
        )
      ],
    );
  }
}
