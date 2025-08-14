import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinephile/models/actor.dart';
import 'package:flutter/material.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor actor;

  const ActorDetailScreen({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(actor.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (actor.profilePath != null)
              CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${actor.profilePath}',
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(actor.biography ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}