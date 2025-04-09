import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Import the collection package

// Import the collection package

class ListViewAnimated extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const ListViewAnimated({Key? key, required this.data}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListViewAnimatedState createState() => _ListViewAnimatedState();
}

class _ListViewAnimatedState extends State<ListViewAnimated> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Map<String, dynamic>> _animatedData;

  @override
  void initState() {
    super.initState();
    _animatedData = List<Map<String, dynamic>>.from(widget.data);
  }

  @override
  void didUpdateWidget(covariant ListViewAnimated oldWidget) {
    if (!const DeepCollectionEquality().equals(widget.data, _animatedData)) {
      _updateList();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateList() {
    final previousData = _animatedData;
    final newData = List<Map<String, dynamic>>.from(widget.data);

    final Set previousIds = previousData.map((item) => item['id']).toSet();
    final Set newIds = newData.map((item) => item['id']).toSet();

    // Items to be removed
    final List<Map<String, dynamic>> toRemove =
        previousData.where((item) => !newIds.contains(item['id'])).toList();

    // Items to be inserted
    final List<Map<String, dynamic>> toInsert =
        newData.where((item) => !previousIds.contains(item['id'])).toList();

    for (final item in toRemove) {
      final index = _animatedData.indexWhere((data) => data['id'] == item['id']);
      if (index != -1) {
        _listKey.currentState!.removeItem(
          index,
          (context, animation) => buildItem(item, animation),
          duration: const Duration(milliseconds: 300),
        );
        _animatedData.removeAt(index);
      }
    }

    for (int i = 0; i < toInsert.length; i++) {
      final item = toInsert[i];
      final index = newData.indexOf(item);
      _animatedData.insert(index, item);

      _listKey.currentState!.insertItem(
        index,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Widget buildItem(Map<String, dynamic> item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.star, color: Colors.redAccent),
          title: Text('Member: ${item['member']}'),
          subtitle: Text('credit: ${item['credit']}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      padding: const EdgeInsets.all(32),
      key: _listKey,
      physics: const BouncingScrollPhysics(),
      initialItemCount: _animatedData.length,
      itemBuilder: (context, index, animation) {
        final item = _animatedData[index];
        return buildItem(item, animation);
      },
    );
  }
}