import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class SearchProvider extends ChangeNotifier {
  String _query = '';
  List<Track> _trackResults = [];
  List<Album> _albumResults = [];
  List<Artist> _artistResults = [];
  List<Playlist> _playlistResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  String? _error;

  String get query => _query;
  List<Track> get trackResults => _trackResults;
  List<Album> get albumResults => _albumResults;
  List<Artist> get artistResults => _artistResults;
  List<Playlist> get playlistResults => _playlistResults;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResults => _trackResults.isNotEmpty || _albumResults.isNotEmpty || 
                        _artistResults.isNotEmpty || _playlistResults.isNotEmpty;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clearResults();
      return;
    }

    _query = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock search results
      _trackResults = _generateMockTracks(query);
      _albumResults = _generateMockAlbums(query);
      _artistResults = _generateMockArtists(query);
      _playlistResults = _generateMockPlaylists(query);
      
      // Add to search history
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      }
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _query = '';
    _trackResults.clear();
    _albumResults.clear();
    _artistResults.clear();
    _playlistResults.clear();
    notifyListeners();
  }

  void clearHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  List<Track> _generateMockTracks(String query) {
    return [
      Track(
        id: '1',
        title: 'Mock Track - $query',
        artist: 'Mock Artist',
        album: 'Mock Album',
        albumArt: 'https://via.placeholder.com/300',
        duration: const Duration(minutes: 3, seconds: 30),
        audioUrl: 'https://example.com/track.mp3',
      ),
    ];
  }

  List<Album> _generateMockAlbums(String query) {
    return [
      Album(
        id: '1',
        title: 'Mock Album - $query',
        artistId: 'artist1',
        artistName: 'Mock Artist',
        coverImage: 'https://via.placeholder.com/300',
        type: AlbumType.album,
        releaseDate: DateTime.now(),
        tracks: [],
        totalDuration: const Duration(minutes: 45),
        totalTracks: 12,
      ),
    ];
  }

  List<Artist> _generateMockArtists(String query) {
    return [
      Artist(
        id: '1',
        name: 'Mock Artist - $query',
        profileImage: 'https://via.placeholder.com/300',
        followerCount: 1000000,
        monthlyListeners: 5000000,
      ),
    ];
  }

  List<Playlist> _generateMockPlaylists(String query) {
    return [
      Playlist(
        id: '1',
        name: 'Mock Playlist - $query',
        description: 'A mock playlist for testing',
        coverImage: 'https://via.placeholder.com/300',
        creatorId: 'user1',
        creatorName: 'Mock User',
        tracks: [],
        type: PlaylistType.userCreated,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalDuration: const Duration(hours: 2),
      ),
    ];
  }
}