import 'package:flutter/material.dart';


class LoginBackground extends StatelessWidget {

  final Widget child;
  const LoginBackground({Key? key, required this.child}) : super(key: key);

//   @override
//   _LoginBackgroundState createState() => _LoginBackgroundState(child: this.child);
// }
//
// class _LoginBackgroundState extends State<LoginBackground> {
//
//   final Widget child;
//   const _LoginBackgroundState({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(1.0),
                      Colors.red.withOpacity(1.0)
                    ]
                  )
                ),
              )
          ),
          Positioned(
            left: 0,
            bottom: 20,
            right: 0,
            child: Image.asset(
              "assets/images/sutherland-logo-white.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/images/chatbot.png",
              width: size.width * 0.5,
              height: size.height * 0.35,
            ),
          ),
          child
        ],
      ),
    );
  }


}