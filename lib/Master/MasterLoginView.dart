import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skensa/Master/ConfigurationView.dart';
import 'package:skensa/Style/LoginViewStyle.dart';

class MasterLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            color: Colors.lightBlue,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: double.maxFinite,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/skensa.png"),
                            width: 40,
                          ),
                          Txt(
                            "  SKENSA",
                            style: LoginViewStyle.fontStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Parent(
                    style: LoginViewStyle.loginContainer.clone()
                      ..width(double.maxFinite)
                      ..borderRadius(topLeft: 40, topRight: 40)
                      ..padding(top: 40, horizontal: 20),
                    child: Column(
                      children: [
                        Txt(
                          "LOGIN Master",
                          style: LoginViewStyle.fontStyle.clone()
                            ..textColor(Colors.lightBlue),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13))),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13))),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage("assets/skensa.png"),
                                width: 30,
                              ),
                              Txt(
                                "   Login With Master Account SKENSA",
                                style: TxtStyle()
                                  ..bold()
                                  ..fontSize(18)
                                  ..textColor(Colors.white)
                                  ..textOverflow(TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          color: Colors.cyan,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfigurationView()));
                          },
                        ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
