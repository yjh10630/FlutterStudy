import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_flutter/club/club_main2.dart';
import 'package:study_flutter/utils/color_palette.dart';

import 'package:animations/animations.dart';
import 'club/test.dart';
import 'model/response_search_club_info.dart';

typedef BottomSheetSelectCallback = void Function(int);

class LocationItem {
  String name;
  LocationItem(this.name);
}

final List<String> _filterLocationList = <String>[
  '전국', '경기도', '인천광역시', '서울특별시', '강원동', '전라북도', '전라남도', '경상북도', '경상남도', '제주도'
];

final List<String> _sortList = <String>[
  '최신순', '인원 많은순',
];

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin{
  late FocusNode _focusNode;
  late TextEditingController _editingController;
  bool _isShowTxtClearBtn = false;
  late String _locationSelectValue;
  late String _searchKeyword;
  late String _sortType;
  late Future<List<ResponseSearchClubInfo>> _items;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _editingController = TextEditingController();
    _editingController.addListener(() {
      setState(() {
        _isShowTxtClearBtn = _editingController.text.isNotEmpty;
      });
    });
    _locationSelectValue = '전국';
    _sortType = '최신순';
    _searchKeyword = '';
    _items = requestSearchItems();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _editingController.dispose();
    super.dispose();
  }

  // 통신
  Future<List<ResponseSearchClubInfo>> requestSearchItems() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    List<ResponseSearchClubInfo> data = [];
    switch(_locationSelectValue) {
      case'전국': {
        final gangwon = await rootBundle.loadString('localdata/search/gangwon.json');
        List<ResponseSearchClubInfo> gangwonData = [];
        gangwonData.addAll(List<ResponseSearchClubInfo>.from(jsonDecode(gangwon).map((x) => ResponseSearchClubInfo.fromJson(x))));

        final incheon = await rootBundle.loadString('localdata/search/incheon.json');
        List<ResponseSearchClubInfo> incheonData = [];
        incheonData.addAll(List<ResponseSearchClubInfo>.from(jsonDecode(incheon).map((x) => ResponseSearchClubInfo.fromJson(x))));

        final seoul = await rootBundle.loadString('localdata/search/seoul.json');
        List<ResponseSearchClubInfo> seoulData = [];
        seoulData.addAll(List<ResponseSearchClubInfo>.from(jsonDecode(seoul).map((x) => ResponseSearchClubInfo.fromJson(x))));

        data.addAll(gangwonData);
        data.addAll(incheonData);
        data.addAll(seoulData);
        break;
      }
      case'강원도': {
        final gangwon = await rootBundle.loadString('localdata/search/gangwon.json');
        data.addAll(List<ResponseSearchClubInfo>.from(jsonDecode(gangwon).map((x) => ResponseSearchClubInfo.fromJson(x))));
        break;
      }
      case'인천광역시': {
        final incheon = await rootBundle.loadString('localdata/search/incheon.json');
        data.addAll(List<ResponseSearchClubInfo>.from(jsonDecode(incheon).map((x) => ResponseSearchClubInfo.fromJson(x))));
        break;
      }
      case'서울특별시': {
        final seoul = await rootBundle.loadString('localdata/search/seoul.json');
        data.addAll(List<ResponseSearchClubInfo>.from(jsonDecode(seoul).map((x) => ResponseSearchClubInfo.fromJson(x))));
        break;
      }
      default: {}
    }

    switch(_sortType) {
      case '최신순':
        data.sort((a, b) => (a.creClubTime ?? '0').compareTo((b.creClubTime ?? '0')));
        break;
      case '인원 많은순':
        data.sort((a, b) {
          int before = int.parse(a.memberCount ?? '');
          int after = int.parse(b.memberCount ?? '');
          return before.compareTo(after);
        });
        break;
    }
    return Future.value(data);
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              // header
              Container(
                padding: EdgeInsets.only(top: statusBarHeight + 20, bottom: 10),
                width: double.infinity,
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 40,
                      height: 55,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: (){
                          Navigator.pop(context);
                        } ,
                        icon: const Icon(Icons.arrow_back, color: Colors.white,)),
                    ),
                    Flexible(flex: 1, child: Container(
                      height: 80,
                      margin: const EdgeInsets.only(right: 24, left: 6),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _searchKeyword = value;
                          });
                        },
                        validator: (value) {

                        },
                        focusNode: _focusNode,
                        controller: _editingController,
                        keyboardType: TextInputType.text,
                        cursorColor: Palette.colorPrimaryText,
                        cursorWidth: 1.5,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Palette.colorPrimaryIcon,
                            ),
                            suffixIcon: _getClearBtn(),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            labelText: '검색어를 입력하세요.',
                            helperText: '해당 지역 및 종목 에 한하여 검색 됩니다.',
                            helperStyle: const TextStyle(
                              color: Colors.white
                            ),
                            labelStyle: TextStyle(
                                color: _focusNode.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                    color: Palette.colorPrimaryText,
                                    width: 1.5
                                )
                            )
                        ),
                      ),
                    ),),
                  ],
                )
              ),
              Container(
                margin: const EdgeInsets.only(right: 12, left: 12),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        filterBottomSheet(
                            context,
                            _filterLocationList.indexOf(_locationSelectValue),
                            (index) {
                              setState(() {
                                _editingController.clear();
                                _searchKeyword = '';
                                _locationSelectValue = _filterLocationList[index];
                                _items = requestSearchItems();
                              });
                              Navigator.pop(context);
                            },
                            '지역을 선택해 주세요.',
                            _filterLocationList
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_locationSelectValue), // <-- Text
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon( // <-- Icon
                            Icons.arrow_drop_down_circle_rounded,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      onPressed: () {
                        filterBottomSheet(
                            context,
                            _sortList.indexOf(_sortType),
                            (index) {
                              setState(() {
                                _sortType = _sortList[index];
                                _items = requestSearchItems();
                              });
                              Navigator.pop(context);
                            },
                            '선택해 주세요.',
                            _sortList
                        );
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_sortType), // <-- Text
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon( // <-- Icon
                            Icons.arrow_drop_down_circle_rounded,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 1, color: Palette.colorDividers,),
              Expanded(child: _clubListBuilder())
            ],
          ),
        )
    );
  }

  Widget? _getClearBtn() {
    if (!_isShowTxtClearBtn) { return null; }
    return IconButton(onPressed: () {
      _editingController.clear();
      setState(() {
        _searchKeyword = '';
      });
    }, icon: const Icon(Icons.clear, color: Palette.colorPrimaryIcon,));
  }

  Future<void> filterBottomSheet(
      BuildContext context,
      int initialIndex,
      BottomSheetSelectCallback selectCallback,
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
      builder: (context) => _BottomSheetUi(initialIndex: initialIndex, selectCallback: selectCallback, title: title, list: list));
  }

  Widget _clubListBuilder() => FutureBuilder<List<ResponseSearchClubInfo>>(
    future: _items,
    builder: (context, snapshot) {
      Widget childWidget;
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          childWidget = const CircularProgressIndicator(key: ValueKey(0), color: Colors.redAccent,);
          break;
        case ConnectionState.active:
          childWidget = const Text('active', key: ValueKey(1),);
          break;
        case ConnectionState.done:
          if (snapshot.hasData) {
            if (snapshot.requireData.isEmpty) {
              childWidget = Container(
                margin: const EdgeInsets.only(top: 24),
                key: const ValueKey(2),
                child: const Text(
                  '해당 지역에는 클럽이 없습니다.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Palette.colorSecondaryText
                  ),
                ),
              );
            } else {
              childWidget = _clubList(snapshot.requireData, 3);
            }
          } else {
            childWidget = const Text('Error', key: ValueKey(4),);
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

  Widget _clubList(List<ResponseSearchClubInfo> data, int key) {
    return ListView.builder(
        key: ValueKey(key),
        shrinkWrap: false,
        itemCount: data.length,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (context, index) {
          return data[index].clubName?.contains(_searchKeyword) == true ? _OpenContainerWrapper(
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return _ClubItemWidget(data: data[index], openContainer: openContainer,);
            }, data: data[index],
          ) : Container();
        }
    );
  }
}

class _ClubItemWidget extends StatelessWidget {
  const _ClubItemWidget({required this.data, required this.openContainer});
  final ResponseSearchClubInfo data;
  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0)
            )
          ]
      ),
      width: double.infinity,
      height: 122,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 12),
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7C7C7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: data.clubImg?.isEmpty == true ? Container() : Image.asset(data.clubImg??'', fit: BoxFit.fill,),
                    )
                ),
                Flexible(flex: 1, child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Palette.colorPrimaryIcon, size: 14,),
                          const SizedBox(width: 5,),
                          Text('${data.clubGuDescription}', style: const TextStyle(
                              color: Palette.colorSecondaryText, fontSize: 12
                          ),)
                        ],
                      ),
                      Text('${data.clubName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Palette.colorPrimaryText,
                            fontSize: 14
                        ),),
                      Text('클럽장 : ${data.clubAdminName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Palette.colorSecondaryText,
                            fontSize: 14
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.sports_basketball, color: Palette.colorPrimaryIcon, size: 15,),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: Text('${data.memberCount}명',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Palette.colorSecondaryText, fontSize: 14
                              ),),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
                //todo child: image set!
              ],
            ),
            Positioned.fill(child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: openContainer,
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _BottomSheetUi extends StatelessWidget {
  _BottomSheetUi({
    Key? key,
    required this.initialIndex,
    required this.selectCallback,
    required this.title,
    required this.list
  }): super(key: key);

  final int initialIndex;
  final BottomSheetSelectCallback selectCallback;
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
              child: Text(
                '확인',
                style: const TextStyle(
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

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
    //required this.onClosed,
    required this.data,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  //final ClosedCallback<bool?> onClosed;
  final ResponseSearchClubInfo data;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      //transitionDuration: Duration(milliseconds: 400),
      openBuilder: (BuildContext context, VoidCallback _) {
        return ClubMain2(data: data);
      },
      //onClosed: onClosed,
      tappable: false,
      closedElevation: 0.0,
      openElevation: 0.0,
      closedBuilder: closedBuilder,
    );
  }
}

