import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/document.dart';
import '../models/template.dart';
import '../../core/constants/app_constants.dart';

class DocumentService {
  static DocumentService? _instance;
  static DocumentService get instance => _instance ??= DocumentService._();
  DocumentService._();

  Database? _database;
  SharedPreferences? _prefs;

  // Initialize the service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _database = await _initDatabase();
  }

  // Initialize SQLite database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'google_docs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Documents table
        await db.execute('''
          CREATE TABLE documents (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            created_at TEXT NOT NULL,
            last_modified TEXT NOT NULL,
            owner_id TEXT NOT NULL,
            status TEXT NOT NULL,
            collaborators TEXT NOT NULL,
            versions TEXT NOT NULL,
            is_offline_available INTEGER NOT NULL,
            template_id TEXT NOT NULL,
            metadata TEXT NOT NULL
          )
        ''');

        // Templates table
        await db.execute('''
          CREATE TABLE templates (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            content TEXT NOT NULL,
            thumbnail_url TEXT NOT NULL,
            created_at TEXT NOT NULL,
            is_built_in INTEGER NOT NULL,
            metadata TEXT NOT NULL
          )
        ''');

        // Insert built-in templates
        final builtInTemplates = DocumentTemplate.getBuiltInTemplates();
        for (final template in builtInTemplates) {
          await db.insert('templates', _templateToMap(template));
        }
      },
    );
  }

  // Document CRUD operations
  Future<List<Document>> getAllDocuments() async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      orderBy: 'last_modified DESC',
    );

    return List.generate(maps.length, (i) => _mapToDocument(maps[i]));
  }

  Future<Document?> getDocumentById(String id) async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToDocument(maps.first);
    }
    return null;
  }

  Future<String> createDocument({
    required String title,
    required String content,
    required String ownerId,
    String templateId = '',
  }) async {
    final document = Document(
      title: title,
      content: content,
      ownerId: ownerId,
      templateId: templateId,
    );

    final db = _database!;
    await db.insert('documents', _documentToMap(document));
    
    return document.id;
  }

  Future<void> updateDocument(Document document) async {
    final updatedDocument = document.copyWith(
      lastModified: DateTime.now(),
    );

    final db = _database!;
    await db.update(
      'documents',
      _documentToMap(updatedDocument),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }

  Future<void> deleteDocument(String id) async {
    final db = _database!;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Document>> searchDocuments(String query) async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'last_modified DESC',
    );

    return List.generate(maps.length, (i) => _mapToDocument(maps[i]));
  }

  // Template operations
  Future<List<DocumentTemplate>> getAllTemplates() async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'templates',
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) => _mapToTemplate(maps[i]));
  }

  Future<List<DocumentTemplate>> getTemplatesByCategory(String category) async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'templates',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) => _mapToTemplate(maps[i]));
  }

  Future<DocumentTemplate?> getTemplateById(String id) async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'templates',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToTemplate(maps.first);
    }
    return null;
  }

  // Offline operations
  Future<void> makeDocumentOfflineAvailable(String documentId) async {
    final document = await getDocumentById(documentId);
    if (document != null) {
      final updatedDocument = document.copyWith(isOfflineAvailable: true);
      await updateDocument(updatedDocument);
    }
  }

  Future<void> removeDocumentFromOffline(String documentId) async {
    final document = await getDocumentById(documentId);
    if (document != null) {
      final updatedDocument = document.copyWith(isOfflineAvailable: false);
      await updateDocument(updatedDocument);
    }
  }

  Future<List<Document>> getOfflineDocuments() async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'is_offline_available = ?',
      whereArgs: [1],
      orderBy: 'last_modified DESC',
    );

    return List.generate(maps.length, (i) => _mapToDocument(maps[i]));
  }

  // Auto-save functionality
  Future<void> autoSaveDocument(Document document) async {
    // Check if enough time has passed since last save
    final lastSave = _prefs?.getInt('last_save_${document.id}') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    if (now - lastSave > AppConstants.autoSaveInterval * 1000) {
      await updateDocument(document);
      await _prefs?.setInt('last_save_${document.id}', now);
    }
  }

  // Export operations
  Future<String> exportDocumentAsText(String documentId) async {
    final document = await getDocumentById(documentId);
    if (document != null) {
      return document.plainTextContent;
    }
    return '';
  }

  // Helper methods
  Map<String, dynamic> _documentToMap(Document document) {
    return {
      'id': document.id,
      'title': document.title,
      'content': document.content,
      'created_at': document.createdAt.toIso8601String(),
      'last_modified': document.lastModified.toIso8601String(),
      'owner_id': document.ownerId,
      'status': document.status,
      'collaborators': jsonEncode(document.collaborators),
      'versions': jsonEncode(document.versions.map((v) => v.toJson()).toList()),
      'is_offline_available': document.isOfflineAvailable ? 1 : 0,
      'template_id': document.templateId,
      'metadata': jsonEncode(document.metadata),
    };
  }

  Document _mapToDocument(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      lastModified: DateTime.parse(map['last_modified']),
      ownerId: map['owner_id'],
      status: map['status'],
      collaborators: List<String>.from(jsonDecode(map['collaborators'])),
      versions: (jsonDecode(map['versions']) as List)
          .map((v) => DocumentVersion.fromJson(v))
          .toList(),
      isOfflineAvailable: map['is_offline_available'] == 1,
      templateId: map['template_id'],
      metadata: Map<String, dynamic>.from(jsonDecode(map['metadata'])),
    );
  }

  Map<String, dynamic> _templateToMap(DocumentTemplate template) {
    return {
      'id': template.id,
      'name': template.name,
      'description': template.description,
      'category': template.category,
      'content': template.content,
      'thumbnail_url': template.thumbnailUrl,
      'created_at': template.createdAt.toIso8601String(),
      'is_built_in': template.isBuiltIn ? 1 : 0,
      'metadata': jsonEncode(template.metadata),
    };
  }

  DocumentTemplate _mapToTemplate(Map<String, dynamic> map) {
    return DocumentTemplate(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      content: map['content'],
      thumbnailUrl: map['thumbnail_url'],
      createdAt: DateTime.parse(map['created_at']),
      isBuiltIn: map['is_built_in'] == 1,
      metadata: Map<String, dynamic>.from(jsonDecode(map['metadata'])),
    );
  }
}