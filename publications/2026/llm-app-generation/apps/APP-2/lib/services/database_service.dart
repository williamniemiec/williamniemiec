import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/coloring_page.dart';
import '../models/user_progress.dart';
import '../constants/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create coloring_pages table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableColoringPages} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        image_path TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL,
        regions TEXT NOT NULL,
        palette TEXT NOT NULL,
        difficulty INTEGER NOT NULL,
        is_premium INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Create user_progress table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableUserProgress} (
        page_id TEXT PRIMARY KEY,
        colored_regions TEXT NOT NULL,
        progress_percentage REAL NOT NULL,
        last_modified TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create user_artworks table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableUserArtworks} (
        id TEXT PRIMARY KEY,
        page_id TEXT NOT NULL,
        title TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL,
        completed_image_path TEXT NOT NULL,
        completed_at TEXT NOT NULL,
        time_spent_minutes INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // Coloring Pages CRUD
  Future<void> insertColoringPage(ColoringPage page) async {
    final db = await database;
    await db.insert(
      AppConstants.tableColoringPages,
      {
        'id': page.id,
        'title': page.title,
        'category': page.category,
        'image_path': page.imagePath,
        'thumbnail_path': page.thumbnailPath,
        'regions': jsonEncode(page.regions.map((r) => r.toJson()).toList()),
        'palette': jsonEncode(page.palette.map((p) => p.toJson()).toList()),
        'difficulty': page.difficulty,
        'is_premium': page.isPremium ? 1 : 0,
        'created_at': page.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ColoringPage>> getColoringPages({String? category}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    
    if (category != null && category != 'Featured') {
      maps = await db.query(
        AppConstants.tableColoringPages,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'created_at DESC',
      );
    } else {
      maps = await db.query(
        AppConstants.tableColoringPages,
        orderBy: 'created_at DESC',
      );
    }

    return maps.map((map) => _mapToColoringPage(map)).toList();
  }

  Future<ColoringPage?> getColoringPageById(String id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableColoringPages,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return _mapToColoringPage(maps.first);
    }
    return null;
  }

  ColoringPage _mapToColoringPage(Map<String, dynamic> map) {
    final regionsJson = jsonDecode(map['regions']) as List;
    final paletteJson = jsonDecode(map['palette']) as List;

    return ColoringPage(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      imagePath: map['image_path'],
      thumbnailPath: map['thumbnail_path'],
      regions: regionsJson.map((r) => ColorRegion.fromJson(r)).toList(),
      palette: paletteJson.map((p) => ColorPalette.fromJson(p)).toList(),
      difficulty: map['difficulty'],
      isPremium: map['is_premium'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // User Progress CRUD
  Future<void> saveUserProgress(UserProgress progress) async {
    final db = await database;
    await db.insert(
      AppConstants.tableUserProgress,
      {
        'page_id': progress.pageId,
        'colored_regions': jsonEncode(progress.coloredRegions),
        'progress_percentage': progress.progressPercentage,
        'last_modified': progress.lastModified.toIso8601String(),
        'is_completed': progress.isCompleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProgress?> getUserProgress(String pageId) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUserProgress,
      where: 'page_id = ?',
      whereArgs: [pageId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      final coloredRegionsJson = jsonDecode(map['colored_regions'] as String) as Map<String, dynamic>;
      final coloredRegions = coloredRegionsJson.map(
        (key, value) => MapEntry(int.parse(key), value as bool),
      );

      return UserProgress(
        pageId: map['page_id'] as String,
        coloredRegions: coloredRegions,
        progressPercentage: map['progress_percentage'] as double,
        lastModified: DateTime.parse(map['last_modified'] as String),
        isCompleted: map['is_completed'] == 1,
      );
    }
    return null;
  }

  Future<List<UserProgress>> getAllUserProgress() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUserProgress,
      orderBy: 'last_modified DESC',
    );

    return maps.map((map) {
      final coloredRegionsJson = jsonDecode(map['colored_regions'] as String) as Map<String, dynamic>;
      final coloredRegions = coloredRegionsJson.map(
        (key, value) => MapEntry(int.parse(key), value as bool),
      );

      return UserProgress(
        pageId: map['page_id'] as String,
        coloredRegions: coloredRegions,
        progressPercentage: map['progress_percentage'] as double,
        lastModified: DateTime.parse(map['last_modified'] as String),
        isCompleted: map['is_completed'] == 1,
      );
    }).toList();
  }

  // User Artworks CRUD
  Future<void> saveUserArtwork(UserArtwork artwork) async {
    final db = await database;
    await db.insert(
      AppConstants.tableUserArtworks,
      {
        'id': artwork.id,
        'page_id': artwork.pageId,
        'title': artwork.title,
        'thumbnail_path': artwork.thumbnailPath,
        'completed_image_path': artwork.completedImagePath,
        'completed_at': artwork.completedAt.toIso8601String(),
        'time_spent_minutes': artwork.timeSpentMinutes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserArtwork>> getUserArtworks() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUserArtworks,
      orderBy: 'completed_at DESC',
    );

    return maps.map((map) => UserArtwork(
      id: map['id'] as String,
      pageId: map['page_id'] as String,
      title: map['title'] as String,
      thumbnailPath: map['thumbnail_path'] as String,
      completedImagePath: map['completed_image_path'] as String,
      completedAt: DateTime.parse(map['completed_at'] as String),
      timeSpentMinutes: map['time_spent_minutes'] as int,
    )).toList();
  }

  Future<void> deleteUserProgress(String pageId) async {
    final db = await database;
    await db.delete(
      AppConstants.tableUserProgress,
      where: 'page_id = ?',
      whereArgs: [pageId],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}