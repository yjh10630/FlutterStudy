import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_flutter/login/login_page.dart';

import '../club/test.dart';
import '../utils/color_palette.dart';

class InitLoginPage extends StatefulWidget {
  const InitLoginPage({Key? key}) : super(key: key);

  @override
  _InitLoginPageState createState() => _InitLoginPageState();
}

class _InitLoginPageState extends State<InitLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('imgs/jordan.png', fit: BoxFit.fill),
          ),
          SizedBox.expand(
            child: Container(
              color: Colors.white30,
            ),
          ),
          Container(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      transitionDuration: Duration(milliseconds: 500),
                      openBuilder: (context, _) => LoginPage(pageIndex: 0,),
                      closedElevation: 0.0,
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(color: Colors.white, width: 1)),
                      closedColor: Colors.blue,
                      closedBuilder: (context, _) => Container(
                        alignment: Alignment.center,
                        width: double.infinity * 0.8,
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              '회원가입',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                      ),
                    ),
                    /*child: Container(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Palette.colorAccent
                          ),
                          onPressed: () {
                            Navigator.of(context).push(_createRoute(0));
                          },
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                    ),*/
                  ),
                  SizedBox(
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute(1));
                      },
                      child: const Text(
                        '이미 가입하셨나요? 로그인하기',
                        style: TextStyle(
                            color: Palette.colorSecondaryText,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OpenContainerTransformDemo())
                        );
                      },
                      child: const Text(
                        '둘러보기',
                        style: TextStyle(
                            color: Palette.colorSecondaryText,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ],
      )
    );
  }

  Route _createRoute(int index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(pageIndex: index,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}