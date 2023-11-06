import 'package:flutter/material.dart';

import '../core/sql_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _journals = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
    });
  }

  Future<void> addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  Future<void> updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  Future<void> deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshJournals();
  }

  void showForm(int? id) async {
    if (id != null) {
      final existingJournal = _journals.firstWhere((item) => item['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await addItem();
                        }
                        if (id != null) {
                          await updateItem(id);
                        }
                        _titleController.text = "";
                        _descriptionController.text = "";
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: Text(id == null ? "Create Entry" : "Update Entry"))
                ],
              ),
            ));
  }

  @override
  void initState() {
    _refreshJournals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFlite Crud"),
      ),
      body: ListView.builder(
          itemCount: _journals.length,
          itemBuilder: ((context, index) => Card(
                color: const Color.fromARGB(255, 221, 208, 239),
                margin: const EdgeInsetsDirectional.all(10),
                child: ListTile(
                  title: Text(
                    _journals[index]['title'],
                  ),
                  subtitle: Text(_journals[index]['description']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              showForm(_journals[index]['id']);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteItem(_journals[index]['id']);
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              ))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () => showForm(null)),
    );
  }
}
