import 'package:flutter/material.dart';
import 'package:to_do_flutter/database/tasks_data_base.dart';
import 'package:to_do_flutter/model/note_task.dart';

String task;
int priority;
bool editMode;
String oldTask;

class NewNote extends StatefulWidget {

  NewNote({task, priority, editMode});

  @override
  _NewNoteState createState() {
    oldTask = task;
    return _NewNoteState();
  }
}

class _NewNoteState extends State<NewNote> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New ToDo"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  _submit();
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      initialValue: task,
                      decoration: InputDecoration(labelText: "Задача"),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (val) =>
                      val.trim().isEmpty ? "Введите текст!" : null,
                      onSaved: (val) {
                        task = val;
                      },
                    ),
                  )),
              SizedBox(
                height: 50.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Divider(),
                  RadioListTile(
                    value: 0,
                    secondary: CircleAvatar(
                      backgroundColor: Colors.red[600],
                      child: Text("ВС"),
                    ),
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value;
                      });
                    },
                    title: Text("Важное\nСрочное"),
                  ),
                  Divider(),
                  RadioListTile(
                    value: 1,
                    secondary: CircleAvatar(
                      backgroundColor: Colors.orangeAccent[200],
                      child: Text("НС"),
                    ),
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value;
                      });
                    },
                    title: Text("Не важное\nСрочное"),
                  ),
                  Divider(),
                  RadioListTile(
                    value: 2,
                    secondary: CircleAvatar(
                      backgroundColor: Colors.yellow[600],
                      child: Text("ВН"),
                    ),
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value;
                      });
                    },
                    title: Text("Важное\nНе срочное"),
                  ),
                  Divider(),
                  RadioListTile(
                    value: 3,
                    secondary: CircleAvatar(
                      backgroundColor: Colors.lightGreen[300],
                      child: Text("НН"),
                    ),
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value;
                      });
                    },
                    title: Text("Не важное\nНе срочное"),
                  ),
                  Divider(),
                ],
              )
            ],
          ),
        ));
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      var note = NoteTask(task, priority);
      var dbHelper = DBHelper();

      editMode ? dbHelper.updateNote(note, oldTask) : dbHelper.saveNote(note);

      Navigator.pop(context);
    }
  }
}