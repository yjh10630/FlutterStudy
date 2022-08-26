import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/response_board_comment.dart';
import '../model/response_common_board_info.dart';
import '../utils/color_palette.dart';
import '../img_full_page.dart';
import 'board_ui.dart';

class BoardReadPage extends StatefulWidget {
  const BoardReadPage({Key? key, required this.data}): super(key: key);
  final ResponseBoardInfo data;
  @override
  _BoardReadPageState createState() => _BoardReadPageState();
}

class _BoardReadPageState extends State<BoardReadPage> {

  bool _isCommentBtnShow = false;
  late Future<List<ResponseBoardComment>> _comments;
  late TextEditingController _commentEditController;

  @override
  void initState() {
    super.initState();
    _comments = requestBoardComment();
    _commentEditController = TextEditingController();
  }

  @override
  void dispose() {
    _commentEditController.dispose();
    super.dispose();
  }
  
  Future<List<ResponseBoardComment>> requestBoardComment() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    final comments = await rootBundle.loadString('localdata/board/board_comment.json');
    var parseData = List<ResponseBoardComment>.from(jsonDecode(comments).map((x) => ResponseBoardComment.fromJson(x)));
    return Future.value(parseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Container(
        color: Colors.black.withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: widget.data.convertCategoryToTag().isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                child: BoardTag(
                                  tagName: widget.data.convertCategoryToTag(),
                                  txtColor: widget.data.tagColor(),
                                ),
                              )
                          ),
                          Text(widget.data.title ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 12,),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Divider(height: 1, color: Colors.white.withOpacity(0.8),),

                    const SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: widget.data.photo?.length,
                                itemBuilder: (context, index) =>
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Stack(
                                          children: [
                                            Image.network(widget.data.photo![index],
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
                                            Positioned.fill(child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  /*Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(milliseconds: 1000),
                                                          pageBuilder: (_, __, ___) => BoardImgFullPage(
                                                            imgs: widget.data.photo!,
                                                            initIndex: index,
                                                          )
                                                      )
                                                  );*/
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ImgFullPage(imgs: widget.data.photo!,
                                                        initIndex: index,))
                                                  );
                                                },
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12,),

                    Divider(height: 1, color: Colors.white.withOpacity(0.8),),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 20,
                                color: Colors.white.withOpacity(0.5),),
                              onPressed: () {

                              },
                            ),
                            Text(widget.data.reviewCount ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.5)
                              ),),
                            const SizedBox(width: 12,),
                            IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {},
                                icon: Icon(Icons.visibility, size: 20, color: Colors.white.withOpacity(0.5),)),
                            Text(widget.data.viewCount ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.5)
                              ),),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, color: Colors.white.withOpacity(0.8),),
                    const SizedBox(height: 12,),
                    
                    FutureBuilder<List<ResponseBoardComment>>(
                      future: _comments,
                      builder: (context, snapshot) {
                        Widget childWidget = const SizedBox(
                            height: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('아직 댓글이 없습니다.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),));

                        if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
                          childWidget = ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.requireData.length,
                            itemBuilder: (context, index) => _CommentItemWidget(comment: snapshot.requireData[index],)
                          );
                        }
                        return childWidget;
                      }
                    ),
                    const SizedBox(height: 12,),
            ],),)),

            Divider(height: 1, color: Colors.white.withOpacity(0.8),),
            Row(
              children: [
                const SizedBox(width: 12,),
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
                Text(widget.data.pickCount ?? '',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5)
                  ),),
                const SizedBox(width: 12,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 7),
                    child: TextFormField(
                      onChanged: (text) {
                        _isCommentBtnShow = text.trim().isNotEmpty;
                        setState((){});
                      },
                      controller: _commentEditController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                      cursorColor: Colors.white30,
                      cursorWidth: 1.5,
                      style: const TextStyle(color: Colors.white70),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26, width: 0.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26, width: 0.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26, width: 0.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        filled: true,
                        fillColor: Colors.black26,
                        hintText: '댓글을 입력해주세요.',
                        hintStyle: const TextStyle(color: Colors.white24,),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12,),
                Visibility(
                  visible: _isCommentBtnShow,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          var comment = _commentEditController.value.text;
                          Fluttertoast.showToast(
                              msg: '[${comment}]\nApi 적용예정',
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_SHORT
                          );
                          _commentEditController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();

                          setState((){
                            _isCommentBtnShow = false;
                          });
                        },
                        icon: Icon(Icons.send, size: 20, color: Colors.white.withOpacity(0.5),)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CommentItemWidget extends StatelessWidget {
  const _CommentItemWidget({Key? key, required this.comment}): super(key: key);
  final ResponseBoardComment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5,),
        Row(
          children: [
            const SizedBox(width: 12,),
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
                  comment.writeUserInfo?.userImg ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.person),);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12,),
            Text(comment.writeUserInfo?.userName ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white
              ),),
            const SizedBox(width: 12,),
            Text(comment.createTime ?? '',
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white30
              ),),
            Expanded(child: Container()),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_rounded, color: Colors.white70, size: 20,))
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 54, right: 40),
            child: Text(comment.comment ?? '',
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white
                ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}