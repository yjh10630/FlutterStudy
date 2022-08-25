import 'package:flutter/material.dart';
import 'package:diffutil_dart/diffutil.dart' as diffutil;

class ListExample extends StatefulWidget {
  const ListExample({Key? key}): super(key: key);

  @override
  _ListExampleState createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  final _items = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final duration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _diffListUpdate(_getData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<String>> _getData() async {
    var newItem = [
      "Item 88",
      "Item 11",
      "Item 22",
      "Item 23",
      "Item 55",
      "Item 66",
    ];
    return await Future.delayed(Duration(seconds: 1), () => newItem);
    //return await Future.value(newItem);
  }

  void _diffListUpdate(Future<List<String>> data) {
    data.then((list) {
      print('onSuccess ${list.toString()}');
      final listDiff = diffutil
          .calculateListDiff(_items, list, detectMoves: true)
          .getUpdatesWithData();

      for (final update in listDiff) {
        update.when(
          insert: (index, data) { _insertItem(index, data); },
          remove: (index, data) { _removeItem(index); },
          change: (index, oldData, newData) => print('changed on $index oldData $oldData newData $newData'),
          move: (fromIndex, toIndex, data) {
            print('move from $fromIndex to $toIndex data$data} ');
            _removeItem(fromIndex);
            _insertItem(toIndex, data);
          },
        );
      }
    }).catchError((onError) {
      print('error > $onError');
    });
  }

  void _insertItem(int index, dynamic data) {
    _items.insert(index, data);
    _key.currentState?.insertItem(index, duration : duration);
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
    _items.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedList(
                key: _key,
                initialItemCount: 0,
                itemBuilder: (context, index, animation) {
                  if (index == 0) {
                    return FadeTransition(
                      key: UniqueKey(),
                      opacity: animation,
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 10,
                        color: Colors.orange,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text('나는 고정임', style: const TextStyle(fontSize: 24)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeItem(index),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return FadeTransition(
                      key: UniqueKey(),
                      opacity: animation,
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 10,
                        color: Colors.orange,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(_items[index-1], style: const TextStyle(fontSize: 24)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeItem(index-1),
                          ),
                        ),
                      ),
                    );
                  }
                }
            ),
            ElevatedButton(
              onPressed: () {
                var newItem = [
                  "Item 88",
                  "Item 11",
                  "Item 22",
                  "Item 23",
                  "Item 55",
                  "Item 66",
                ];
                newItem.shuffle();
                _diffListUpdate(Future.value(newItem));
              },
              child: Text('셔플'),
            ),
          ],
        )
      ),
    );
  }
}