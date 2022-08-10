import 'package:flutter/material.dart';
import 'package:study_flutter/model/response_search_club_info.dart';

import '../utils/color_palette.dart';

final List<TabType> _tabList = <TabType> [
  TabType.clubInfo,
  TabType.clubSchedule,
  TabType.clubBoard,
  TabType.clubPhoto,
  TabType.clubMember,
  TabType.clubChat
];

enum TabType {
  clubInfo,
  clubSchedule,
  clubBoard,
  clubPhoto,
  clubMember,
  clubChat
}

String converterTabTypeText(TabType type) {
  switch(type) {
    case TabType.clubInfo:
      return '클럽정보';
    case TabType.clubSchedule:
      return '모임일정';
    case TabType.clubBoard:
      return '게시판';
    case TabType.clubPhoto:
      return '사진첩';
    case TabType.clubMember:
      return '멤버';
    case TabType.clubChat:
      return '채팅';
  }
}

const double appBarExpandingHeight = 200.0;

class ClubMain extends StatefulWidget {
  final ResponseSearchClubInfo data;
  const ClubMain({Key? key, required this.data}): super(key: key);

  @override
  _ClubMainState createState() => _ClubMainState();
}

class _ClubMainState extends State<ClubMain> with SingleTickerProviderStateMixin {

  late TabController _controller;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  late TextEditingController _editingController;
  bool _isShowTxtClearBtn = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _focusNode = FocusNode();
    _editingController = TextEditingController();
    _editingController.addListener(() {
      setState(() {
        _isShowTxtClearBtn = _editingController.text.isNotEmpty;
      });
    });
    _controller = TabController(length: _tabList.length, vsync: this)..addListener(() {
      if (_controller.indexIsChanging) {
        setState(() {
          _selectedIndex = _controller.index;
        });
        print('selected >> ${_controller.index.toString()}');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          length: _tabList.length,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: appBarExpandingHeight,
                  elevation: 0.0,
                  pinned: true,
                  backgroundColor: Colors.redAccent,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: _horizontalTitlePadding
                    ),
                    centerTitle: false,
                    title: Text(widget.data.clubName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                    //background: widget.data.clubImg?.isEmpty == true ? Container(color: Palette.colorAccent.withOpacity(0.7),) : c,
                    background: Stack(
                      children: _stackCollapsBgWidget(widget.data.clubImg),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      isScrollable: true,
                      controller: _controller,
                      labelColor: Colors.redAccent,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 12,
                          fontWeight: FontWeight.normal
                      ),
                      unselectedLabelColor: Colors.white,
                      //indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                        color: Colors.white),
                      tabs : [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(converterTabTypeText(_tabList[0])),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(converterTabTypeText(_tabList[1])),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(converterTabTypeText(_tabList[2])),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(converterTabTypeText(_tabList[3])),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(converterTabTypeText(_tabList[4])),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(converterTabTypeText(_tabList[5])),
                          ),
                        )
                      ]
                    ),
                  ),
                  pinned: true,
                ),
                const SliverPersistentHeader(
                  pinned: true,
                  delegate: MemberInputEditText()
                )
              ];
            },
            body: TabBarView(
              controller: _controller,
              children: [
                _clubInfoPage(),
                _clubSchedulePage(),
                _clubBoardPage(),
                _clubPhotoPage(),
                _clubMemberPage(),
                _clubChatPage()
              ]
            ),
          ),
        ),
      ),
    );
  }

  /// 클럽 멤버 화면
  Widget _clubMemberPage() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 12, left: 24, right: 24),
            child: TextFormField(
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
                  labelText: '회원 이름을 검색하세요.',
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
          ),
        ),
      ],
    );
  }

  /// 클럽 정보 화면
  Widget _clubInfoPage() {
    return Container(color: Colors.green);
  }

  /// 클럽 모임 화면
  Widget _clubSchedulePage() {
    return Container(color: Colors.blue);
  }

  /// 클럽 게시판 화면
  Widget _clubBoardPage() {
    return Container(color: Colors.orangeAccent);
  }

  /// 클럽 채팅 화면
  Widget _clubChatPage() {
    return Container(color: Colors.tealAccent);
  }

  /// 클럽 사진첩 화면
  Widget _clubPhotoPage() {
    return Container(color: Colors.deepOrangeAccent);
  }

  Widget? _getClearBtn() {
    if (!_isShowTxtClearBtn) { return null; }
    return IconButton(onPressed: () {
      _editingController.clear();
    }, icon: const Icon(Icons.clear, color: Palette.colorPrimaryIcon,));
  }

  double get _horizontalTitlePadding {
    const kBasePadding = 32.0;
    const kMultiplier = 0.5;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (appBarExpandingHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }
      if (_scrollController.offset > (appBarExpandingHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        return (appBarExpandingHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding;
      }
      // In case 0%-50% of the expanded height is viewed
      return (_scrollController.offset - (appBarExpandingHeight / 2)) * kMultiplier +
          kBasePadding;
    }
    return kBasePadding;
  }
}

List<Widget> _stackCollapsBgWidget(String? imgUrl) {
  var group = <Widget>[];
  group.add(Container(color: Colors.redAccent));
  if (imgUrl?.isNotEmpty == true) {
    group.add(Container(width:double.infinity, child: Image.asset(imgUrl??'', fit: BoxFit.fill),));
    group.add(Align(
      alignment: Alignment.bottomCenter,
      child: Container(height: 100,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.redAccent
                ]
            )
        ),
      ),
    ));
  }
  return group;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class MemberInputEditText extends SliverPersistentHeaderDelegate {
  const MemberInputEditText();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
        child: TextFormField(
          validator: (value) {

          },
          //focusNode: _focusNode,
          //controller: _editingController,
          keyboardType: TextInputType.text,
          cursorColor: Palette.colorPrimaryText,
          cursorWidth: 1.5,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              prefixIcon: Icon(
                Icons.search,
                color: Palette.colorPrimaryIcon,
              ),
              //suffixIcon: _getClearBtn(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              labelText: '회원 이름을 검색하세요.',
              helperStyle: TextStyle(
                  color: Colors.white
              ),
              /*labelStyle: TextStyle(
                  color: _focusNode.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
              ),*/
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(
                      color: Palette.colorPrimaryText,
                      width: 1.5
                  )
              )
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}