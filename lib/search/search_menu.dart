import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter/search/search_page2.dart';

class FullScreenModal extends ModalRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.6);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  void goToSearchPage(BuildContext context, int index) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage2()));
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () { goToSearchPage(context, 0); },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              child: const Text('클럽 찾기',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              )
            ),
            ElevatedButton(
                onPressed: () { goToSearchPage(context, 1); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purpleAccent)),
                child: const Text('멤버 찾기',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    )
                )
            ),
            ElevatedButton(
                onPressed: () { goToSearchPage(context, 2); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orangeAccent)),
                child: const Text('게시글 찾기',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    )
                )
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white38,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(8),
              ),
              child: const Icon(Icons.close),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      ),
    );
  }
}