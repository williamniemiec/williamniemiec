import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinephile/models/actor.dart';
import 'package:cinephile/models/tv_show.dart';
import 'package:cinephile/screens/actor_detail_screen.dart';
import 'package:cinephile/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TvShowDetailScreen extends ConsumerWidget {
  final TvShow tvShow;

  const TvShowDetailScreen({super.key, required this.tvShow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.backdropPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvShow.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${tvShow.voteAverage}/10',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tvShow.overview ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Where to Watch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Image.network('https://www.themoviedb.org/t/p/original/9A1JSVmSxsyaBK4SUFsYVQrseqQ.jpg', height: 40), // Netflix
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: FutureBuilder<List<Actor>>(
                      future: ref.read(tvShowRepositoryProvider).getTvShowCast(tvShow.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final actor = snapshot.data![index];
                              return GestureDetector(
                                onTap: () async {
                                  final actorDetails = await ref.read(tvShowRepositoryProvider).getActorDetails(actor.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActorDetailScreen(actor: actorDetails),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    if (actor.profilePath != null)
                                      CircleAvatar(
                                        backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w200${actor.profilePath}'),
                                        radius: 40,
                                      ),
                                    Text(actor.name),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}