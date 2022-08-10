import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_flutter/model/response_common_board_info.dart';

import '../club/test.dart';
import '../ex_list.dart';
import '../ex_list2.dart';
import '../utils/color_palette.dart';
import 'board_read_page.dart';
import 'board_ui.dart';
import 'board_write_page.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key, required this.pageTitle}): super(key: key);

  final String pageTitle;

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<ResponseBoardInfo>> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    final data = await rootBundle.loadString('localdata/board/club_board.json');
    return List<ResponseBoardInfo>.from(jsonDecode(data).map((x) => ResponseBoardInfo.fromJson(x)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return BoardWritePage(pageTitle: widget.pageTitle,);
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
        title: Text(widget.pageTitle),
        actions: [],
      ),
      body: _boardListBuilder(),
    );
  }

  Widget _boardListBuilder() => FutureBuilder<List<ResponseBoardInfo>>(
    future: _fetchData(),
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
            color: Colors.black.withOpacity(0.8),
            child: const CircularProgressIndicator(color: Colors.redAccent,)
          );
          break;
        case ConnectionState.done:
          if (snapshot.hasData) {
            if (snapshot.requireData.isEmpty) {
              childWidget = const _BoardEmptyWidget(key: ValueKey(1));
            } else {
              childWidget = ListView.builder(
                  key: const ValueKey(2),
                  shrinkWrap: false,
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.black.withOpacity(0.8),
                      child: _OpenContainerWrapper(
                          transitionType: ContainerTransitionType.fadeThrough,
                          closedBuilder: (context, openContainer) {
                            return _BoardItemWidget(
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
            childWidget = Container(
              key: const ValueKey(3),
              color: Colors.black.withOpacity(0.8),
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
}

class _BoardEmptyWidget extends StatelessWidget {
  const _BoardEmptyWidget({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      padding: const EdgeInsets.only(top: 48),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          '아직 게시글이 없습니다',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.5)
          ),
        ),
      ),
    );
  }
}

class _BoardItemWidget extends StatefulWidget {
  const _BoardItemWidget({
    Key? key,
    required this.callback,
    required this.data,
    required this.isLastItem
  }): super(key: key);
  final VoidCallback callback;
  final ResponseBoardInfo data;
  final bool isLastItem;
  @override
  _BoardItemWidgetState createState() => _BoardItemWidgetState();
}

class _BoardItemWidgetState extends State<_BoardItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(children: [
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.data.convertCategoryToTag().isNotEmpty,
                child: BoardTag(
                  tagName: widget.data.convertCategoryToTag(),
                  txtColor: widget.data.tagColor(),
                )
              ),
              const SizedBox(height: 12,),
              Text(widget.data.title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
              const SizedBox(height: 12,),
              Text(
                widget.data.detail ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14
                  ),
              ),
              const SizedBox(height: 12,),
              Visibility(
                visible: widget.data.photo?.isNotEmpty == true,
                child: _PhotoList(imgs: widget.data.photo)
              ),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Palette.colorDividers,
                          width: 1,
                        )
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.data.writeUserInfo?.userImg ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.person),);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Text(widget.data.writeUserInfo?.userName ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5)
                  ),),
                  Expanded(child: Container()),
                  Text(widget.data.createTime ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5)
                    ),),
                ],
              ),
              const SizedBox(height: 12,),
            ],
          ),
        ),
        Positioned.fill(child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: widget.callback
          ),
        ))
      ]),
      Divider(height: 1, color: Colors.black.withOpacity(0.8),),
      Container(
        color: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.only(left: 12, right: 12),
        height: 50,
        child: Row(
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.callback,
                icon: Icon(Icons.visibility, size: 20, color: Colors.white.withOpacity(0.5),)),
            const SizedBox(width: 3,),
            Text(widget.data.viewCount ?? '',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5)
              ),),
            const SizedBox(width: 10,),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: widget.data.isPick ?? false
                      ? const Icon(Icons.favorite_rounded, key: ValueKey('icon1'), size: 20, color: Colors.redAccent,)
                      : Icon(Icons.favorite_border_rounded, key: ValueKey('icon2'), size: 20, color: Colors.white.withOpacity(0.5),)
              ),
              onPressed: () {
                setState(() {
                  // todo pick 통신
                  widget.data.isPick = !(widget.data.isPick ?? false);
                });
              },
            ),
            const SizedBox(width: 3,),
            Text(widget.data.pickCount ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5)
            ),),
            Expanded(child: Container()),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.callback,
                icon: Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Colors.white.withOpacity(0.5),)),
            const SizedBox(width: 3,),
            Text(widget.data.reviewCount ?? '',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5)
              ),),
          ],
        ),
      ),
      Visibility(
        visible: !widget.isLastItem,
        child: Container(height: 10, color: Colors.black.withOpacity(0.7),)
      )
    ]);
  }
}

class _PhotoList extends StatelessWidget {
  const _PhotoList({Key? key, this.imgs}): super(key: key);

  final List<String>? imgs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children:[
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                Image.network(imgs![0],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('error > ${error}');
                    return const Center(child: Icon(Icons.error_outline_rounded),);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: Icon(Icons.insert_photo_outlined),);
                  },
                ),
                Visibility(
                    visible: (imgs?.length ?? 0) > 1,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 12, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                            color: Colors.black.withOpacity(0.6)
                        ),
                        child: Text(
                          '+${(imgs?.length ?? 0) - 1}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9)
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
          const SizedBox(height: 12.0,)
        ]
      ),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
    required this.widget,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return widget;
      },
      tappable: false,
      closedElevation: 0.0,
      openElevation: 0.0,
      closedBuilder: closedBuilder,
    );
  }
}