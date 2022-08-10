import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_flutter/search_page.dart';
import 'ex_list.dart';
import 'ex_list2.dart';
import 'utils/color_palette.dart';

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
                      onTap: () {},
                    ),
                    MenuItem(
                      name: '클럽 생성',
                      icon: const Icon(
                        Icons.group_add_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {},
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
            DraggableSearchableListView(minHeight: boardHeight,)
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


class DraggableSearchableListView extends StatefulWidget {
  const DraggableSearchableListView({
    Key? key, required this.minHeight,
  }) : super(key: key);

  final double minHeight;

  @override
  _DraggableSearchableListViewState createState() =>
      _DraggableSearchableListViewState();
}

class _DraggableSearchableListViewState
    extends State<DraggableSearchableListView> {
  final ValueNotifier<bool> searchFieldVisibility = ValueNotifier<bool>(false);
  @override
  void dispose() {
    searchFieldVisibility.dispose();
    super.dispose();
  }

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
                return Container(
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 100 + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0, bottom: 24),
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: Palette.colorDividers,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0))
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListTile(title: Text('Item $index')));
                    },
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
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).dividerColor),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: SearchBar(
                        onClose: () {
                          searchFieldVisibility.value = false;
                          DraggableScrollableActuator.reset(context);
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

class SearchBar extends StatelessWidget {
  final VoidCallback onClose;

  const SearchBar({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 56.0,
              width: 56.0,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    color: theme.textTheme.caption!.color,
                  ),
                  onTap: () {
                    onClose();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
