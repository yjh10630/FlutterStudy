import 'package:flutter/material.dart';

showTestDialog(BuildContext context, String txt, String confirmTxt, String cancelTxt, VoidCallback confirm, VoidCallback cancel) {
  showGeneralDialog(
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
            opacity: a1.value,
            child: customAlertDialog(txt, confirmTxt, cancelTxt, confirm, cancel)
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 150),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      // 여긴 뭐지 ?
      return customAlertDialog(txt, confirmTxt, cancelTxt, confirm, cancel);
    },);
}

customAlertDialog(String txt, String confirmTxt, String cancelTxt, VoidCallback confirm, VoidCallback cancel) => AlertDialog(
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))),
  contentPadding: const EdgeInsets.only(top: 24, bottom: 16, left: 12, right: 12),
  content: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        txt,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xDE000000)
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 6, top: 24),
              height: 48,
              child: ElevatedButton(onPressed: confirm,
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xCCFF6F00)
                ),
                child: Text(
                  confirmTxt,
                  style: const TextStyle(
                      color: Color(0xfffafafa),
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 6, top: 24),
              height: 48,
              child: ElevatedButton(
                  onPressed: cancel,
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0x8A000000)),
                  child: Text(
                    cancelTxt,
                    style: const TextStyle(
                        color: Color(0xfffafafa),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ],
      )
    ],
  ),
);