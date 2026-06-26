import 'package:flutter/material.dart';

class InMemoryRecordStore<T> extends ChangeNotifier {
  InMemoryRecordStore({required List<T> seedItems}) : _items = List<T>.from(seedItems);

  final List<T> _items;
  List<T> get items => List.unmodifiable(_items);

  void add(T item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void updateAt(int index, T item) {
    if (index < 0 || index >= _items.length) return;
    _items[index] = item;
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void replaceAll(List<T> items) {
    _items
      ..clear()
      ..addAll(items);
    notifyListeners();
  }
}

class DummyRepoItem {
  const DummyRepoItem({required this.id, required this.title, required this.subtitle, this.status = 'Active'});

  final String id;
  final String title;
  final String subtitle;
  final String status;

  DummyRepoItem copyWith({String? id, String? title, String? subtitle, String? status}) {
    return DummyRepoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
    );
  }
}
