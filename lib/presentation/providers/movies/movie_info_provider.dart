import 'package:cineapp_flutter/config/domain/entities/movie.dart';
import 'package:cineapp_flutter/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});

typedef GetMoiveCallBack = Future<Movie> Function(String moveID);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMoiveCallBack getMovie;
  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    print('realizando peticion http');

    final movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}
