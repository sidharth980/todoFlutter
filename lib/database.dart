import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class createDataBase {
  Future <Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(),'todo.db'),
      onCreate: (db,version){
        return db.execute(
          'CREATE TABLE todoTask(id INTEGER PRIMARY KEY, task TEXT, checker INTEGER)'
        );
      },
        version: 1
    );
  }

  Future <void> insertTask(todo task) async {
    Database db = await database();
    await db.insert('todoTask', task.toMap(),conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<todo>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('todoTask');
    return List.generate(taskMap.length, (index) {
      return todo(id: taskMap[index]['id'], task: taskMap[index]['task'], checker: taskMap[index]['checker']);
    });
  }

  Future<void> updatetodo(todo task) async {
    Database db = await database();
    await db.update('todoTask', task.toMap(),where: 'id = ?',whereArgs: [task.id]);
  }

  Future<void> deletetodo(todo task) async {
    Database db = await database();
    await db.delete('todoTask', where: 'id = ?',whereArgs: [task.id]);
  }
}

class todo {
  final int id;
  final String task;
  final int checker;

  todo({
    this.id,
    this.task,
    this.checker,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'checker': checker,
    };
  }
}