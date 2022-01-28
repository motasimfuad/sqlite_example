import 'package:flutter/material.dart';
import 'package:sqlite_example/db_helper.dart';
import 'package:sqlite_example/notes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DBHelper? dbHelper;
  late Future<List<NoteModel>> notesList;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getNotes();
  }

  stayTop() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(microseconds: 100),
      curve: Curves.easeOut,
    );
  }

  getNotes() async {
    notesList = dbHelper!.getNotes();
    stayTop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Sqlite example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      controller: scrollController,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data![index].id.toString()),
                                      Text(snapshot.data![index].title),
                                      Text(snapshot.data![index].description),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            dbHelper!.updateNote(
                                              NoteModel(
                                                id: snapshot.data![index].id,
                                                title: 'Edited',
                                                description:
                                                    'This is still easy and fun',
                                              ),
                                            );
                                            getNotes();
                                          });
                                        },
                                        icon: const Icon(Icons.edit),
                                        color: Colors.purple,
                                        splashColor: Colors.transparent,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            dbHelper!.deleteNote(
                                                snapshot.data![index].id!);
                                            getNotes();
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        splashColor: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            var note = await dbHelper!.insert(
              NoteModel(title: 'Sql', description: 'This is so easy and fun!'),
            );
            print('Note id $note');
            setState(() {
              getNotes();
              stayTop();
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
