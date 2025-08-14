import 'package:apex_altimeter/models/session.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sessions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE sessions ( 
  id $idType, 
  name $textType,
  startTime $textType,
  endTime $textType,
  totalDistance $doubleType,
  totalAscent $doubleType,
  totalDescent $doubleType,
  maxAltitude $doubleType
  )
''');
  }

  Future<Session> create(Session session) async {
    final db = await instance.database;
    final id = await db.insert('sessions', session.toMap());
    return session..id = id;
  }

  Future<Session> readSession(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'sessions',
      columns: [
        'id',
        'name',
        'startTime',
        'endTime',
        'totalDistance',
        'totalAscent',
        'totalDescent',
        'maxAltitude'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Session.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Session>> readAllSessions() async {
    final db = await instance.database;
    const orderBy = 'startTime DESC';
    final result = await db.query('sessions', orderBy: orderBy);
    return result.map((json) => Session.fromMap(json)).toList();
  }

  Future<int> update(Session session) async {
    final db = await instance.database;
    return db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}