import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/documents/screens/documents_screen.dart';
import '../../features/editor/screens/editor_screen.dart';
import '../../features/templates/screens/templates_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/sharing/screens/sharing_screen.dart';

class AppRouter {
  static const String documents = '/';
  static const String editor = '/editor';
  static const String templates = '/templates';
  static const String search = '/search';
  static const String sharing = '/sharing';

  static final GoRouter router = GoRouter(
    initialLocation: documents,
    routes: [
      // Main documents screen
      GoRoute(
        path: documents,
        name: 'documents',
        builder: (context, state) => const DocumentsScreen(),
      ),
      
      // Document editor screen
      GoRoute(
        path: editor,
        name: 'editor',
        builder: (context, state) {
          final documentId = state.uri.queryParameters['id'];
          final templateId = state.uri.queryParameters['templateId'];
          return EditorScreen(
            documentId: documentId,
            templateId: templateId,
          );
        },
      ),
      
      // Templates screen
      GoRoute(
        path: templates,
        name: 'templates',
        builder: (context, state) => const TemplatesScreen(),
      ),
      
      // Search screen
      GoRoute(
        path: search,
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return SearchScreen(initialQuery: query);
        },
      ),
      
      // Sharing screen
      GoRoute(
        path: sharing,
        name: 'sharing',
        builder: (context, state) {
          final documentId = state.uri.queryParameters['documentId'];
          if (documentId == null) {
            return const Scaffold(
              body: Center(
                child: Text('Document ID is required'),
              ),
            );
          }
          return SharingScreen(documentId: documentId);
        },
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(documents),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  // Navigation helper methods
  static void goToDocuments(BuildContext context) {
    context.go(documents);
  }

  static void goToEditor(BuildContext context, {String? documentId, String? templateId}) {
    final params = <String, String>{};
    if (documentId != null) params['id'] = documentId;
    if (templateId != null) params['templateId'] = templateId;
    
    final uri = Uri(path: editor, queryParameters: params.isEmpty ? null : params);
    context.go(uri.toString());
  }

  static void goToTemplates(BuildContext context) {
    context.go(templates);
  }

  static void goToSearch(BuildContext context, {String? query}) {
    final params = query != null ? {'q': query} : <String, String>{};
    final uri = Uri(path: search, queryParameters: params.isEmpty ? null : params);
    context.go(uri.toString());
  }

  static void goToSharing(BuildContext context, String documentId) {
    final uri = Uri(path: sharing, queryParameters: {'documentId': documentId});
    context.go(uri.toString());
  }

  // Push methods for modal navigation
  static Future<T?> pushEditor<T>(BuildContext context, {String? documentId, String? templateId}) {
    final params = <String, String>{};
    if (documentId != null) params['id'] = documentId;
    if (templateId != null) params['templateId'] = templateId;
    
    final uri = Uri(path: editor, queryParameters: params.isEmpty ? null : params);
    return context.push<T>(uri.toString());
  }

  static Future<T?> pushTemplates<T>(BuildContext context) {
    return context.push<T>(templates);
  }

  static Future<T?> pushSearch<T>(BuildContext context, {String? query}) {
    final params = query != null ? {'q': query} : <String, String>{};
    final uri = Uri(path: search, queryParameters: params.isEmpty ? null : params);
    return context.push<T>(uri.toString());
  }

  static Future<T?> pushSharing<T>(BuildContext context, String documentId) {
    final uri = Uri(path: sharing, queryParameters: {'documentId': documentId});
    return context.push<T>(uri.toString());
  }
}