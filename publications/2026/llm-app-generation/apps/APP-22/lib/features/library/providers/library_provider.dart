import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class LibraryProvider extends ChangeNotifier {
  List<Playlist> _playlists = [];
  List<Album> _savedAlbums = [];
  List<Artist> _followedArtists = [];
  List<Track> _likedSongs = [];
  List<Track> _downloadedTracks = [];
  bool _isLoading = false;
  String? _error;

  List<Playlist> get playlists => _playlists;
  List<Album> get savedAlbums => _savedAlbums;
  List<Artist> get followedArtists => _followedArtists;
  List<Track> get likedSongs => _likedSongs;
  List<Track> get downloadedTracks => _downloadedTracks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLibraryData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _playlists = _generateMockPlaylists();
      _savedAlbums = _generateMockAlbums();
      _followedArtists = _generateMockArtists();
      _likedSongs = _generateMockLikedSongs();
      _downloadedTracks = _generateMockDownloadedTracks();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPlaylist(String name, String description) async {
    final newPlaylist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      coverImage: 'https://via.placeholder.com/300',
      creatorId: 'user1',
      creatorName: 'You',
      tracks: [],
      type: PlaylistType.userCreated,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      totalDuration: Duration.zero,
    );
    
    _playlists.insert(0, newPlaylist);
    notifyListeners();
  }

  Future<void> deletePlaylist(String playlistId) async {
    _playlists.removeWhere((playlist) => playlist.id == playlistId);
    notifyListeners();
  }

  Future<void> likeTrack(Track track) async {
    if (!_likedSongs.any((t) => t.id == track.id)) {
      _likedSongs.insert(0, track.copyWith(isLiked: true));
      notifyListeners();
    }
  }

  Future<void> unlikeTrack(String trackId) async {
    _likedSongs.removeWhere((track) => track.id == trackId);
    notifyListeners();
  }

  Future<void> followArtist(Artist artist) async {
    if (!_followedArtists.any((a) => a.id == artist.id)) {
      _followedArtists.add(artist.copyWith(isFollowing: true));
      notifyListeners();
    }
  }

  Future<void> unfollowArtist(String artistId) async {
    _followedArtists.removeWhere((artist) => artist.id == artistId);
    notifyListeners();
  }

  Future<void> saveAlbum(Album album) async {
    if (!_savedAlbums.any((a) => a.id == album.id)) {
      _savedAlbums.add(album.copyWith(isLiked: true));
      notifyListeners();
    }
  }

  Future<void> unsaveAlbum(String albumId) async {
    _savedAlbums.removeWhere((album) => album.id == albumId);
    notifyListeners();
  }

  List<Playlist> _generateMockPlaylists() {
    return [
      Playlist(
        id: '1',
        name: 'My Playlist #1',
        description: 'My favorite songs',
        coverImage: 'https://via.placeholder.com/300',
        creatorId: 'user1',
        creatorName: 'You',
        tracks: [],
        type: PlaylistType.userCreated,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        totalDuration: const Duration(hours: 2, minutes: 30),
      ),
    ];
  }

  List<Album> _generateMockAlbums() {
    return [
      Album(
        id: '1',
        title: 'Saved Album',
        artistId: 'artist1',
        artistName: 'Saved Artist',
        coverImage: 'https://via.placeholder.com/300',
        type: AlbumType.album,
        releaseDate: DateTime(2023, 1, 1),
        tracks: [],
        totalDuration: const Duration(minutes: 45),
        totalTracks: 12,
        isLiked: true,
      ),
    ];
  }

  List<Artist> _generateMockArtists() {
    return [
      Artist(
        id: '1',
        name: 'Followed Artist',
        profileImage: 'https://via.placeholder.com/300',
        followerCount: 1000000,
        monthlyListeners: 5000000,
        isFollowing: true,
      ),
    ];
  }

  List<Track> _generateMockLikedSongs() {
    return [
      Track(
        id: '1',
        title: 'Liked Song 1',
        artist: 'Artist 1',
        album: 'Album 1',
        albumArt: 'https://via.placeholder.com/300',
        duration: const Duration(minutes: 3, seconds: 30),
        audioUrl: 'https://example.com/track1.mp3',
        isLiked: true,
      ),
      Track(
        id: '2',
        title: 'Liked Song 2',
        artist: 'Artist 2',
        album: 'Album 2',
        albumArt: 'https://via.placeholder.com/300',
        duration: const Duration(minutes: 4, seconds: 15),
        audioUrl: 'https://example.com/track2.mp3',
        isLiked: true,
      ),
    ];
  }

  List<Track> _generateMockDownloadedTracks() {
    return [
      Track(
        id: '3',
        title: 'Downloaded Song',
        artist: 'Downloaded Artist',
        album: 'Downloaded Album',
        albumArt: 'https://via.placeholder.com/300',
        duration: const Duration(minutes: 3, seconds: 45),
        audioUrl: 'https://example.com/track3.mp3',
        isDownloaded: true,
      ),
    ];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}