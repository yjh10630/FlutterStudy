import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'main/main_page2.dart';
import 'model/my_page_dataset.dart';
import 'package:flutter/foundation.dart';

import 'dialog/common_dialog.dart';
import 'main/main_page.dart';
import 'utils/color_palette.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final double _kItemExtent = 32.0;
  final _editTextFormKey = GlobalKey<FormState>();
  final Map<MyPageViewType, TextEditingController> _controllerMap = {};
  final Map<MyPageViewType, FocusNode> _focusNodeMap = {};
  File? userImage;
  late Future<List<MyPageDataSet>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _retrieveData();
  }

  @override
  void dispose() {
    _focusNodeMap.forEach((key, value) {
      value.dispose();
    });
    _controllerMap.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              _HeaderTxtBtn(
                leftBtnCallback: () {
                  Navigator.pop(context);
                },
                rightBtnCallback: () {
                  if (_editTextFormKey.currentState?.validate() == true) {
                    showTestDialog(
                        context,
                        '입력하신 내용으로 프로필을 저장하시겠습니까?',
                        '확인',
                        '취소',
                            () {
                          var data = ResponseMyPageInfo(
                            comment: _controllerMap[MyPageViewType.myPageMessage]?.text,
                            name: _controllerMap[MyPageViewType.myPageName]?.text,
                            height: _controllerMap[MyPageViewType.myPageHeight]?.text,
                            weight: _controllerMap[MyPageViewType.myPageWeight]?.text,
                            sex: _controllerMap[MyPageViewType.myPageSex]?.text,
                            position: _controllerMap[MyPageViewType.myPagePosition]?.text,
                            age: _controllerMap[MyPageViewType.myPageAge]?.text,
                            //activeArea:
                          );
                          Fluttertoast.showToast(msg: jsonEncode(data));
                          Navigator.pop(context);
                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage2()), (route) => false);
                        },
                            () {
                          Navigator.pop(context);
                        }
                    );
                  }
                },
              ),
              _futureBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<MyPageDataSet>> _retrieveData() {
    return Future.value(myPageContents);
  }

  Widget _futureBuilder() => FutureBuilder<List<MyPageDataSet>>(
      future: dataFuture,
      builder: (context, snapshot) {
        //todo 에러일 때 대응 방법
        if (snapshot.hasError) {
          return Text('Error');
        } else if (snapshot.hasData) {
          var data = snapshot.data ?? List.empty();
          return _myPageView(data);
        } else {
          return Text('???');
        }
      }
  );

  Widget _myPageView(List<MyPageDataSet> snapData) {
    return Expanded(
      child: Form(
        key: _editTextFormKey,
        child:  ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: snapData.length,
            itemBuilder: (context, index) {
              var data = snapData[index];

              switch(snapData[index].viewType) {
                case MyPageViewType.myPageImage:
                  return _imageWidget(data.value);
                case MyPageViewType.myPageName:
                  return Container(
                    margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: _singleInputEdit(data),
                  );
                case MyPageViewType.myPageHeightWeightSex:
                  return _multiInputEdit(data.list);
                case MyPageViewType.myPageDivider:
                  return Container(
                    margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: _divider(data.hint),
                  );
                case MyPageViewType.myPagePositionAge:
                  return _multiInputEdit(data.list);
                case MyPageViewType.myPageMessage:
                  return Container(
                    margin: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
                    child: _multiLineInoutEdit(data),
                  );
                case MyPageViewType.myPageActiveArea:
                  return Container(
                    margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: _singleInputEdit(data),
                  );
                default : return Container();
              }
            }
        ),
      ),
    );
  }

  Widget _divider(String? txt) {
    if (txt?.isEmpty == true) {
      return Container(
          height:1.0,
          width:double.infinity,
          color:const Color(0x7070701F));
    } else {
      return Row(
        children: [
          Flexible(flex: 1, child: Container(
              height:1.0,
              width:double.infinity,
              color:const Color(0x7070701F)),),
          if(txt?.isNotEmpty == true)
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: Text(txt ?? '',
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0x8A000000)
              ),),
          ),
          Flexible(flex: 1, child: Container(
              height:1.0,
              width:double.infinity,
              color:const Color(0x7070701F)),),
        ],
      );
    }
  }

  Widget _multiInputEdit(List<MyPageDataSet>? data) {
    List<Widget> widgetRowList = [];
    data?.forEach((element) {
      widgetRowList.add(
          Flexible(flex: 1, child: Container(margin: const EdgeInsets.only(right: 2, left: 2), child: _singleInputEdit(element)))
      );
    });
    print('data >> ${data!.length}, add Widget >> ${widgetRowList.length}');
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 22, right: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetRowList,
      ),
    );
  }

  Widget _multiLineInoutEdit(MyPageDataSet dataSet) {
    final controller = _getControllerOf(dataSet.viewType, dataSet.value ?? '');
    return TextFormField(
      validator: (value) {
        if (value?.isEmpty == true) { return '입력해주세요'; }
        return null;
      },
      focusNode: _getFocusNode(dataSet.viewType),
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      maxLength: 100,
      textInputAction: TextInputAction.next,
      cursorColor: Palette.colorPrimaryText,
      cursorWidth: 1.5,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        labelText: dataSet.hint ?? '',
        labelStyle: TextStyle(
            color: _focusNodeMap[dataSet.viewType]?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
        ),
        alignLabelWithHint: true,
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(
                  color: Palette.colorPrimaryText,
                  width: 1.5
              )
          )
      ),
    );
  }

  Widget _singleInputEdit(MyPageDataSet dataSet) {
    final controller = _getControllerOf(dataSet.viewType, dataSet.value ?? '');
    return TextFormField(
      validator: (value) {
        var txt = value?.trim() ?? '';
        if (txt.isEmpty == true) { return '입력해주세요'; }
        return null;
      },
      focusNode: _getFocusNode(dataSet.viewType),
      controller: controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      cursorColor: Palette.colorPrimaryText,
      cursorWidth: 1.5,
      onTap: () {
        switch(dataSet.viewType) {
          case MyPageViewType.myPageName: return;
          case MyPageViewType.myPageMessage: return;
          default: {
            var selectedIndex = getSelectorList(dataSet.viewType).indexOf(controller.text);
            bottomSheet(context,
                dataSet.viewType,
                CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: _kItemExtent,
                  scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      controller.text = getSelectorList(dataSet.viewType)[selectedItem];
                    });
                  },
                  children:
                  List<Widget>.generate(getSelectorList(dataSet.viewType).length, (int index) {
                    return Center(
                      child: Text(
                        getSelectorList(dataSet.viewType)[index],
                      ),
                    );
                  }),
                )
            );
          }
        }
      },
      readOnly: dataSet.isReadOnly,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          labelText: dataSet.hint ?? '',
          labelStyle: TextStyle(
              color: _focusNodeMap[dataSet.viewType]?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(
                  color: Palette.colorPrimaryText,
                  width: 1.5
              )
          )
      ),
    );
  }

  Future<void> bottomSheet(BuildContext context, MyPageViewType viewType, Widget child) {
    return showModalBottomSheet(
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Color(0xD9FFFFFF),
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 14, top: 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  getSelectorTitle(viewType),
                  style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xDE000000),
                      fontWeight: FontWeight.bold
                  ),
                )
              ),
              Expanded(child: child),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  /*style: ElevatedButton.styleFrom(
                      primary: const Color(0xCCFF6F00)
                  ),*/
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    backgroundColor: MaterialStateProperty.all(Color(0xCCFF6F00))
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ));
  }

  Widget _imageWidget(String? imgUrl) {
    return Container(
      height: 200,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Color(0xff707070),
                width: 1,
              )
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Stack(
                children: [
                  imgUrl == null
                      ? (userImage == null
                      ? Container(color: Colors.transparent)
                      : Image.file(userImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity,))
                      : Image.network(imgUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
                  Positioned.fill(child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        var picker = ImagePicker();
                        var image = await picker.pickImage(source: ImageSource.gallery);
                        if(image !=null){
                          setState(() {
                            userImage = File(image.path);
                          });
                        }
                      },
                    ),
                  ))
                ],
              )
          ),
        ),
      ),
    );
  }

  TextEditingController _getControllerOf(MyPageViewType viewType, String value) {
    var controller = _controllerMap[viewType];
    if (controller == null) {
      controller = TextEditingController(text: value);
      _controllerMap[viewType] = controller;
    }
    return controller;
  }

  FocusNode _getFocusNode(MyPageViewType viewType) {
    var focusNode = _focusNodeMap[viewType];
    if (focusNode == null) {
      focusNode = FocusNode();
      _focusNodeMap[viewType] = focusNode;
    }
    return focusNode;
  }
}

class _HeaderTxtBtn extends StatelessWidget {
  const _HeaderTxtBtn({
    this.leftBtnCallback,
    this.rightBtnCallback,
  });

  final VoidCallback? leftBtnCallback;
  final VoidCallback? rightBtnCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SimpleTxtBtn(
              name: '뒤로가기',
              callback: () {
                leftBtnCallback!();
              }),
          _SimpleTxtBtn(
              name: '저장하기',
              callback: () {
                rightBtnCallback!();
              }),
        ],
      ),
    );
  }
}

class _SimpleTxtBtn extends StatelessWidget {
  const _SimpleTxtBtn({
    Key? key, required this.name, required this.callback
  }): super(key: key);

  final String name;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      //todo 테스트
      onLongPress: () {
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainPage2()), (route) => false);
      },
      child: Text(
        name,
        style: const TextStyle(
            color: Color(0x8A000000),
            fontSize: 15,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, Widget child) {
  showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ));
}