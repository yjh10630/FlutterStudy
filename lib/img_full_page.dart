import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//todo Indicator 만들어야함.
class ImgFullPage extends StatefulWidget {
  const ImgFullPage({
    Key? key, required this.imgs, required this.initIndex
  }): super(key: key);

  final List<String> imgs;
  final int initIndex;
  @override
  _ImgFullPageState createState() => _ImgFullPageState();
}

class _ImgFullPageState extends State<ImgFullPage> {

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.only(top: 96, bottom: 36),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imgs.length,
                itemBuilder: (context, index) {
                  return Image.network(widget.imgs[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('error > ${error}');
                      return const Center(child: Icon(Icons.error_outline_rounded),);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: Icon(Icons.insert_photo_outlined),);
                    },
                  );
                }
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 36, left: 12),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white70,),
                onPressed: () { Navigator.pop(context); },
              ),
            ),
          )
        ],
      ),
    );
  }
}