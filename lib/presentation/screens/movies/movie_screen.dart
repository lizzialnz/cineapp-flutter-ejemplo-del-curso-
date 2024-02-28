import 'package:animate_do/animate_do.dart';
import 'package:cineapp_flutter/domain/entities/movie.dart';
import 'package:cineapp_flutter/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  // dentro del consumer se puede usar ref en cualquier lugar a diferencia del Satelesswidget que se utiliza dentro del build
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          //* Descripcion de la pelicula
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    //* Titulo y descripcion
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge),
                    Text(movie.overview),
                  ],
                ),
              )
            ],
          ),
        ),

        //* Se Muestran Genero
        Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              children: [
                ...movie.genreIds.map((genres) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Chip(
                          label: Text(genres),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ))
              ],
            )),

        //* Se Muestran Actores
        _ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if (actorsByMovie[movieId] == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FadeInRight(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    height: 180,
                    width: 135,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                actor.name,
                maxLines: 2,
              ),
              Text(
                actor.character ?? '',
                maxLines: 2,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
              )
            ]),
          );
        },
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7, // 70% de la pantalla
      foregroundColor: Colors.white,
      //* contenedor de imagen y titulo de la pelicula

      //* titulo de la pelicula
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 15),
        //   textAlign: TextAlign.start,
        // ),

        //* imagen de la pelicula y gradiente
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.7, 1.0],
                        colors: [Colors.transparent, Colors.black])),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        stops: [0.0, 0.4],
                        colors: [Colors.black87, Colors.transparent])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
