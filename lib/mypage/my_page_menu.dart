import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../icon_widget.dart';
import '../img_full_page.dart';

class MyPageMenu extends StatefulWidget {
  const MyPageMenu({Key? key}): super(key: key);

  @override
  _MyPageMenuState createState() => _MyPageMenuState();
}

class _MyPageMenuState extends State<MyPageMenu> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        actions: [
          IconWidget(icon: const Icon(Icons.share_rounded, color: Colors.white,), onTap: () {}),
          IconWidget(icon: const Icon(Icons.more_vert_rounded, color: Colors.white,), onTap: () {}),
        ],
      ),
      body: Container(
        color: Colors.black.withOpacity(0.8),
        child: ListView(
          children: [
            _UserInfo(
              isMe: true,
              goToUserEditor: () {}
            ),
            ExpansionTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedTextColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Text('상세 프로필',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                childrenPadding: EdgeInsets.only(left: 20, right: 20),
                initiallyExpanded: false,
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text('키 : 180cm', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('몸무게 : 90kg', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('포지션 : 파워포워드', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('활동지역 : 경기, 인천', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('간단하게 하고싶은말 : 열심히 하겠습니다.', style: TextStyle(color: Colors.white),)),
                  SizedBox(height: 10,)
                ]
            ),
            ExpansionTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedTextColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Text('참석률 관련 View 작업 예정',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                childrenPadding: EdgeInsets.only(left: 20, right: 20),
                initiallyExpanded: false,
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text('클럽 참여도', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('개인 모임 참여도', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('매너 좋음 / 매너 나쁨 수치', style: TextStyle(color: Colors.white),)),
                  Align(alignment: Alignment.centerLeft, child: Text('마지막 접속 은 \'오늘\' 입니다.', style: TextStyle(color: Colors.white),)),
                  SizedBox(height: 10,)
                ]
            ),
            _TextWidgetWithOnTab(txt: '가입된 클럽', onTab: () {},),
            _TextWidgetWithOnTab(txt: '경기 기록지', onTab: () {},),
            _TextWidgetWithOnTab(txt: '경기 활동 지역', onTab: () {},),
            _TextWidgetWithOnTab(txt: '추가 할 것이 있으면 또 추가 예정', onTab: () {},),
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  _UserInfo({
    Key? key,
    required this.isMe,
    required this.goToUserEditor,
  }): super(key: key);

  final bool isMe;
  final VoidCallback goToUserEditor;
  String userImgUrl = 'https://source.unsplash.com/random';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 40,
                  child: ClipOval(
                    child: Image.network(
                      userImgUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.person, color: Colors.white, size: 40,),);
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (userImgUrl.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ImgFullPage(imgs: [userImgUrl],
                            initIndex: 0,))
                      );
                    }
                  },
                ),
              ))
            ],
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "남 / 1989년생",
                style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.normal,
                    fontSize: 14
                ),
              ),
              Text(
                '윤지훈',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: isMe,
          child: TextButton(
            onPressed: goToUserEditor,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.white10),
            ),
            child: const Text('편집',
              style: TextStyle(
                color: Colors.white60,
                decoration: TextDecoration.underline,
              ),),
          )
        )
      ],
    );
  }
}

class _TextWidgetWithOnTab extends StatelessWidget {
  const _TextWidgetWithOnTab({
    Key? key,
    required this.txt,
    required this.onTab
  }): super(key: key);

  final String txt;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(txt,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white,),
      onTap: onTab,
    );
  }

}