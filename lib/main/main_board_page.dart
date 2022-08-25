import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../board/board_read_page.dart';
import '../board/board_ui.dart';
import '../dialog/selector_dialog.dart';
import '../model/response_common_board_info.dart';
import '../utils/color_palette.dart';

class DraggableMainBoardListView extends StatefulWidget {
  const DraggableMainBoardListView({
    Key? key, required this.minHeight,
  }) : super(key: key);

  final double minHeight;

  @override
  _DraggableSearchableListViewState createState() =>
      _DraggableSearchableListViewState();
}

class _DraggableSearchableListViewState
    extends State<DraggableMainBoardListView> {

  final ValueNotifier<bool> searchFieldVisibility = ValueNotifier<bool>(false);
  late Future<List<ResponseBoardInfo>> _items;
  late String _boardCategory;

  @override
  void initState() {
    super.initState();
    _boardCategory = '전체';
    _items = _fetchData();
  }

  @override
  void dispose() {
    searchFieldVisibility.dispose();
    super.dispose();
  }

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
        backgroundColor: Palette.windowBackground,
        context: context,
        builder: (context) => SelectorBottomSheet(initialIndex: initialIndex, selectCallback: callback, title: title, list: list));
  }

  Future<List<ResponseBoardInfo>> _fetchData() async {
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

  Widget _test(ScrollController controller) => FutureBuilder<List<ResponseBoardInfo>>(
    future: _items,
    builder: (context, snapshot) {
      var count = 2;
      if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
        count = snapshot.requireData.length;
      }
      return ListView.builder(
        controller: controller,
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 60,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0, bottom: 24),
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: const BoxDecoration(
                            color: Palette.colorDividers,
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                      child: ClipRRect(
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
                                        color: Colors.black54
                                    ),),
                                  const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54,)
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
                                          _items = _fetchData();
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
                    ),
                  )
                ],
              ),
            );
          } else {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Container(
                  height: 500,
                  color: Colors.blue,
                );
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.requireData.isEmpty) {
                    return Container(
                      height: 500,
                      color: Colors.redAccent,
                    );
                  } else {
                    return Container(
                      color: Colors.grey,
                      child: OpenContainerWrapper(
                          transitionType: ContainerTransitionType.fadeThrough,
                          closedBuilder: (context, openContainer) {
                            return BoardItemWidget(
                                data: snapshot.requireData[index - 1],
                                callback: openContainer,
                                isLastItem: snapshot.requireData.length - 1 == (index - 1)
                            );
                          },
                          widget: BoardReadPage(data: snapshot.requireData[index - 1],)),
                    );
                  }
                } else {
                  return Container(
                    height: 500,
                    color: Colors.yellowAccent,
                  );
                }
            }
          }
        }
      );
    }
  );

  Widget _boardListBuilder(ScrollController scrollController) => FutureBuilder<List<ResponseBoardInfo>>(
    future: _items,
    builder: (context, snapshot) {
      Widget childWidget;
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
        childWidget = Container(
            key: const ValueKey(0),
            color: Colors.grey,
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
                  controller: scrollController,
                  itemCount: snapshot.requireData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    /*if (index == 0) {
                      return SizedBox(
                        height: 60,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0, bottom: 24),
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                      color: Palette.colorDividers,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                                child: ClipRRect(
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
                                                  color: Colors.black54
                                              ),),
                                            const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54,)
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
                                                    _items = _fetchData();
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
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        color: Colors.grey,
                        child: OpenContainerWrapper(
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedBuilder: (context, openContainer) {
                              return BoardItemWidget(
                                  data: snapshot.requireData[index - 1],
                                  callback: openContainer,
                                  isLastItem: snapshot.requireData.length - 1 == (index - 1)
                              );
                            },
                            widget: BoardReadPage(data: snapshot.requireData[index - 1],)),
                      );
                    }*/
                    {
                      return Container(
                        color: Colors.grey,
                        child: OpenContainerWrapper(
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedBuilder: (context, openContainer) {
                              return BoardItemWidget(
                                  data: snapshot.requireData[index],
                                  callback: openContainer,
                                  isLastItem: snapshot.requireData.length == (index)
                              );
                            },
                            widget: BoardReadPage(data: snapshot.requireData[index],)),
                      );
                    }
                  }
              );
            }
          } else {
            childWidget = Container(
              key: const ValueKey(3),
              color: Colors.grey,
            );
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
    },
  );

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == 1.0) {
          searchFieldVisibility.value = true;
        } else {
          searchFieldVisibility.value = false;
        }
        return true;
      },
      child: DraggableScrollableActuator(
        child: Stack(
          children: <Widget>[
            DraggableScrollableSheet(
              initialChildSize: widget.minHeight,
              minChildSize: widget.minHeight,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0, bottom: 24),
                                    child: Container(
                                      width: 50,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                          color: Palette.colorDividers,
                                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                                    child: ClipRRect(
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
                                                      color: Colors.black54
                                                  ),),
                                                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54,)
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
                                                        _items = _fetchData();
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
                                  ),
                                )
                              ],
                            ),
                          ),
                          _boardListBuilder(scrollController)
                        ],
                      )
                  ),
                );
              },
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              child: ValueListenableBuilder<bool>(
                  valueListenable: searchFieldVisibility,
                  builder: (context, value, child) {
                    return value ? Container(
                      decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 0.75)
                          )
                        ],
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: BoardBar(
                        onClose: () {
                          searchFieldVisibility.value = false;
                          DraggableScrollableActuator.reset(context);
                        },
                        headerCategory: _boardCategory,
                        onTabCategory: () {
                          var cateList = comBoardCategory.values.toList();
                          cateList.insert(0, '전체');
                          categorySelect(
                              context,
                              cateList.indexOf(_boardCategory),
                                  (index) {
                                setState(() {
                                  _boardCategory = cateList[index];
                                  _items = _fetchData();
                                  Navigator.pop(context);
                                });
                              },
                              '',
                              cateList
                          );
                        },
                      ),
                    ) : Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardBar extends StatefulWidget {
  BoardBar({
    Key? key,
    required this.onClose,
    required this.headerCategory,
    required this.onTabCategory
  }) : super(key: key);
  final VoidCallback onClose;
  String headerCategory;
  final VoidCallback onTabCategory;

  @override
  _BoardBarState createState() => _BoardBarState();
}

class _BoardBarState extends State<BoardBar> {

  int _widgetId = 1;
  bool _isShowTxtClearBtn = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    _editingController.addListener(() {
      setState(() {
        _isShowTxtClearBtn = _editingController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Widget _searchIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.black54,
              ),
            ),
            Positioned.fill(child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _updateWidget();
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget? _getClearBtn() {
    if (!_isShowTxtClearBtn) { return null; }
    return IconButton(onPressed: () {
      _editingController.clear();
    }, icon: const Icon(Icons.clear, color: Palette.colorPrimaryIcon,));
  }

  Widget _textField() {
    return Row(
      key: Key('textField'),
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 4),
            child: TextFormField(
              controller: _editingController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.black45,
              cursorWidth: 1.5,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '검색어를 입력하세요.',
                  suffixIcon: _getClearBtn(),
                  hintStyle: const TextStyle(color: Colors.black26,),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black26,
                  )
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black54,
                ),
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _updateWidget();
                  },
                ),
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _searchIcon() : _textField();
  }

  void _updateWidget() {
    setState(() {
      _widgetId = _widgetId == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                  ),
                  Positioned.fill(child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onClose();
                      },
                    ),
                  ))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(widget.headerCategory,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54,)
                      ],
                    ),
                  ),
                  Positioned.fill(child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTabCategory,
                    ),
                  ))
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _renderWidget(),
          )
        ],
      ),
    );
  }
}