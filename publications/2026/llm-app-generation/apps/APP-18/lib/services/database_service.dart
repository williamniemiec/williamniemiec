import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pin.dart';
import '../models/board.dart';
import '../models/user.dart';
import '../models/comment.dart';
import '../models/message.dart';
import '../models/search.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'pinterest_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _usersTable = 'users';
  static const String _pinsTable = 'pins';
  static const String _boardsTable = 'boards';
  static const String _commentsTable = 'comments';
  static const String _messagesTable = 'messages';
  static const String _conversationsTable = 'conversations';
  static const String _searchHistoryTable = 'search_history';
  static const String _cachedPinsTable = 'cached_pins';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE $_usersTable (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        displayName TEXT NOT NULL,
        email TEXT NOT NULL,
        profileImageUrl TEXT,
        bio TEXT,
        website TEXT,
        followersCount INTEGER DEFAULT 0,
        followingCount INTEGER DEFAULT 0,
        pinsCount INTEGER DEFAULT 0,
        boardsCount INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isVerified INTEGER DEFAULT 0,
        isPrivate INTEGER DEFAULT 0
      )
    ''');

    // Pins table
    await db.execute('''
      CREATE TABLE $_pinsTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT NOT NULL,
        videoUrl TEXT,
        type TEXT NOT NULL,
        userId TEXT NOT NULL,
        username TEXT NOT NULL,
        userProfileImageUrl TEXT,
        sourceUrl TEXT,
        sourceDomain TEXT,
        tags TEXT,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL,
        likesCount INTEGER DEFAULT 0,
        commentsCount INTEGER DEFAULT 0,
        savesCount INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isLiked INTEGER DEFAULT 0,
        isSaved INTEGER DEFAULT 0,
        boardId TEXT,
        boardName TEXT,
        price REAL,
        currency TEXT,
        productTitle TEXT,
        inStock INTEGER,
        merchantName TEXT,
        dominantColors TEXT
      )
    ''');

    // Boards table
    await db.execute('''
      CREATE TABLE $_boardsTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        userId TEXT NOT NULL,
        username TEXT NOT NULL,
        userProfileImageUrl TEXT,
        privacy TEXT NOT NULL,
        coverImageUrl TEXT,
        collaboratorIds TEXT,
        pinsCount INTEGER DEFAULT 0,
        followersCount INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isFollowing INTEGER DEFAULT 0,
        tags TEXT,
        category TEXT
      )
    ''');

    // Comments table
    await db.execute('''
      CREATE TABLE $_commentsTable (
        id TEXT PRIMARY KEY,
        pinId TEXT NOT NULL,
        userId TEXT NOT NULL,
        username TEXT NOT NULL,
        userProfileImageUrl TEXT,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        likesCount INTEGER DEFAULT 0,
        isLiked INTEGER DEFAULT 0,
        parentCommentId TEXT,
        replies TEXT
      )
    ''');

    // Messages table
    await db.execute('''
      CREATE TABLE $_messagesTable (
        id TEXT PRIMARY KEY,
        conversationId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        senderUsername TEXT NOT NULL,
        senderProfileImageUrl TEXT,
        receiverId TEXT NOT NULL,
        type TEXT NOT NULL,
        content TEXT,
        pinId TEXT,
        boardId TEXT,
        imageUrl TEXT,
        createdAt TEXT NOT NULL,
        isRead INTEGER DEFAULT 0,
        isDelivered INTEGER DEFAULT 0
      )
    ''');

    // Conversations table
    await db.execute('''
      CREATE TABLE $_conversationsTable (
        id TEXT PRIMARY KEY,
        participantIds TEXT NOT NULL,
        participantUsernames TEXT NOT NULL,
        participantProfileImages TEXT,
        lastMessage TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        unreadCount INTEGER DEFAULT 0
      )
    ''');

    // Search history table
    await db.execute('''
      CREATE TABLE $_searchHistoryTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        UNIQUE(query)
      )
    ''');

    // Cached pins table for offline viewing
    await db.execute('''
      CREATE TABLE $_cachedPinsTable (
        id TEXT PRIMARY KEY,
        pinData TEXT NOT NULL,
        cachedAt TEXT NOT NULL
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_pins_userId ON $_pinsTable(userId)');
    await db.execute('CREATE INDEX idx_pins_boardId ON $_pinsTable(boardId)');
    await db.execute('CREATE INDEX idx_boards_userId ON $_boardsTable(userId)');
    await db.execute('CREATE INDEX idx_comments_pinId ON $_commentsTable(pinId)');
    await db.execute('CREATE INDEX idx_messages_conversationId ON $_messagesTable(conversationId)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  // User operations
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      _usersTable,
      _userToMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      _usersTable,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return _userFromMap(maps.first);
    }
    return null;
  }

  // Pin operations
  Future<void> insertPin(Pin pin) async {
    final db = await database;
    await db.insert(
      _pinsTable,
      _pinToMap(pin),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pin>> getPins({int limit = 20, int offset = 0}) async {
    final db = await database;
    final maps = await db.query(
      _pinsTable,
      orderBy: 'createdAt DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => _pinFromMap(map)).toList();
  }

  Future<List<Pin>> getUserPins(String userId) async {
    final db = await database;
    final maps = await db.query(
      _pinsTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _pinFromMap(map)).toList();
  }

  Future<List<Pin>> getBoardPins(String boardId) async {
    final db = await database;
    final maps = await db.query(
      _pinsTable,
      where: 'boardId = ?',
      whereArgs: [boardId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _pinFromMap(map)).toList();
  }

  Future<void> updatePin(Pin pin) async {
    final db = await database;
    await db.update(
      _pinsTable,
      _pinToMap(pin),
      where: 'id = ?',
      whereArgs: [pin.id],
    );
  }

  Future<void> deletePin(String pinId) async {
    final db = await database;
    await db.delete(
      _pinsTable,
      where: 'id = ?',
      whereArgs: [pinId],
    );
  }

  // Board operations
  Future<void> insertBoard(Board board) async {
    final db = await database;
    await db.insert(
      _boardsTable,
      _boardToMap(board),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Board>> getUserBoards(String userId) async {
    final db = await database;
    final maps = await db.query(
      _boardsTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _boardFromMap(map)).toList();
  }

  Future<Board?> getBoard(String boardId) async {
    final db = await database;
    final maps = await db.query(
      _boardsTable,
      where: 'id = ?',
      whereArgs: [boardId],
    );

    if (maps.isNotEmpty) {
      return _boardFromMap(maps.first);
    }
    return null;
  }

  // Search history operations
  Future<void> addSearchQuery(String query) async {
    final db = await database;
    await db.insert(
      _searchHistoryTable,
      {
        'query': query,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getSearchHistory({int limit = 10}) async {
    final db = await database;
    final maps = await db.query(
      _searchHistoryTable,
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map((map) => map['query'] as String).toList();
  }

  Future<void> clearSearchHistory() async {
    final db = await database;
    await db.delete(_searchHistoryTable);
  }

  // Cache operations
  Future<void> cachePin(Pin pin) async {
    final db = await database;
    await db.insert(
      _cachedPinsTable,
      {
        'id': pin.id,
        'pinData': jsonEncode(pin.toJson()),
        'cachedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Pin?> getCachedPin(String pinId) async {
    final db = await database;
    final maps = await db.query(
      _cachedPinsTable,
      where: 'id = ?',
      whereArgs: [pinId],
    );

    if (maps.isNotEmpty) {
      final pinData = jsonDecode(maps.first['pinData'] as String);
      return Pin.fromJson(pinData);
    }
    return null;
  }

  Future<void> clearCache() async {
    final db = await database;
    await db.delete(_cachedPinsTable);
  }

  // Helper methods to convert between objects and maps
  Map<String, dynamic> _userToMap(User user) {
    return {
      'id': user.id,
      'username': user.username,
      'displayName': user.displayName,
      'email': user.email,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'website': user.website,
      'followersCount': user.followersCount,
      'followingCount': user.followingCount,
      'pinsCount': user.pinsCount,
      'boardsCount': user.boardsCount,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
      'isVerified': user.isVerified ? 1 : 0,
      'isPrivate': user.isPrivate ? 1 : 0,
    };
  }

  User _userFromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      displayName: map['displayName'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
      bio: map['bio'],
      website: map['website'],
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      pinsCount: map['pinsCount'] ?? 0,
      boardsCount: map['boardsCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isVerified: map['isVerified'] == 1,
      isPrivate: map['isPrivate'] == 1,
    );
  }

  Map<String, dynamic> _pinToMap(Pin pin) {
    return {
      'id': pin.id,
      'title': pin.title,
      'description': pin.description,
      'imageUrl': pin.imageUrl,
      'videoUrl': pin.videoUrl,
      'type': pin.type.name,
      'userId': pin.userId,
      'username': pin.username,
      'userProfileImageUrl': pin.userProfileImageUrl,
      'sourceUrl': pin.sourceUrl,
      'sourceDomain': pin.sourceDomain,
      'tags': jsonEncode(pin.tags),
      'width': pin.width,
      'height': pin.height,
      'likesCount': pin.likesCount,
      'commentsCount': pin.commentsCount,
      'savesCount': pin.savesCount,
      'createdAt': pin.createdAt.toIso8601String(),
      'updatedAt': pin.updatedAt.toIso8601String(),
      'isLiked': pin.isLiked ? 1 : 0,
      'isSaved': pin.isSaved ? 1 : 0,
      'boardId': pin.boardId,
      'boardName': pin.boardName,
      'price': pin.price,
      'currency': pin.currency,
      'productTitle': pin.productTitle,
      'inStock': pin.inStock != null ? (pin.inStock! ? 1 : 0) : null,
      'merchantName': pin.merchantName,
      'dominantColors': pin.dominantColors != null ? jsonEncode(pin.dominantColors) : null,
    };
  }

  Pin _pinFromMap(Map<String, dynamic> map) {
    return Pin(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      type: PinType.values.firstWhere((e) => e.name == map['type']),
      userId: map['userId'],
      username: map['username'],
      userProfileImageUrl: map['userProfileImageUrl'],
      sourceUrl: map['sourceUrl'],
      sourceDomain: map['sourceDomain'],
      tags: map['tags'] != null ? List<String>.from(jsonDecode(map['tags'])) : [],
      width: map['width'],
      height: map['height'],
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      savesCount: map['savesCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isLiked: map['isLiked'] == 1,
      isSaved: map['isSaved'] == 1,
      boardId: map['boardId'],
      boardName: map['boardName'],
      price: map['price']?.toDouble(),
      currency: map['currency'],
      productTitle: map['productTitle'],
      inStock: map['inStock'] != null ? map['inStock'] == 1 : null,
      merchantName: map['merchantName'],
      dominantColors: map['dominantColors'] != null 
          ? List<String>.from(jsonDecode(map['dominantColors']))
          : null,
    );
  }

  Map<String, dynamic> _boardToMap(Board board) {
    return {
      'id': board.id,
      'name': board.name,
      'description': board.description,
      'userId': board.userId,
      'username': board.username,
      'userProfileImageUrl': board.userProfileImageUrl,
      'privacy': board.privacy.name,
      'coverImageUrl': board.coverImageUrl,
      'collaboratorIds': jsonEncode(board.collaboratorIds),
      'pinsCount': board.pinsCount,
      'followersCount': board.followersCount,
      'createdAt': board.createdAt.toIso8601String(),
      'updatedAt': board.updatedAt.toIso8601String(),
      'isFollowing': board.isFollowing ? 1 : 0,
      'tags': jsonEncode(board.tags),
      'category': board.category,
    };
  }

  Board _boardFromMap(Map<String, dynamic> map) {
    return Board(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      userId: map['userId'],
      username: map['username'],
      userProfileImageUrl: map['userProfileImageUrl'],
      privacy: BoardPrivacy.values.firstWhere((e) => e.name == map['privacy']),
      coverImageUrl: map['coverImageUrl'],
      collaboratorIds: List<String>.from(jsonDecode(map['collaboratorIds'] ?? '[]')),
      pinsCount: map['pinsCount'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isFollowing: map['isFollowing'] == 1,
      tags: List<String>.from(jsonDecode(map['tags'] ?? '[]')),
      category: map['category'],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}