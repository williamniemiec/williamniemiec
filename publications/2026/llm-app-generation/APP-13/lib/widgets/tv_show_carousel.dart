import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinephile/models/tv_show.dart';
import 'package:cinephile/screens/tv_show_detail_screen.dart';
import 'package:flutter/material.dart';

class TvShowCarousel extends StatelessWidget {
  final String title;
  final Future<List<TvShow>> future;

  const TvShowCarousel({
    super.key,
    required this.title,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder<List<TvShow>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final tvShow = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvShowDetailScreen(tvShow: tvShow),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}