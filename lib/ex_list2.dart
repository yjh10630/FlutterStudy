import 'package:flutter/material.dart';
import 'package:diffutil_dart/diffutil.dart' as diffutil;

class ListExample2 extends StatefulWidget {
  const ListExample2({Key? key}): super(key: key);

  @override
  _ListExampleState createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample2> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final duration = const Duration(milliseconds: 250);
  late Future<List<String>> _items;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _items = requestData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<String>> requestData() async {
    var newItem = [
      "Item 11",
      "Item 22",
      "Item 33",
      "Item 44",
      "Item 55",
      "Item 66",
      "Item 77",
      "Item 88",
      "Item 99",
      "Item 100",
      "Item 110",
      "Item 120",
    ];
    await Future.delayed(const Duration(seconds: 3), () {});
    return newItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _clubListBuilder()
      ),
    );
  }

  Widget _clubListBuilder() => FutureBuilder<List<String>>(
      future: _items,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
            return const Text('active');
          case ConnectionState.done: {
            if (snapshot.hasData) {
              return FadeTransition(opacity: _animation, child: _listWidget(snapshot.requireData),);
            } else {
              return const Text('Error');
            }
          }
        }
      }
  );

  Widget _listWidget(List<String> items) {
    return AnimatedList(
        key: _key,
        initialItemCount: items.length,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 10,
              color: Colors.orange,
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(items[index], style: const TextStyle(fontSize: 24)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeItem(index),
                ),
              ),
            ),
          );
        }
    );
  }
  void _removeItem(int index) {
    _key.currentState?.removeItem(index, (context, animation) {
      return FadeTransition(
        opacity: animation,
        child: const Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.purple,
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text("Goodbye", style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    }, duration: duration);
  }
}