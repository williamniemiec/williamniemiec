import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class HomeProvider extends ChangeNotifier {
  List<Playlist> _recentlyPlayed = [];
  List<Playlist> _madeForYou = [];
  List<Track> _newReleases = [];
  List<Album> _featuredAlbums = [];
  bool _isLoading = false;
  String? _error;

  List<Playlist> get recentlyPlayed => _recentlyPlayed;
  List<Playlist> get madeForYou => _madeForYou;
  List<Track> get newReleases => _newReleases;
  List<Album> get featuredAlbums => _featuredAlbums;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _recentlyPlayed = _generateMockPlaylists();
      _madeForYou = _generateMockMadeForYouPlaylists();
      _newReleases = _generateMockTracks();
      _featuredAlbums = _generateMockAlbums();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Playlist> _generateMockPlaylists() {
    return [
      Playlist(
        id: '1',
        name: 'Liked Songs',
        description: 'Your favorite tracks',
        coverImage: 'https://via.placeholder.com/300',
        creatorId: 'user1',
        creatorName: 'You',
        tracks: [],
        type: PlaylistType.likedSongs,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalDuration: const Duration(hours: 2),
      ),
      Playlist(
        id: '2',
        name: 'Today\'s Top Hits',
        description: 'The biggest songs right now',
        coverImage: 'https://via.placeholder.com/300',
        creatorId: 'spotify',
        creatorName: 'Spotify',
        tracks: [],
        type: PlaylistType.madeForYou,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalDuration: const Duration(hours: 3),
      ),
    ];
  }

  List<Playlist> _generateMockMadeForYouPlaylists() {
    return [
      Playlist(
        id: '3',
        name: 'Discover Weekly',
        description: 'Your weekly mixtape of fresh music',
        coverImage: 'https://via.placeholder.com/300',
        creatorId: 'spotify',
        creatorName: 'Spotify',
        tracks: [],
        type: PlaylistType.discoverWeekly,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalDuration: const Duration(hours: 2),
      ),
      Playlist(
        id: '4',
        name: 'Release Radar',
        description: 'Catch all the latest music from artists you follow',
        coverImage: 'https://via.placeholder.com/300',
        creatorId: 'spotify',
        creatorName: 'Spotify',
        tracks: [],
        type: PlaylistType.releaseRadar,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalDuration: const Duration(hours: 1, minutes: 30),
      ),
    ];
  }

  List<Track> _generateMockTracks() {
    return [
      Track(
        id: '1',
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        album: 'After Hours',
        albumArt: 'https://via.placeholder.com/300',
        duration: const Duration(minutes: 3, seconds: 20),
        audioUrl: 'https://example.com/track1.mp3',
      ),
      Track(
        id: '2',
        title: 'Watermelon Sugar',
        artist: 'Harry Styles',
        album: 'Fine Line',
        albumArt: 'https://via.placeholder.com/300',
        duration: const Duration(minutes: 2, seconds: 54),
        audioUrl: 'https://example.com/track2.mp3',
      ),
    ];
  }

  List<Album> _generateMockAlbums() {
    return [
      Album(
        id: '1',
        title: 'After Hours',
        artistId: 'artist1',
        artistName: 'The Weeknd',
        coverImage: 'https://via.placeholder.com/300',
        type: AlbumType.album,
        releaseDate: DateTime(2020, 3, 20),
        tracks: [],
        totalDuration: const Duration(minutes: 56),
        totalTracks: 14,
      ),
      Album(
        id: '2',
        title: 'Fine Line',
        artistId: 'artist2',
        artistName: 'Harry Styles',
        coverImage: 'https://via.placeholder.com/300',
        type: AlbumType.album,
        releaseDate: DateTime(2019, 12, 13),
        tracks: [],
        totalDuration: const Duration(minutes: 46),
        totalTracks: 12,
      ),
    ];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}