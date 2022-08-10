import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color_palette.dart';

typedef SelectorBottomSheetCallback = void Function(int);
class SelectorBottomSheet extends StatelessWidget {
  SelectorBottomSheet({
    Key? key,
    required this.initialIndex,
    required this.selectCallback,
    required this.title,
    required this.list
  }): super(key: key);

  final int initialIndex;
  final SelectorBottomSheetCallback selectCallback;
  final String title;
  final List<String> list;

  int currentSelectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 14, top: 12),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: const BoxDecoration(
                color: Palette.colorDividers,
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 24),
              width: double.infinity,
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 22,
                    color: Palette.colorPrimaryText,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
          Expanded(
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 32.0,
              scrollController: FixedExtentScrollController(initialItem: initialIndex),
              onSelectedItemChanged: (int selectedItem) {
                currentSelectIndex = selectedItem;
              },
              children:
              List<Widget>.generate(list.length, (int index) {
                return Center(
                  child: Text(
                    list[index],
                  ),
                );
              }),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xCCFF6F00))
              ),
              onPressed: () {
                selectCallback(currentSelectIndex);
              },
              child: const Text(
                '확인',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}