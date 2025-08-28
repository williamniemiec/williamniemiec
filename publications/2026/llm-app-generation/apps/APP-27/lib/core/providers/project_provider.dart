import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/video_project.dart';
import '../../shared/services/project_service.dart';

// Project service provider
final projectServiceProvider = Provider<ProjectService>((ref) {
  return ProjectService();
});

// Current project provider
final currentProjectProvider = StateNotifierProvider<CurrentProjectNotifier, VideoProject?>((ref) {
  return CurrentProjectNotifier(ref.read(projectServiceProvider));
});

// All projects provider
final allProjectsProvider = FutureProvider<List<VideoProject>>((ref) async {
  final projectService = ref.read(projectServiceProvider);
  return await projectService.getAllProjects();
});

// Recent projects provider
final recentProjectsProvider = FutureProvider<List<VideoProject>>((ref) async {
  final projectService = ref.read(projectServiceProvider);
  return await projectService.getRecentProjects();
});

// Project statistics provider
final projectStatisticsProvider = FutureProvider<ProjectStatistics>((ref) async {
  final projectService = ref.read(projectServiceProvider);
  return await projectService.getProjectStatistics();
});

// Search projects provider
final searchProjectsProvider = StateNotifierProvider<SearchProjectsNotifier, AsyncValue<List<VideoProject>>>((ref) {
  return SearchProjectsNotifier(ref.read(projectServiceProvider));
});

class CurrentProjectNotifier extends StateNotifier<VideoProject?> {
  final ProjectService _projectService;

  CurrentProjectNotifier(this._projectService) : super(null);

  /// Create a new project
  Future<void> createProject(String name, {ProjectSettings? settings}) async {
    try {
      final project = VideoProject.create(name: name, settings: settings);
      await _projectService.saveProject(project);
      state = project;
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  /// Load an existing project
  Future<void> loadProject(String projectId) async {
    try {
      final project = await _projectService.getProject(projectId);
      if (project != null) {
        state = project;
      } else {
        throw Exception('Project not found');
      }
    } catch (e) {
      throw Exception('Failed to load project: $e');
    }
  }

  /// Save current project
  Future<void> saveProject() async {
    if (state == null) return;
    
    try {
      await _projectService.updateProject(state!);
    } catch (e) {
      throw Exception('Failed to save project: $e');
    }
  }

  /// Update project name
  Future<void> updateProjectName(String name) async {
    if (state == null) return;
    
    final updatedProject = state!.copyWith(name: name);
    state = updatedProject;
    await saveProject();
  }

  /// Add video clip to project
  Future<void> addVideoClip(VideoClip clip) async {
    if (state == null) return;
    
    final clips = List<VideoClip>.from(state!.clips)..add(clip);
    final updatedProject = state!.copyWith(clips: clips);
    state = updatedProject;
    await saveProject();
  }

  /// Remove video clip from project
  Future<void> removeVideoClip(String clipId) async {
    if (state == null) return;
    
    final clips = state!.clips.where((clip) => clip.id != clipId).toList();
    final updatedProject = state!.copyWith(clips: clips);
    state = updatedProject;
    await saveProject();
  }

  /// Update video clip
  Future<void> updateVideoClip(VideoClip updatedClip) async {
    if (state == null) return;
    
    final clips = state!.clips.map((clip) {
      return clip.id == updatedClip.id ? updatedClip : clip;
    }).toList();
    
    final updatedProject = state!.copyWith(clips: clips);
    state = updatedProject;
    await saveProject();
  }

  /// Add audio track to project
  Future<void> addAudioTrack(AudioTrack track) async {
    if (state == null) return;
    
    final audioTracks = List<AudioTrack>.from(state!.audioTracks)..add(track);
    final updatedProject = state!.copyWith(audioTracks: audioTracks);
    state = updatedProject;
    await saveProject();
  }

  /// Remove audio track from project
  Future<void> removeAudioTrack(String trackId) async {
    if (state == null) return;
    
    final audioTracks = state!.audioTracks.where((track) => track.id != trackId).toList();
    final updatedProject = state!.copyWith(audioTracks: audioTracks);
    state = updatedProject;
    await saveProject();
  }

  /// Update audio track
  Future<void> updateAudioTrack(AudioTrack updatedTrack) async {
    if (state == null) return;
    
    final audioTracks = state!.audioTracks.map((track) {
      return track.id == updatedTrack.id ? updatedTrack : track;
    }).toList();
    
    final updatedProject = state!.copyWith(audioTracks: audioTracks);
    state = updatedProject;
    await saveProject();
  }

  /// Add text overlay to project
  Future<void> addTextOverlay(TextOverlay overlay) async {
    if (state == null) return;
    
    final textOverlays = List<TextOverlay>.from(state!.textOverlays)..add(overlay);
    final updatedProject = state!.copyWith(textOverlays: textOverlays);
    state = updatedProject;
    await saveProject();
  }

  /// Remove text overlay from project
  Future<void> removeTextOverlay(String overlayId) async {
    if (state == null) return;
    
    final textOverlays = state!.textOverlays.where((overlay) => overlay.id != overlayId).toList();
    final updatedProject = state!.copyWith(textOverlays: textOverlays);
    state = updatedProject;
    await saveProject();
  }

  /// Update text overlay
  Future<void> updateTextOverlay(TextOverlay updatedOverlay) async {
    if (state == null) return;
    
    final textOverlays = state!.textOverlays.map((overlay) {
      return overlay.id == updatedOverlay.id ? updatedOverlay : overlay;
    }).toList();
    
    final updatedProject = state!.copyWith(textOverlays: textOverlays);
    state = updatedProject;
    await saveProject();
  }

  /// Add effect to project
  Future<void> addEffect(Effect effect) async {
    if (state == null) return;
    
    final effects = List<Effect>.from(state!.effects)..add(effect);
    final updatedProject = state!.copyWith(effects: effects);
    state = updatedProject;
    await saveProject();
  }

  /// Remove effect from project
  Future<void> removeEffect(String effectId) async {
    if (state == null) return;
    
    final effects = state!.effects.where((effect) => effect.id != effectId).toList();
    final updatedProject = state!.copyWith(effects: effects);
    state = updatedProject;
    await saveProject();
  }

  /// Update effect
  Future<void> updateEffect(Effect updatedEffect) async {
    if (state == null) return;
    
    final effects = state!.effects.map((effect) {
      return effect.id == updatedEffect.id ? updatedEffect : effect;
    }).toList();
    
    final updatedProject = state!.copyWith(effects: effects);
    state = updatedProject;
    await saveProject();
  }

  /// Update project settings
  Future<void> updateProjectSettings(ProjectSettings settings) async {
    if (state == null) return;
    
    final updatedProject = state!.copyWith(settings: settings);
    state = updatedProject;
    await saveProject();
  }

  /// Calculate total project duration
  Duration calculateTotalDuration() {
    if (state == null) return Duration.zero;
    
    Duration maxDuration = Duration.zero;
    
    // Check video clips
    for (final clip in state!.clips) {
      final clipEndTime = clip.timelinePosition + clip.duration;
      if (clipEndTime > maxDuration) {
        maxDuration = clipEndTime;
      }
    }
    
    // Check audio tracks
    for (final track in state!.audioTracks) {
      final trackEndTime = track.timelinePosition + track.duration;
      if (trackEndTime > maxDuration) {
        maxDuration = trackEndTime;
      }
    }
    
    // Check text overlays
    for (final overlay in state!.textOverlays) {
      if (overlay.endTime > maxDuration) {
        maxDuration = overlay.endTime;
      }
    }
    
    return maxDuration;
  }

  /// Clear current project
  void clearProject() {
    state = null;
  }
}

class SearchProjectsNotifier extends StateNotifier<AsyncValue<List<VideoProject>>> {
  final ProjectService _projectService;

  SearchProjectsNotifier(this._projectService) : super(const AsyncValue.data([]));

  /// Search projects by query
  Future<void> searchProjects(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final projects = await _projectService.searchProjects(query);
      state = AsyncValue.data(projects);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Clear search results
  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}