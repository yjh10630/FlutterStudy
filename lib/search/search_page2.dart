import 'package:flutter/material.dart';

import '../dialog/selector_dialog.dart';
import '../icon_widget.dart';
import '../model/response_search_club_info.dart';
import '../utils/color_palette.dart';

class SearchPage2 extends StatefulWidget {
  const SearchPage2({Key? key}): super(key: key);

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {

  late TextEditingController _searchEditController;
  List<String> cateList = ["클럽", "게시판"];
  String searchCategory = "클럽";
  late Future<List<ResponseSearchClubInfo>> _items;

  @override
  void initState() {
    super.initState();
    _searchEditController = TextEditingController();
  }

  @override
  void dispose() {
    _searchEditController.dispose();
    super.dispose();
  }

  Future<void> categorySelect (
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
        backgroundColor: Palette.windowBlackBackground,
        context: context,
        builder: (context) => SelectorBottomSheet(initialIndex: initialIndex, selectCallback: callback, title: title, list: list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        titleSpacing: 0,
        title: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 7),
                child: TextFormField(
                  controller: _searchEditController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  cursorColor: Colors.white30,
                  cursorWidth: 1.5,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white10, width: 0.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white10, width: 0.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white10, width: 0.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    hintText: '검색어를 입력하세요.',
                    hintStyle: const TextStyle(color: Colors.white24,),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(searchCategory,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.white,)
                      ],
                    ),
                  ),
                  Positioned.fill(child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        categorySelect(context,
                            cateList.indexOf(searchCategory),
                                (index) {
                                  setState(() {
                                    searchCategory = cateList[index];
                                    Navigator.pop(context);
                                  });
                                }, '검색 카테고리 설정', cateList);
                      },
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
       body: Container(),
    );
  }
}