import 'package:flutter/material.dart';

class AdminActionMessage {
  const AdminActionMessage({required this.title, required this.subtitle, this.color = const Color(0xFF16A34A), this.icon = Icons.check_circle_outline});

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
}

class AdminActionNotifier extends ChangeNotifier {
  final List<AdminActionMessage> _messages = [];
  List<AdminActionMessage> get messages => List.unmodifiable(_messages);

  void push(AdminActionMessage message) {
    _messages.insert(0, message);
    if (_messages.length > 6) {
      _messages.removeLast();
    }
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }
}
