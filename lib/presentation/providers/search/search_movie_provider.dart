import 'package:cineapp_flutter/domain/entities/movie.dart';
import 'package:cineapp_flutter/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');


final searchedMoviesProvider =
    StateNotifierProvider<SearchedMovieNotifier, List<Movie>>((ref) {
  final searchRepository = ref.read(movieRepositoryProvider);
  return SearchedMovieNotifier(
      searchMovies: searchRepository.searchMovies, ref: ref);
});

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchedMovieNotifier extends StateNotifier<List<Movie>> {
  final SearchMovieCallBack searchMovies;
  final Ref ref;
  SearchedMovieNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
