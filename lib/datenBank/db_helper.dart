
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper{

  static Future<sql.Database> database() async{

final dbPath = await sql.getDatabasesPath();

return  sql.openDatabase(path.join(dbPath,'user_places.db' ), onCreate: (db, version){

return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, describtion TEXT)');

}, version:1 );
  }

  static Future<void> insert(String table, Map<String, Object>data )async {

final db= await DBHelper.database();


db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

  }
static Future<List<Map<String ,dynamic>>> getData(String table) async{
  final db = await DBHelper.database();

return db.query(table);
}

static Future <void> deletePlaces(String id) async {
  // Get areference to the database.
  final db = await DBHelper.database();

  final int results= await db.delete('user_places', where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id], );
return results;
}
}