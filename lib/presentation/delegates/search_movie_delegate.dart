import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cineapp_flutter/config/helpers/formatter/formatter_numer.dart';
import 'package:cineapp_flutter/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieDelegateCallback = Future<List<Movie>> Function(
    String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieDelegateCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _deboundTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChange(String query) {
    isLoadingStream.add(true);
    if (_deboundTimer?.isActive ?? false) _deboundTimer?.cancel();

    _deboundTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  //? funcion que retorna un widget para buildResults y buildSuggestions
  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
                movie: movie,
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                });
          },
        );
      },
    );
  }
  //?------------------

  //* letras que aparecen en el campo de búsqueda
  @override
  String get searchFieldLabel => 'Buscar película';

  //* icono de la derecha de limpiar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (query.isEmpty) {
            return FadeIn(
              animate: query.isEmpty,
              child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(Icons.search_outlined)),
            );
          }
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 2),
              spins: 10,
              infinite: true,
              child: FadeIn(
                animate: query.isNotEmpty,
                child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh_outlined)),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.close_rounded)),
          );
        },
      )
    ];
  }

  @override
  //* icono de la izquierda de regresar
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  //* resultados de la búsqueda

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);
    return _buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              //* Imagen
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(movie.posterPath,
                      loadingBuilder: (context, child, loadingProgress) =>
                          FadeIn(child: child)),
                ),
              ),

              const SizedBox(width: 10),

              //* Título y descripción
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleMedium),
                    (movie.overview.length > 100)
                        //* el substring permite que el texto muestre solo los primeros 100 caracteres
                        ? Text('${movie.overview.substring(0, 100)}...')
                        : Text(movie.overview),
                    Row(
                      children: [
                        Icon(Icons.star_half_outlined,
                            color: Colors.yellow.shade800),
                        const SizedBox(width: 5),
                        Text(
                          FormatterNumber.number(movie.voteAverage, 1),
                          style: textStyle.bodyMedium!
                              .copyWith(color: Colors.yellow.shade900),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
