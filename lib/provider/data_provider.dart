import 'package:flutter/material.dart';

import '../core/sql_helper.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> get journals => _journals;

  void refreshJournals() async {
    final data = await SQLHelper.getItems();
    _journals = data;
    notifyListeners();
  }

  Future<void> addItem(String title, String description) async {
    try {
      await SQLHelper.createItem(title, description);
      refreshJournals();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateItem(int id, String title, String description) async {
    await SQLHelper.updateItem(id, title, description);
    refreshJournals();
  }

  Future<void> deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    refreshJournals();
  }
}
