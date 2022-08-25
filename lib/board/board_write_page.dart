import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_flutter/dialog/common_dialog.dart';
import 'package:study_flutter/dialog/selector_dialog.dart';

import '../model/response_common_board_info.dart';
import '../model/response_common_board_info.dart';
import '../utils/color_palette.dart';

class BoardWritePage extends StatefulWidget {
  const BoardWritePage({Key? key, required this.pageTitle}): super(key: key);
  final String pageTitle;
  @override
  _BoardWritePageState createState() => _BoardWritePageState();
}

class _BoardWritePageState extends State<BoardWritePage> {

  final _editTextFormKey = GlobalKey<FormState>();
  List<XFile> upLoadImages = [];
  final int maxImgCount = 10;
  final List<String> _boardCategory = [];
  String writeCategory = '';

  @override
  void initState() {
    super.initState();
    if (widget.pageTitle.contains('전체')) {
      comBoardCategory.forEach((key, value) { _boardCategory.add(value);});
    } else {
      clubCategory.forEach((key, value) { _boardCategory.add(value);});
    }
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text('${widget.pageTitle} 글쓰기'),
        actions: [
          TextButton(
            onPressed: () {
              if (_editTextFormKey.currentState?.validate() == true) {

                if (writeCategory.isEmpty) {
                  categorySelect(
                      context,
                      _boardCategory.indexOf(writeCategory),
                          (index) {
                        setState(() {
                          writeCategory = _boardCategory[index];
                          Navigator.pop(context);
                        });
                      },
                      '주제를 선택해 주세요.',
                      _boardCategory
                  );
                  return;
                }

                showTestDialog(
                    context,
                    '입력하신 내용으로 글을 올리시겠습니까?',
                    '올리기',
                    '취소',
                    () {
                      Navigator.pop(context); // dialog finish
                      Navigator.pop(context, true); // board finish
                      },
                    () { Navigator.pop(context); }
                );
              }
            },
            child: Text('올리기',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.white.withOpacity(0.5)
            ),),
          )
        ],
      ),
      body: Container(
        color: Colors.black.withOpacity(0.8),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(writeCategory.isEmpty ? '주제를 선택해 주세요.' : writeCategory,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 12, top: 10, bottom: 10),
                        child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70)
                    )
                  ],
                ),
                Positioned.fill(child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        categorySelect(
                          context,
                            _boardCategory.indexOf(writeCategory),
                          (index) {
                            setState(() {
                              writeCategory = _boardCategory[index];
                              Navigator.pop(context);
                            });
                          },
                          '주제를 선택해 주세요.',
                            _boardCategory
                        );
                      }
                  ),
                ))
              ],
            ),
            Visibility(
              visible: upLoadImages.isNotEmpty,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: upLoadImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _ImageWidget(img: upLoadImages[index], callback: () {
                      setState(() {
                        upLoadImages.removeAt(index);
                      });
                    },);
                  }
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _editTextFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        var txt = value?.trim() ?? '';
                        if (txt.isEmpty == true) { return '입력해주세요'; }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.white30,
                      cursorWidth: 1.5,
                      style: const TextStyle(color: Colors.white70),
                      maxLength: 40,
                      decoration: const InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.only(left: 12),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            '0/40',
                            style: TextStyle(color: Colors.white24,),),
                        ),
                        suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        border: InputBorder.none,
                        hintText: '제목',
                        hintStyle: TextStyle(color: Colors.white24,)
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          var txt = value?.trim() ?? '';
                          if (txt.isEmpty == true) { return '입력해주세요'; }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.white30,
                        cursorWidth: 1.5,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white70),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12),
                            border: InputBorder.none,
                            hintText: '내용',
                            hintStyle: TextStyle(color: Colors.white24,)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Divider(height: 1, color: Colors.white.withOpacity(0.5),),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    List<XFile> imgs = [];
                    imgs.addAll(upLoadImages);

                    if (imgs.length >= maxImgCount) {
                      Fluttertoast.showToast(
                          msg: '이미지는 10개까지만 등록 가능 합니다.',
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT
                      );
                      return;
                    }
                    var picker = ImagePicker();
                    var images = await picker.pickMultiImage();
                    images?.forEach((element) {
                      if (imgs.length < maxImgCount) imgs.add(element);
                    });

                    if (imgs.length != upLoadImages.length) {
                      setState(() {
                        upLoadImages = [];
                        upLoadImages.addAll(imgs);
                        Fluttertoast.showToast(
                            msg: '총 이미지 갯수 > ${upLoadImages.length}',
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_SHORT
                        );
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white.withOpacity(0.7)
                  ),
                  icon: const Icon(Icons.add_photo_alternate_rounded),
                  label: Text('${upLoadImages.length}/$maxImgCount')
                ),
                TextButton.icon(
                    onPressed: (){},
                    style: TextButton.styleFrom(
                        primary: Colors.white.withOpacity(0.7)
                    ),
                    icon: const Icon(Icons.location_on_rounded),
                    label: const Text('0/1')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({Key? key, required this.img, required this.callback}): super(key: key);
  final XFile img;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.all(5),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(img.path)))
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 7),
          width: 100,
          height: 100,
          child: IconButton(
            alignment: Alignment.topRight,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: callback,
            icon: const Icon(
              Icons.cancel_rounded,
              size: 20,
              color: Colors.black54,
            )
          ),
        )
      ],
    );
  }
}