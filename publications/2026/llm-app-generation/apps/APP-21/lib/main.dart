import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'shared/models/song.dart';
import 'shared/models/artist.dart';
import 'shared/models/playlist.dart';
import 'shared/models/user.dart';
import 'shared/models/album.dart';
import 'main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(ArtistAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AlbumAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Song>(AppConstants.songsBoxKey);
  await Hive.openBox<Artist>(AppConstants.artistsBoxKey);
  await Hive.openBox<Playlist>(AppConstants.playlistsBoxKey);
  await Hive.openBox<User>(AppConstants.userBoxKey);
  await Hive.openBox<Album>(AppConstants.albumsBoxKey);
  await Hive.openBox(AppConstants.settingsBoxKey);
  await Hive.openBox(AppConstants.cacheBoxKey);
  
  runApp(
    const ProviderScope(
      child: YouTubeMusicApp(),
    ),
  );
}

class YouTubeMusicApp extends StatelessWidget {
  const YouTubeMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme for YouTube Music
      home: const MainNavigation(),
    );
  }
}
