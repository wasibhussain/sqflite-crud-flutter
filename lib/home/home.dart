import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_crud_app/provider/data_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Map<String, dynamic>> _journals = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // void _refreshJournals() async {
  //   final data = await SQLHelper.getItems();
  //   setState(() {
  //     _journals = data;
  //   });
  // }

  // Future<void> addItem() async {
  //   await SQLHelper.createItem(
  //       _titleController.text, _descriptionController.text);
  //   _refreshJournals();
  // }

  // Future<void> updateItem(int id) async {
  //   await SQLHelper.updateItem(
  //       id, _titleController.text, _descriptionController.text);
  //   _refreshJournals();
  // }

  // Future<void> deleteItem(int id) async {
  //   await SQLHelper.deleteItem(id);
  //   _refreshJournals();
  // }
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<DataProvider>(context, listen: false).refreshJournals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    print(dataProvider.journals.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFLite CRUD"),
      ),
      body: ListView.builder(
          itemCount: dataProvider.journals.length,
          itemBuilder: ((context, index) => Card(
                color: const Color.fromARGB(255, 221, 208, 239),
                margin: const EdgeInsetsDirectional.all(10),
                child: ListTile(
                  title: Text(
                    dataProvider.journals[index]['title'],
                  ),
                  subtitle: Text(dataProvider.journals[index]['description']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              if (dataProvider.journals[index]['id'] != null) {
                                final existingJournal = dataProvider.journals
                                    .firstWhere((item) =>
                                        item['id'] ==
                                        dataProvider.journals[index]['id']);
                                _titleController.text =
                                    existingJournal['title'];
                                _descriptionController.text =
                                    existingJournal['description'];
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
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextField(
                                              controller: _titleController,
                                              decoration: const InputDecoration(
                                                  hintText: "Title"),
                                            ),
                                            const SizedBox(height: 20),
                                            TextField(
                                              controller:
                                                  _descriptionController,
                                              decoration: const InputDecoration(
                                                  hintText: "Description"),
                                            ),
                                            const SizedBox(height: 30),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  if (dataProvider
                                                              .journals[index]
                                                          ['id'] ==
                                                      null) {
                                                    await dataProvider.addItem(
                                                        _titleController.text,
                                                        _descriptionController
                                                            .text);
                                                  }
                                                  if (dataProvider
                                                              .journals[index]
                                                          ['id'] !=
                                                      null) {
                                                    await dataProvider.updateItem(
                                                        dataProvider
                                                                .journals[index]
                                                            ['id'],
                                                        _titleController.text,
                                                        _descriptionController
                                                            .text);
                                                  }
                                                  _titleController.text = "";
                                                  _descriptionController.text =
                                                      "";
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text(
                                                    dataProvider.journals[index]
                                                                ['id'] ==
                                                            null
                                                        ? "Create Entry"
                                                        : "Update Entry"))
                                          ],
                                        ),
                                      ));
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              dataProvider.deleteItem(
                                  dataProvider.journals[index]['id']);
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              ))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
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
                          decoration:
                              const InputDecoration(hintText: "Description"),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () async {
                              await dataProvider.addItem(_titleController.text,
                                  _descriptionController.text);
                              _titleController.text = "";
                              _descriptionController.text = "";
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Create Entry"))
                      ],
                    ),
                  ))),
    );
  }
}
