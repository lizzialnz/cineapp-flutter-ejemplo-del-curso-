import 'package:cineapp_flutter/domain/entities/movie.dart';
import 'package:cineapp_flutter/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideShowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  if (nowPlayingMovies.isEmpty) return const [];

  return nowPlayingMovies.sublist(0, 6);
});
