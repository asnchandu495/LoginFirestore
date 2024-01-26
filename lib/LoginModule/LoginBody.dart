// import 'dart:ffi';
import 'dart:async';

import 'package:chatbotapp/Utilities//constant.dart';
import 'package:chatbotapp/DashboardModule/DashboardScreen.dart';
import 'package:chatbotapp/LoginModule/LoginBackground.dart';
import 'package:chatbotapp/LoginModule/LoginDataModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:toast/toast.dart';
// import 'package:fluttertoast/fluttertoast.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  static const Color loginGradientStart = Color(0xFFfbab66);
  static const Color loginGradientEnd =  Color(0xFFf7418c);

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController =  TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;

  List<LoginDataModel> allUsers = [];

  @override
  Widget build(BuildContext context) {

    firebaseInitialize();


    // TODO: implement build
    return  LoginBackground(
       child: SingleChildScrollView(
        // padding: const EdgeInsets.only(top: 23.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children:  <Widget>[
             Stack(
               alignment: Alignment.center,
               overflow: Overflow.visible,
               children: <Widget>[
                 Card(
                   elevation: 2.0,
                   color: Colors.white,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8.0),
                   ),
                   child: SizedBox(
                     width: 300.0,
                     height: 190.0,
                     child: Column(
                       children: <Widget>[
                         Padding(
                           padding: const EdgeInsets.only(
                               top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                           child: TextField(
                             focusNode: myFocusNodeEmailLogin,
                             controller: loginEmailController,
                             keyboardType: TextInputType.emailAddress,
                             style: const TextStyle(
                                 fontFamily: "WorkSansSemiBold",
                                 fontSize: 16.0,
                                 color: Colors.black),
                             decoration: const InputDecoration(
                               border: InputBorder.none,
                               icon: Icon(
                                 FontAwesomeIcons.envelope,
                                 color: Colors.black,
                                 size: 22.0,
                               ),
                               hintText: "Email Address",
                               hintStyle: TextStyle(
                                   fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                             ),
                           ),
                         ),
                         Container(
                           width: 250.0,
                           height: 1.0,
                           color: Colors.grey[400],
                         ),
                         Padding(
                           padding: const EdgeInsets.only(
                               top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                           child: TextField(
                             focusNode: myFocusNodePasswordLogin,
                             controller: loginPasswordController,
                             obscureText: _obscureTextLogin,
                             style: const TextStyle(
                                 fontFamily: "WorkSansSemiBold",
                                 fontSize: 16.0,
                                 color: Colors.black),
                             decoration: InputDecoration(
                               border: InputBorder.none,
                               icon: const Icon(
                                 FontAwesomeIcons.lock,
                                 size: 22.0,
                                 color: Colors.black,
                               ),
                               hintText: "Password",
                               hintStyle: const TextStyle(
                                   fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                               suffixIcon: GestureDetector(
                                 onTap: _toggleLogin,
                                 child: Icon(
                                   _obscureTextLogin
                                       ? FontAwesomeIcons.eye
                                       : FontAwesomeIcons.eyeSlash,
                                   size: 15.0,
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
                 Container(
                   margin: const EdgeInsets.only(top: 210.0),
                   decoration: const BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                     boxShadow: <BoxShadow>[
                       BoxShadow(
                         color: loginGradientStart,
                         offset: Offset(1.0, 6.0),
                         blurRadius: 20.0,
                       ),
                        BoxShadow(
                         color: loginGradientEnd,
                         offset: Offset(1.0, 6.0),
                         blurRadius: 20.0,
                       ),
                     ],
                     gradient: LinearGradient(
                         colors: [
                           loginGradientEnd,
                           loginGradientStart
                         ],
                         begin: FractionalOffset(0.2, 0.2),
                         end: FractionalOffset(1.0, 1.0),
                         stops: [0.0, 1.0],
                         tileMode: TileMode.clamp),
                   ),
                   child: MaterialButton(
                       highlightColor: Colors.transparent,
                       splashColor: loginGradientEnd,
                       //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                       onPressed: () {
                         print("print button action");
                         validationFields();
                       } ,
                       child: const Padding(
                         padding: EdgeInsets.symmetric(
                             vertical: 10.0, horizontal: 42.0),
                         child: Text(
                           "LOGIN",
                           style: TextStyle(
                               color: Colors.white,
                               fontSize: 25.0,
                               fontFamily: "WorkSansBold"),
                         ),
                       ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       )
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void validationFields() async {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    allUsers.clear();
    getData();
    // final FirebaseFirestore fb = FirebaseFirestore.instance;
    // final data =  await fb.collection("users").get(); //get the data
    // print("firebasedata:(data)");

    if (loginEmailController.text == null || loginEmailController.text.trim().isEmpty) {
    //  print('Please enter your email address');
      showToast(kEmailEmptyMessage);
    }
    else if (!regex.hasMatch(loginEmailController.text)) {
    //  print('Enter valid email address');
      showToast(kEmailValidMessage);
    }
    else if (loginPasswordController.text == null || loginPasswordController.text.trim().isEmpty) {
      // print('Please enter your password');
      showToast(kPasswordEmptyMessage);
    }
    else if (loginPasswordController.text.trim().length < 8) {
      // print('Password must be at least 8 characters in length');
      showToast(kPasswordValidMessage);
    } else {

      Timer(Duration(seconds: 3), () {

        // Do something
        print(allUsers);
        if (verifyEmail()) {

          showToast(kLoginSuccessMessage);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DashboardScreen()));

        } else {
          showToast(kLoginFailureMessage);
        }
      });


    }

  }
  bool verifyEmail() {
   // Bool isExist = false;
    for (int i = 0 ; i < allUsers.length; i++ ) {
         LoginDataModel dataVal = allUsers[i];
         if (loginEmailController.text == dataVal.email && loginPasswordController.text == dataVal.password) {
            return true;
         }
    }
    return false;
  }

  Future<void> getData() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(kFirebaseStoreName);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final  allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // print(allData);

     for (int i = 0 ; i < allData.length; i++ ) {
       final val = allData[i];
      // print(val["password"]);
       LoginDataModel loginModel = LoginDataModel(email: val[kFirebaseKeyEmailName], password: val[kFirebaseKayPasswordName]);
       allUsers.add(loginModel);
     }

  }

  void showToast(String toastVal) {
    print(toastVal);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(toastVal),
    ));
  }

  void firebaseInitialize() async {
     await Firebase.initializeApp();
  }

}

