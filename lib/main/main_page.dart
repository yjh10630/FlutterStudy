import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter/search/search_page.dart';
import '../board/board_write_page.dart';
import '../ex_list.dart';
import '../ex_list2.dart';
import '../utils/color_palette.dart';
import 'main_board_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {

    var padding = MediaQuery.of(context).viewPadding;
    double screenHeight = MediaQuery.of(context).size.height - padding.top;
    double boardHeight = (screenHeight - 280) / screenHeight;

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
      backgroundColor: Colors.white24,
      body: SafeArea(
        child:Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Hi, JiHun!",  //todo userName
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned.fill(child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                    ),
                                  ))
                                ],
                              ),
                            )
                          ]
                      ),
                      const SizedBox(height: 20,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Search',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned.fill(child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SearchPage())
                                  );
                                },
                              ),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MenuItem(
                      name: '내 클럽',
                      icon: const Icon(
                        Icons.groups_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {
                        //todo test
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ListExample())
                        );
                      },
                    ),
                    MenuItem(
                      name: '클럽 생성',
                      icon: const Icon(
                        Icons.group_add_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {
                        //todo test
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ListExample2())
                        );
                      },
                    ),
                    MenuItem(
                      name: '좋아요',
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                    MenuItem(
                      name: '설정',
                      icon: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {},
                    )
                  ],
                )
              ],
            ),
            DraggableMainBoardListView(minHeight: boardHeight,)
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.name,
    required this.icon,
    required this.onTap
  }): super(key: key);

  final String name;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.all(15),
                  child: icon,
                ),
                const SizedBox(height: 8,),
                Text(name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ))
        ],
      ),
    );
  }
}
