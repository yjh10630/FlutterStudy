import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_flutter/club/test.dart';
import '../board/board_page.dart';
import '../model/response_search_club_info.dart';
import '../utils/color_palette.dart';
import 'dart:math' as math;

typedef BottomSheetStringCallback = void Function(String);
const String _loremIpsumParagraph =
    '일주일에 정기적으로 농구하실 분들만 모집합니다!!\n'
    '대관비용없이 참여할 수 있어요 \n'
    '(주 1회 정모는 무료 ! 그 이외 벙개 및 별도 모임은 유료로 진행 예정 )\n'
    '모임분들의 의견을 반영하여 다른 운동들도 함께할 의향이 있으니 많은 참여 부탁 드립니다.';

class ClubMain2 extends StatefulWidget {
  final ResponseSearchClubInfo data;
  const ClubMain2({Key? key, required this.data}) : super(key: key);
  @override
  _ClubMainState2 createState() => _ClubMainState2();
}

class _ClubMainState2 extends State<ClubMain2> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isFloatBtnVisible = false;
  bool _isClubJoining = false;
  bool _isClubPick = false;

  @override
  void initState() {
    super.initState();
    //todo 가입 유무 확인 후 flag
    _isFloatBtnVisible = true;
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showClubJoinBottomSheet(BuildContext context, BottomSheetStringCallback callback) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Palette.windowBackground,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: _ClubJoinScreen(callback: callback)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        var expandedHeight = size.width * 0.7;
        return Scaffold(
          floatingActionButton: Visibility(
            visible: _isFloatBtnVisible,
            child: _ClubJoinBtn(
              isClubJoining: _isClubJoining,
              clickCallback: () {
                var msg = '';
                if (_isClubJoining) {
                  msg = '클럽가입이 취소 되었습니다.';
                  setState(() {
                    _isClubJoining = false;
                  });
                  Fluttertoast.showToast(
                    msg: msg,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT
                  );
                } else {
                  _showClubJoinBottomSheet(context, (value) {
                    msg = '${value.isNotEmpty ? '[${value}]' : ''}'
                        '클럽가입 신청이 완료 되었습니다.';
                    Fluttertoast.showToast(
                        msg: msg,
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_SHORT
                    );
                    Navigator.pop(context);
                    // todo 가입인사 들어오는 곳
                    setState(() {
                      _isClubJoining = true;
                    });
                  });
                }
              },
            )
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: _isClubPick
                            ? const Icon(Icons.favorite_rounded, key: ValueKey('icon1'))
                            : const Icon(Icons.favorite_border_rounded, key: ValueKey('icon2'))
                    ),
                    onPressed: () {
                      setState(() {
                        // todo pick 통신
                        _isClubPick = !_isClubPick;
                      });
                    },
                  ),
                  IconButton(onPressed: (){
                    Fluttertoast.showToast(msg: 'DeepLink 설정 후 적용 예정');
                  }, icon: const Icon(Icons.share_rounded), padding: const EdgeInsets.only(left: 8, right: 12), constraints: const BoxConstraints()),
                ],
                pinned: true,
                elevation: 5.0,
                title: Text(widget.data.clubName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    )),
                expandedHeight: expandedHeight,
                backgroundColor: Colors.black,
                flexibleSpace: _FlexibleSpace(
                  clubImg: widget.data.clubImg,
                  clubName: widget.data.clubName ?? '',
                  expandedHeight: expandedHeight,
                  scrollController: _scrollController,
                ),
              ),
              _SliverList()
            ],
          ),
        );
      },
    );
  }
}

class _FlexibleSpace extends StatelessWidget {
  const _FlexibleSpace({
    this.clubImg,
    required this.clubName,
    required this.expandedHeight,
    required this.scrollController
  });
  final String? clubImg;
  final String clubName;
  final double expandedHeight;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    return Stack(
      children: [
        FlexibleSpaceBar(
          background: clubImg?.isEmpty == true ? Container(color: Colors.black45,) : Image.asset(clubImg ??'', fit: BoxFit.fill,),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: statusBar + kToolbarHeight,
            child: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              background: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black45, Colors.transparent],
                        stops: [0.0, 0.30]
                    )
                ),
              ),
            ),
          ),
        ),
        /*FlexibleSpaceBar(
          titlePadding: EdgeInsets.symmetric(
              vertical: 16.0, horizontal: _horizontalTitlePadding(context, expandedHeight)
          ),
          title: Text(clubName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              )),
        )*/
      ],
    );
  }

  double _horizontalTitlePadding(BuildContext context, double imageHeight) {
    const kBasePadding = 16.0;
    const kMultiplier = 0.4;

    if (scrollController.hasClients) {
      if (scrollController.offset < (imageHeight / 2)) {
        return kBasePadding;
      }
      if (scrollController.offset > (imageHeight - kToolbarHeight)) {
        return (imageHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding;
      }
      return (scrollController.offset - (imageHeight / 2)) * kMultiplier +
          kBasePadding;
    }
    return kBasePadding;
  }
}

class _SliverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const _TodayVisitorsContainer(clubAdminName: '녹색꼬맹이',),
        const _ClubInfoTextContainer(infoTxt: _loremIpsumParagraph),
        const _ContentTitleWidget(title: '모임 정보', widget: OpenContainerTransformDemo(),),
        _NewMeetingInfoContainer(),
        const _ContentTitleWidget(title: '새로 올라온 글', widget: BoardPage(pageTitle: '클럽 게시판',),),
        _NewBoardContainer(),
        _NewPhotoContainer()
      ]),
    );
  }
}

// 클럽 가입 화면
class _ClubJoinScreen extends StatefulWidget {
  const _ClubJoinScreen({Key? key, required this.callback}): super(key: key);
  final BottomSheetStringCallback callback;
  @override
  _ClubJoinScreenState createState() => _ClubJoinScreenState();
}

class _ClubJoinScreenState extends State<_ClubJoinScreen> {

  late FocusNode _focusNode;
  String clubJoinComment = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
      height: MediaQuery.of(context).size.height / 3.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            height: 80,
            margin: const EdgeInsets.only(top: 24),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  clubJoinComment = value;
                });
              },
              focusNode: _focusNode,
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
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  labelText: '하고싶은 말 ( 선택 )',
                  helperText: '간단하게 전달하고 싶은 말을 적어주세요.',
                  helperStyle: const TextStyle(
                      color: Palette.colorSecondaryText
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
          Container(
            margin: const EdgeInsets.only(top: 20),
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
                widget.callback(clubJoinComment);
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

// 가입 하기 버튼
class _ClubJoinBtn extends StatelessWidget {
  const _ClubJoinBtn({required this.clickCallback, required this.isClubJoining});

  final VoidCallback clickCallback;
  final bool isClubJoining;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: clickCallback,
        backgroundColor: Colors.redAccent,
        label: Text(
            isClubJoining ? '취소하기' : '가입하기',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            )
        )
    );
  }
}

// 이번 주 모임 정보
class _NewMeetingInfoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 10),
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
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('정규 모임 x차',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Palette.colorPrimaryText,
                          fontSize: 14
                      ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.date_range, color: Palette.colorPrimaryIcon, size: 15,),
                        SizedBox(width: 5,),
                        Text('2022.07.15',
                          style: TextStyle(
                              color: Palette.colorSecondaryText, fontSize: 14
                          ),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.timer, color: Palette.colorPrimaryIcon, size: 15,),
                        SizedBox(width: 5,),
                        Text('08:00 - 11:00',
                          style: TextStyle(
                              color: Palette.colorSecondaryText, fontSize: 14
                          ),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.location_on_rounded, color: Palette.colorPrimaryIcon, size: 15,),
                        SizedBox(width: 5,),
                        Text('인천 서구 340 - 2',
                          style: TextStyle(
                              color: Palette.colorSecondaryText, fontSize: 14
                          ),),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {}
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

// 새로 올라온 게시글
class _NewBoardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 10),
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
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text('신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.colorPrimaryText,
                                fontSize: 14
                            ),),
                        ),
                        Transform.rotate(
                          angle: (50 * math.pi / 180),
                          child: const Icon(Icons.push_pin_rounded, size: 13,),
                        )
                      ],
                    ),
                    const Text('신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 신규 가입자 필독 사항 ',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Palette.colorSecondaryText,
                          fontSize: 10
                      ),),
                    const Text('홀깅돌 | 2022.02.03',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Palette.colorSecondaryText,
                          fontSize: 10
                      ),),
                  ],
                ),
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {}
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

// 새로 올라온 사진
class _NewPhotoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 100, color: Colors.redAccent, child: Text('새로 올라온 사진'),);
  }
}

// 오늘 방문자 수 및 활동 지수
class _TodayVisitorsContainer extends StatelessWidget {
  const _TodayVisitorsContainer({this.clubAdminImg, required this.clubAdminName});
  final String? clubAdminImg;
  final String clubAdminName;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0)
                  )
                ]
            ),
            width: 70,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Palette.colorDividers,
                                  width: 1,
                                )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: clubAdminImg == null || clubAdminImg?.isEmpty == true
                                  ? const Icon(Icons.person, color: Palette.colorSecondaryText,)
                                  : Image.network(clubAdminImg ?? '', fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(clubAdminName,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Palette.colorSecondaryText
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {}
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          _TextWidget(title: '12명', description: '회원 수', callback: () {}),
          _TextWidget(title: '42', description: '관심', callback: () {}),
          _TextWidget(title: '87%', description: '승률', callback: () {}),
          _TextWidget(title: '매우좋음', description: '활동지수', callback: () {}),
        ],
      ),
    );
  }
}

class _ClubInfoTextContainer extends StatelessWidget {
  const _ClubInfoTextContainer({required this.infoTxt});

  final String infoTxt;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 5, bottom: 5),
      color: Colors.white,
      child: Text(
        infoTxt,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Palette.colorSecondaryText
        ),
      ),
    );
  }
}

class _ContentTitleWidget extends StatelessWidget {
  const _ContentTitleWidget ({
    required this.title,
    this.widget
  });

  final String title;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Palette.colorPrimaryText
            ),),
          Visibility(
            visible: widget != null,
            child: _OpenContainerWrapper(
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return IconButton(onPressed: openContainer, icon: const Icon(Icons.more_horiz_rounded, color: Palette.colorPrimaryText,));
            },
            widget: widget!,
          ),),
        ],
      ),
    );
  }
}

class _TextWidget extends StatelessWidget {
  const _TextWidget({required this.title, required this.description, required this.callback});
  final String title;
  final String description;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(1.0, 1.0)
            )
          ]
      ),
      width: 70,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Palette.colorPrimaryText
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(description,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Palette.colorSecondaryText
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: callback
              ),
            ))
          ],
        ),
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