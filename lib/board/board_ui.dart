import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/response_common_board_info.dart';
import '../utils/color_palette.dart';

class BoardTag extends StatelessWidget {
  const BoardTag({
    Key? key,
    required this.tagName,
    required this.txtColor
  }): super(key: key);

  final String tagName;
  final Color txtColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.black.withOpacity(0.6)
      ),
      child: Text(
        tagName,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 9,
            color: txtColor
        ),
      ),
    );
  }
}

class BoardItemWidget extends StatefulWidget {
  const BoardItemWidget({
    Key? key,
    required this.callback,
    required this.data,
    required this.isLastItem
  }): super(key: key);
  final VoidCallback callback;
  final ResponseBoardInfo data;
  final bool isLastItem;
  @override
  _BoardItemWidgetState createState() => _BoardItemWidgetState();
}

class _BoardItemWidgetState extends State<BoardItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(children: [
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: widget.data.convertCategoryToTag().isNotEmpty,
                  child: BoardTag(
                    tagName: widget.data.convertCategoryToTag(),
                    txtColor: widget.data.tagColor(),
                  )
              ),
              const SizedBox(height: 12,),
              Text(widget.data.title ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              const SizedBox(height: 12,),
              Text(
                widget.data.detail ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14
                ),
              ),
              const SizedBox(height: 12,),
              Visibility(
                  visible: widget.data.photo?.isNotEmpty == true,
                  child: PhotoList(imgs: widget.data.photo)
              ),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Palette.colorDividers,
                          width: 1,
                        )
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.data.writeUserInfo?.userImg ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.person),);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Text(widget.data.writeUserInfo?.userName ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5)
                    ),),
                  Expanded(child: Container()),
                  Text(widget.data.createTime ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5)
                    ),),
                ],
              ),
              const SizedBox(height: 12,),
            ],
          ),
        ),
        Positioned.fill(child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: widget.callback
          ),
        ))
      ]),
      Divider(height: 1, color: Colors.black.withOpacity(0.8),),
      Container(
        color: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.only(left: 12, right: 12),
        height: 50,
        child: Row(
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.callback,
                icon: Icon(Icons.visibility, size: 20, color: Colors.white.withOpacity(0.5),)),
            const SizedBox(width: 3,),
            Text(widget.data.viewCount ?? '',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5)
              ),),
            const SizedBox(width: 10,),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: widget.data.isPick ?? false
                      ? const Icon(Icons.favorite_rounded, key: ValueKey('icon1'), size: 20, color: Colors.redAccent,)
                      : Icon(Icons.favorite_border_rounded, key: ValueKey('icon2'), size: 20, color: Colors.white.withOpacity(0.5),)
              ),
              onPressed: () {
                setState(() {
                  // todo pick 통신
                  widget.data.isPick = !(widget.data.isPick ?? false);
                });
              },
            ),
            const SizedBox(width: 3,),
            Text(widget.data.pickCount ?? '',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5)
              ),),
            Expanded(child: Container()),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.callback,
                icon: Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Colors.white.withOpacity(0.5),)),
            const SizedBox(width: 3,),
            Text(widget.data.reviewCount ?? '',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5)
              ),),
          ],
        ),
      ),
      Visibility(
          visible: !widget.isLastItem,
          child: Container(height: 10, color: Colors.black.withOpacity(0.7),)
      )
    ]);
  }
}

class PhotoList extends StatelessWidget {
  const PhotoList({Key? key, this.imgs}): super(key: key);

  final List<String>? imgs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
          children:[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: [
                  Image.network(imgs![0],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('error > ${error}');
                      return const Center(child: Icon(Icons.error_outline_rounded),);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: Icon(Icons.insert_photo_outlined),);
                    },
                  ),
                  Visibility(
                      visible: (imgs?.length ?? 0) > 1,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 12, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                              color: Colors.black.withOpacity(0.6)
                          ),
                          child: Text(
                            '+${(imgs?.length ?? 0) - 1}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9)
                            ),
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            const SizedBox(height: 12.0,)
          ]
      ),
    );
  }
}