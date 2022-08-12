import 'package:flutter/material.dart';
import 'package:study_flutter/search_page.dart';
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
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: scrollController,
                    itemCount: 100 + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return SizedBox(
                          height: 60,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0, bottom: 24),
                                  child: Container(
                                    width: 50,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                        color: Palette.colorDividers,
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              children: [
                                                Text('TEST',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54
                                                ),),
                                                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54,)
                                              ],
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
                                  ),
                                ),
                              )
                            ],
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
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 0.75)
                          )
                        ],
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: BoardBar(
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

class BoardBar extends StatefulWidget {
  const BoardBar({
    Key? key,
    required this.onClose,
  }) : super(key: key);
  final VoidCallback onClose;

  @override
  _BoardBarState createState() => _BoardBarState();
}

class _BoardBarState extends State<BoardBar> {

  int _widgetId = 1;
  bool _isShowTxtClearBtn = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    _editingController.addListener(() {
      setState(() {
        _isShowTxtClearBtn = _editingController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Widget _searchIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.black54,
              ),
            ),
            Positioned.fill(child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _updateWidget();
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget? _getClearBtn() {
    if (!_isShowTxtClearBtn) { return null; }
    return IconButton(onPressed: () {
      _editingController.clear();
    }, icon: const Icon(Icons.clear, color: Palette.colorPrimaryIcon,));
  }

  Widget _textField() {
    return Row(
      key: Key('textField'),
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 4),
            child: TextFormField(
              controller: _editingController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.black45,
              cursorWidth: 1.5,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '검색어를 입력하세요.',
                  suffixIcon: _getClearBtn(),
                  hintStyle: const TextStyle(color: Colors.black26,),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black26,
                  )
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black54,
                ),
              ),
              Positioned.fill(child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _updateWidget();
                  },
                ),
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _searchIcon() : _textField();
  }

  void _updateWidget() {
    setState(() {
      _widgetId = _widgetId == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                  ),
                  Positioned.fill(child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onClose();
                      },
                    ),
                  ))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('TEST',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54,)
                      ],
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
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _renderWidget(),
          )
        ],
      ),
    );
  }
}
