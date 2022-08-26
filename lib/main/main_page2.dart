import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:study_flutter/mypage/my_page_menu.dart';

import '../board/board_read_page.dart';
import '../board/board_ui.dart';
import '../board/board_write_page.dart';
import '../dialog/selector_dialog.dart';
import '../icon_widget.dart';
import '../model/response_common_board_info.dart';
import '../search/search_page.dart';
import '../utils/color_palette.dart';

class MainPage2 extends StatefulWidget {
  const MainPage2({Key? key}): super(key: key);

  @override
  _MainPage2State createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {

  String _boardCategory = '전체';
  late Future<List<ResponseBoardInfo>> _items;

  @override
  void initState() {
    super.initState();
    _items = _boardFetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /**
   * 통신 영역
   */
  Future<List<ResponseBoardInfo>> _boardFetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    List<ResponseBoardInfo> data = [];

    var apiKey = '';
    comBoardCategory.forEach((key, value) {
      if (value == _boardCategory) {
        apiKey = '$key';
      }
    });

    if (apiKey.isEmpty) {
      // 전체 조회
      await Future.wait(comBoardCategory.keys.map((key) async {
        apiKey = '$key';
        var load = await rootBundle.loadString('localdata/board/common_board_${apiKey}.json');
        var list = List<ResponseBoardInfo>.from(jsonDecode(load).map((x) => ResponseBoardInfo.fromJson(x)));
        print('key > $key count > ${list.length}');
        data.addAll(list);
        print('key > $key list count > ${list.length}  dataCount > ${data.length}');
      }));
    } else {
      final load = await rootBundle.loadString('localdata/board/common_board_${apiKey}.json');
      var list = List<ResponseBoardInfo>.from(jsonDecode(load).map((x) => ResponseBoardInfo.fromJson(x)));
      data.addAll(list);
    }

    return Future.value(data);
  }

  Widget _boardListBuilder() => FutureBuilder<List<ResponseBoardInfo>> (
    future: _items,
    builder: (context, snapshot) {
      Widget childWidget;
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
        childWidget = Container(
            key: const ValueKey(0),
            padding: const EdgeInsets.only(top: 24),
            alignment: Alignment.topCenter,
            child: const CircularProgressIndicator(color: Colors.redAccent,)
        );
          break;
        case ConnectionState.done:
          if (snapshot.hasData) {
            if (snapshot.requireData.isEmpty) {
              childWidget = const BoardEmptyWidget(key: ValueKey(1));
            } else {
              childWidget = ListView.builder(
                  key: const ValueKey(2),
                  shrinkWrap: false,
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.black.withOpacity(0.8),
                      child: OpenContainerWrapper(
                          transitionType: ContainerTransitionType.fadeThrough,
                          closedBuilder: (context, openContainer) {
                            return BoardItemWidget(
                                data: snapshot.requireData[index],
                                callback: openContainer,
                                isLastItem: snapshot.requireData.length - 1 == index
                            );
                          },
                          widget: BoardReadPage(data: snapshot.requireData[index],)),
                    );
                  }
              );
            }
          } else {
            childWidget = Container(key: const ValueKey(3));
            Fluttertoast.showToast(
                msg: '일시적인 오류가 있어 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.',
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT
            );
          }
          break;
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child,),
        child: childWidget,
      );

    }
  );

  Future<void> categorySelect(
      BuildContext context,
      int initialIndex,
      SelectorBottomSheetCallback callback,
      String title,
      List<String> list
      ) {
    return showModalBottomSheet(
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: Palette.windowBlackBackground,
        context: context,
        builder: (context) => SelectorBottomSheet(initialIndex: initialIndex, selectCallback: callback, title: title, list: list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const BoardWritePage(pageTitle: '전체 게시판',);
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(56.0 / 2),
          ),
        ),
        closedColor: Colors.redAccent,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return const SizedBox(
            height: 56.0,
            width: 56.0,
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(_boardCategory,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.white,)
                  ],
                ),
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    var cateList = comBoardCategory.values.toList();
                    cateList.insert(0, '전체');
                    categorySelect(
                        context,
                        cateList.indexOf(_boardCategory),
                            (index) {
                          setState(() {
                            _boardCategory = cateList[index];
                            _items = _boardFetchData();
                            Navigator.pop(context);
                          });
                        },
                        '',
                        cateList
                    );
                  },
                ),
              ))
            ],
          ),
        ),
        actions: [
          IconWidget(icon: const Icon(Icons.search_rounded, color: Colors.white), onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage())
            );
          },),
          IconWidget(icon: const Icon(Icons.notifications_rounded, color: Colors.white,), onTap: () {}),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack (
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: ClipOval(
                        child: Image.network(
                          '',
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.person, color: Colors.white,),);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyPageMenu())
                          );
                        },
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
          color: Colors.black.withOpacity(0.8),
          child: _boardListBuilder()
      ),
    );
  }
}

