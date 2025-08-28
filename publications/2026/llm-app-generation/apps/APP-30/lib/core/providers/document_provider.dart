import 'package:flutter/foundation.dart';
import '../../shared/models/document.dart';
import '../../shared/models/template.dart';
import '../../shared/services/document_service.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentService _documentService = DocumentService.instance;
  
  List<Document> _documents = [];
  List<DocumentTemplate> _templates = [];
  Document? _currentDocument;
  bool _isLoading = false;
  String _searchQuery = '';
  List<Document> _searchResults = [];

  // Getters
  List<Document> get documents => _documents;
  List<DocumentTemplate> get templates => _templates;
  Document? get currentDocument => _currentDocument;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  List<Document> get searchResults => _searchResults;

  // Filtered documents
  List<Document> get recentDocuments {
    final sortedDocs = List<Document>.from(_documents);
    sortedDocs.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return sortedDocs.take(10).toList();
  }

  List<Document> get offlineDocuments {
    return _documents.where((doc) => doc.isOfflineAvailable).toList();
  }

  List<Document> get sharedDocuments {
    return _documents.where((doc) => doc.isShared).toList();
  }

  // Initialize provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _documentService.initialize();
      await loadDocuments();
      await loadTemplates();
    } catch (e) {
      debugPrint('Error initializing DocumentProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Document operations
  Future<void> loadDocuments() async {
    try {
      _documents = await _documentService.getAllDocuments();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading documents: $e');
    }
  }

  Future<String> createDocument({
    required String title,
    String content = '',
    String templateId = '',
  }) async {
    _setLoading(true);
    try {
      final documentId = await _documentService.createDocument(
        title: title,
        content: content,
        ownerId: 'current_user', // TODO: Replace with actual user ID
        templateId: templateId,
      );
      
      await loadDocuments();
      return documentId;
    } catch (e) {
      debugPrint('Error creating document: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateDocument(Document document) async {
    try {
      await _documentService.updateDocument(document);
      
      // Update local list
      final index = _documents.indexWhere((doc) => doc.id == document.id);
      if (index != -1) {
        _documents[index] = document;
        notifyListeners();
      }
      
      // Update current document if it's the same
      if (_currentDocument?.id == document.id) {
        _currentDocument = document;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating document: $e');
    }
  }

  Future<void> deleteDocument(String documentId) async {
    _setLoading(true);
    try {
      await _documentService.deleteDocument(documentId);
      _documents.removeWhere((doc) => doc.id == documentId);
      
      if (_currentDocument?.id == documentId) {
        _currentDocument = null;
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting document: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setCurrentDocument(String documentId) async {
    try {
      _currentDocument = await _documentService.getDocumentById(documentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting current document: $e');
    }
  }

  void clearCurrentDocument() {
    _currentDocument = null;
    notifyListeners();
  }

  // Auto-save functionality
  Future<void> autoSaveCurrentDocument() async {
    if (_currentDocument != null) {
      try {
        await _documentService.autoSaveDocument(_currentDocument!);
      } catch (e) {
        debugPrint('Error auto-saving document: $e');
      }
    }
  }

  // Search functionality
  Future<void> searchDocuments(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      try {
        _searchResults = await _documentService.searchDocuments(query);
      } catch (e) {
        debugPrint('Error searching documents: $e');
        _searchResults = [];
      }
    }
    
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  // Template operations
  Future<void> loadTemplates() async {
    try {
      _templates = await _documentService.getAllTemplates();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading templates: $e');
    }
  }

  Future<List<DocumentTemplate>> getTemplatesByCategory(String category) async {
    try {
      return await _documentService.getTemplatesByCategory(category);
    } catch (e) {
      debugPrint('Error getting templates by category: $e');
      return [];
    }
  }

  Future<Document> createDocumentFromTemplate(String templateId) async {
    try {
      final template = await _documentService.getTemplateById(templateId);
      if (template != null) {
        final documentId = await createDocument(
          title: 'Untitled ${template.name}',
          content: template.content,
          templateId: templateId,
        );
        
        final document = await _documentService.getDocumentById(documentId);
        return document!;
      } else {
        throw Exception('Template not found');
      }
    } catch (e) {
      debugPrint('Error creating document from template: $e');
      rethrow;
    }
  }

  // Offline operations
  Future<void> makeDocumentOfflineAvailable(String documentId) async {
    try {
      await _documentService.makeDocumentOfflineAvailable(documentId);
      await loadDocuments();
    } catch (e) {
      debugPrint('Error making document offline available: $e');
    }
  }

  Future<void> removeDocumentFromOffline(String documentId) async {
    try {
      await _documentService.removeDocumentFromOffline(documentId);
      await loadDocuments();
    } catch (e) {
      debugPrint('Error removing document from offline: $e');
    }
  }

  // Export operations
  Future<String> exportDocumentAsText(String documentId) async {
    try {
      return await _documentService.exportDocumentAsText(documentId);
    } catch (e) {
      debugPrint('Error exporting document as text: $e');
      return '';
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Document? getDocumentById(String id) {
    try {
      return _documents.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  // Collaboration helpers (for future implementation)
  Future<void> shareDocument(String documentId, List<String> emails, String permission) async {
    // TODO: Implement sharing functionality
    debugPrint('Sharing document $documentId with $emails as $permission');
  }

  Future<void> addComment(String documentId, String comment, int position) async {
    // TODO: Implement comment functionality
    debugPrint('Adding comment to document $documentId at position $position: $comment');
  }

  // Document statistics
  int get totalDocuments => _documents.length;
  int get totalOfflineDocuments => offlineDocuments.length;
  int get totalSharedDocuments => sharedDocuments.length;
  
  Map<String, int> get documentsByStatus {
    final statusCount = <String, int>{};
    for (final doc in _documents) {
      statusCount[doc.status] = (statusCount[doc.status] ?? 0) + 1;
    }
    return statusCount;
  }
}