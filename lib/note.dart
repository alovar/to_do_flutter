import 'package:flutter/material.dart';
import 'package:to_do_flutter/database/tasks_data_base.dart';

class Note extends StatelessWidget {
  final String task;
  final int priority;

  Note({this.task, this.priority});

  @override
  Widget build(BuildContext context) {

    Widget deleteDialog = AlertDialog(
      title: Text("Удаление"),
      content: Text(
          "Вы уверены что хотите удалить эту задачу?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              var dbHelper = DBHelper();
              dbHelper.deleteNote(task);
              Navigator.pop(context);
            },
            child: Text("УДАЛИТЬ")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("ОТМЕНА")),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(textPriority(priority)),
        centerTitle: true,
        backgroundColor: getColor(),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  child: GestureDetector(
                    child: Text("Изменить"),
                    onTap: () {
                      Navigator.popAndPushNamed(
                          context, '/newNote/$task/$priority/true');
                    },
                  ),
                ),
                PopupMenuItem(
                  child: GestureDetector(
                    child: Text("Удалить"),
                    onTap: () {
                      showDialog(
                          context: ctx,
                          builder: (ctx) {
                            return deleteDialog;
                          });
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("$task"),
          ),
        ],
      ),
    );
  }

  String textPriority(int priority) {
    switch (priority) {
      case 0:
        return "Важно и Срочно";
      case 1:
        return "Не важно и Срочно";
      case 2:
        return "Важно и Не срочно";
      case 3:
        return "Не важно и Не срочно";
      default:
        return "  ";
    }
  }

  Color getColor() {
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
        return Colors.grey;
    }
  }
}
