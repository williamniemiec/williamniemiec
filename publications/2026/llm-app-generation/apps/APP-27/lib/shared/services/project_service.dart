import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/video_project.dart';

class ProjectService {
  static final ProjectService _instance = ProjectService._internal();
  factory ProjectService() => _instance;
  ProjectService._internal();

  Database? _database;
  static const String _tableName = 'projects';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/capcut_projects.db';
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        thumbnail_path TEXT,
        duration INTEGER NOT NULL,
        project_data TEXT NOT NULL
      )
    ''');
  }

  /// Save a video project
  Future<void> saveProject(VideoProject project) async {
    final db = await database;
    
    await db.insert(
      _tableName,
      {
        'id': project.id,
        'name': project.name,
        'created_at': project.createdAt.toIso8601String(),
        'updated_at': project.updatedAt.toIso8601String(),
        'thumbnail_path': project.thumbnailPath,
        'duration': project.duration.inMilliseconds,
        'project_data': jsonEncode(project.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all projects
  Future<List<VideoProject>> getAllProjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) {
      final projectData = jsonDecode(map['project_data']);
      return VideoProject.fromJson(projectData);
    }).toList();
  }

  /// Get project by ID
  Future<VideoProject?> getProject(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final projectData = jsonDecode(maps.first['project_data']);
      return VideoProject.fromJson(projectData);
    }
    return null;
  }

  /// Update project
  Future<void> updateProject(VideoProject project) async {
    final updatedProject = project.copyWith(updatedAt: DateTime.now());
    await saveProject(updatedProject);
  }

  /// Delete project
  Future<void> deleteProject(String id) async {
    final db = await database;
    
    // Get project to clean up files
    final project = await getProject(id);
    if (project != null) {
      await _cleanupProjectFiles(project);
    }
    
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Duplicate project
  Future<VideoProject> duplicateProject(String id) async {
    final originalProject = await getProject(id);
    if (originalProject == null) {
      throw Exception('Project not found');
    }

    final duplicatedProject = VideoProject.create(
      name: '${originalProject.name} (Copy)',
      settings: originalProject.settings,
    ).copyWith(
      clips: originalProject.clips,
      audioTracks: originalProject.audioTracks,
      textOverlays: originalProject.textOverlays,
      effects: originalProject.effects,
      duration: originalProject.duration,
    );

    await saveProject(duplicatedProject);
    return duplicatedProject;
  }

  /// Get projects by name search
  Future<List<VideoProject>> searchProjects(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) {
      final projectData = jsonDecode(map['project_data']);
      return VideoProject.fromJson(projectData);
    }).toList();
  }

  /// Get recent projects
  Future<List<VideoProject>> getRecentProjects({int limit = 10}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'updated_at DESC',
      limit: limit,
    );

    return maps.map((map) {
      final projectData = jsonDecode(map['project_data']);
      return VideoProject.fromJson(projectData);
    }).toList();
  }

  /// Export project data to file
  Future<String> exportProjectData(String projectId) async {
    final project = await getProject(projectId);
    if (project == null) {
      throw Exception('Project not found');
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${documentsDirectory.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final exportFile = File('${exportDir.path}/${project.name}_${DateTime.now().millisecondsSinceEpoch}.json');
    await exportFile.writeAsString(jsonEncode(project.toJson()));
    
    return exportFile.path;
  }

  /// Import project data from file
  Future<VideoProject> importProjectData(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Import file not found');
    }

    final jsonString = await file.readAsString();
    final projectData = jsonDecode(jsonString);
    final project = VideoProject.fromJson(projectData);

    // Generate new ID to avoid conflicts
    final importedProject = VideoProject.create(
      name: '${project.name} (Imported)',
      settings: project.settings,
    ).copyWith(
      clips: project.clips,
      audioTracks: project.audioTracks,
      textOverlays: project.textOverlays,
      effects: project.effects,
      duration: project.duration,
    );

    await saveProject(importedProject);
    return importedProject;
  }

  /// Get project statistics
  Future<ProjectStatistics> getProjectStatistics() async {
    final db = await database;
    
    final totalCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    final totalCount = totalCountResult.first['count'] as int;
    
    final totalDurationResult = await db.rawQuery('SELECT SUM(duration) as total_duration FROM $_tableName');
    final totalDurationMs = totalDurationResult.first['total_duration'] as int? ?? 0;
    
    final recentProjects = await getRecentProjects(limit: 5);
    
    return ProjectStatistics(
      totalProjects: totalCount,
      totalDuration: Duration(milliseconds: totalDurationMs),
      recentProjects: recentProjects,
    );
  }

  /// Clean up project files
  Future<void> _cleanupProjectFiles(VideoProject project) async {
    try {
      // Clean up thumbnail
      if (project.thumbnailPath != null) {
        final thumbnailFile = File(project.thumbnailPath!);
        if (await thumbnailFile.exists()) {
          await thumbnailFile.delete();
        }
      }

      // Note: We don't delete original video files as they might be used elsewhere
      // Only delete generated/processed files specific to this project
      
    } catch (e) {
      print('Error cleaning up project files: $e');
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

class ProjectStatistics {
  final int totalProjects;
  final Duration totalDuration;
  final List<VideoProject> recentProjects;

  const ProjectStatistics({
    required this.totalProjects,
    required this.totalDuration,
    required this.recentProjects,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalProjects': totalProjects,
      'totalDuration': totalDuration.inMilliseconds,
      'recentProjects': recentProjects.map((p) => p.toJson()).toList(),
    };
  }

  factory ProjectStatistics.fromJson(Map<String, dynamic> json) {
    return ProjectStatistics(
      totalProjects: json['totalProjects'],
      totalDuration: Duration(milliseconds: json['totalDuration']),
      recentProjects: (json['recentProjects'] as List)
          .map((p) => VideoProject.fromJson(p))
          .toList(),
    );
  }
}