import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  ///Singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  static final String TABLE_NOTE = "note";
  static final String TABLE_COLUMN_SNO = "s_no";
  static final String COLUMN_TITLE = "name";
  static final String COLUMN_DESCRIPTION = "description";

  Database? myDB;
  /// db Open (path --> if exist then open else create db)

  Future<Database> getDB() async{

    // if(myDB != null){
    //   return myDB!;
    // }else
    //   {
    //    myDB = await openDB();
    //    return myDB!;
    //   }
    //  or
    // myDB = myDB != null ? myDB : await openDB();
    // return myDB!;
    // or 
    // myDB = myDB ?? await openDB(); return myDB;
    // or
    myDB ??= await openDB();
    return myDB!;

  }

  Future<Database> openDB() async{

    Directory appDir = await getApplicationDocumentsDirectory();
    
    String dbPath = join(appDir.path,"note.db");
     // await deleteDatabase(join(appDir.path, "note.db"));



    return await openDatabase(dbPath, onCreate: (db, version) {

      ///create  all your tables here
        db.execute('''
  CREATE TABLE $TABLE_NOTE (
    $TABLE_COLUMN_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
    $COLUMN_TITLE TEXT,
    $COLUMN_DESCRIPTION TEXT
  )
''');

    }, version: 1);
  }
  ///insertion
  Future<bool> addNote({required String mtitle , required String mDesc}) async{

    var db = await getDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_TITLE : mtitle,
      COLUMN_DESCRIPTION : mDesc

    });

    return rowsEffected>0;

  }
  /// reading all data 
  Future<List<Map<String, dynamic>>> getAllNotes() async {

    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);

    return mData;
  }
  /// Update Notes
  Future<bool> updateNote({required String mtitle , required String mDesc ,required int sno}) async{
    
    var db = await getDB();
    
     int rowsEffected =  await db.update(TABLE_NOTE, {
      COLUMN_TITLE : mtitle,
      COLUMN_DESCRIPTION : mDesc

    }, where: "$TABLE_COLUMN_SNO = $sno"      );
     return rowsEffected>0;
    
}
  /// delete note
  Future<bool> deleteNote({required int sno}) async{
    
    var db = await getDB();
    
    int rowsEffected = await db.delete(TABLE_NOTE,where: "$TABLE_COLUMN_SNO = $sno");

    return rowsEffected>0;
    
  }

}
