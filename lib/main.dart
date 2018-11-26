import 'package:flutter/material.dart';
import 'package:to_do_flutter/database/tasks_data_base.dart';
import 'package:to_do_flutter/model/note_task.dart';
import 'package:to_do_flutter/new_note.dart';
import 'package:to_do_flutter/note.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/newNote': (context) => NewNote(),
        '/note': (context) => Note()
      },
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.split("/");

        switch (path[1]) {
          case "newNote":
            return MaterialPageRoute(
                builder: (ctx) {
                  return NewNote(
                    task: path[2],
                    priority: int.parse(path[3]),
                    editMode: path[4].contains("true") ? true : false,
                  );
                },
                settings: routeSettings);
          case "note":
            return MaterialPageRoute(
                builder: (ctx) => Note(
                      task: path[2],
                      priority: int.parse(path[3]),
                    ),
                settings: routeSettings);
        }
      },
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

Future<List<NoteTask>> fetchNotesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<NoteTask>> notes = dbHelper.getNotes();

  return notes;
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("We need ToDo"),
        centerTitle: true,
        actions: <Widget>[
          popupMenuButton
        ],
      ),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/newNote//0/false');
        },
      ),
    );
  }

  final Widget popupMenuButton = PopupMenuButton(
    onSelected: (val) {
      print("$val");
    },
    itemBuilder: (ctx) {
      return <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            title: Text("алфавит"),
          ),
          value: 0,
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text("приоретет"),
          ),
          value: 1,
        ),
      ];
    },
  );
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NoteTask>>(
      future: fetchNotesFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  "Задачи не найденны",
                  //style: Theme.of(context).textTheme.body1,
                ));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {

                    },
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          '/note/${snapshot.data[index].task}/${snapshot.data[index].priority}'
                      );
                    },
                    child: _Item(context, index, snapshot),
                  );
                });
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
          alignment: AlignmentDirectional.center,
          child: new CircularProgressIndicator(),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  final int index;
  final AsyncSnapshot<List<NoteTask>> snapshot;

  _Item(BuildContext context, this.index, this.snapshot);

  @override
  Widget build(BuildContext context) {

    final Widget _doneDialog = AlertDialog(
      title:
      SingleChildScrollView(child: Text("Задание сделанно")),
      content: Text(
          "Отметить задание как выполненное и убрать из списка дел?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("ОТМЕНА")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("ВЫПОЛНЕННО")),
      ],
    );

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getColor(snapshot.data[index].priority),
          child: Text(iconPri(snapshot.data[index].priority)),
        ),
        title: Text(snapshot.data[index].task),
        subtitle: Text("22.10.2018"),
        trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return _doneDialog;
                  });
            }),
      ),
    );
  }

  String iconPri(int priority) {
    switch (priority) {
      case 0:
        return "ВС";
      case 1:
        return "НС";
      case 2:
        return "ВН";
      case 3:
        return "НН";
      default:
        return "  ";
    }
  }

  Color getColor(int priority) {
    switch (priority) {
      case 0:
        return Colors.red[600];
      case 1:
        return Colors.orangeAccent[200];
      case 2:
        return Colors.yellow[600];
      case 3:
        return Colors.lightGreen[300];
      default:
        return Colors.blue;
    }
  }
}
