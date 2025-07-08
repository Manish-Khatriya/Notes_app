/*
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {

  DBConnection._();

  static final DBConnection  getInstance = DBConnection._();

  Database? myDB;

  static final String TABLE_NOTE = "note";
  static final String TABLE_COLUMN_SNO = "sno";
  static final String COLUMN_TITLE = "title";
  static final String COLUMN_DESCRIPTION = "description";

  Future<Database> getDb() async{

    if(myDB != null){
      return myDB!;
    }else{
      myDB = await openDb();
      return myDB!;
    }
  }

  Future<Database> openDb() async{

    Directory appdir = await getApplicationDocumentsDirectory();

    String dbPath = join(appdir.path,"note.db");

    return openDatabase(dbPath,onCreate: (db , version){

      db.execute("""create table $TABLE_NOTE(
      
      $TABLE_COLUMN_SNO integer primary key autoincrement,
      $COLUMN_TITLE text ,
      $COLUMN_DESCRIPTION text
      )
      """);
    },version: 1);

  }
  /// insertion
  Future<bool> addNote({required String mtitle,required String mdesc}) async{

    var db = await getDb();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_TITLE : mtitle,
      COLUMN_DESCRIPTION : mdesc
    });

    return rowsEffected>0;
  }


  /// read all Notes
  Future<List<Map<String,dynamic>>> getallNotes() async{

    var db = await getDb();

    List<Map<String ,dynamic>> mdata = await db.query(TABLE_NOTE);

    return mdata;
  }

  /// update Notes
  Future<bool> updateNote({required String mtitle , required String mdesc, required int sno}) async{

    var db = await getDb();

    int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_TITLE : mtitle,
      COLUMN_DESCRIPTION : mdesc
    },where:"$TABLE_COLUMN_SNO = $sno");
    return rowsEffected>0;
  }

  /// Delete Notes
   Future<bool> deleteNote({required int sno}) async{

    var db = await getDb();

    int rowsEffected = await db.delete(TABLE_NOTE,where: "$TABLE_COLUMN_SNO = $sno");

    return rowsEffected>0;

  }

}*/
