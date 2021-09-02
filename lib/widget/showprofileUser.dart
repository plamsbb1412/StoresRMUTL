import 'package:flutter/material.dart';
import 'package:stoerrmutl/model/user_model.dart';
import 'package:stoerrmutl/utility/my_constant.dart';
import 'package:stoerrmutl/utility/my_style.dart';

class infoprofileUser extends StatefulWidget {
  final UserModel userModel;
  infoprofileUser({Key key, this.userModel}) : super(key: key);
  @override
  _infoprofileUserState createState() => _infoprofileUserState();
}

class _infoprofileUserState extends State<infoprofileUser> {
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
          leading: MyStyle().showTitleH2('ชื่อ'),
          title: Text(userModel.name),
        ),
        ListTile(
          leading: MyStyle().showTitleH2('Username'),
          title: Text(userModel.username),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(userModel.phoneNumber),
        )
      ],
    );
  }
}
