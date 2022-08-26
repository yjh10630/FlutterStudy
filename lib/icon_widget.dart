import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({Key? key, required this.icon, required this.onTap}): super(key: key);
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack (
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Align(
                alignment: Alignment.center,
                child: icon
            ),
          ),
          Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              )
          )
        ],
      ),
    );
  }
}