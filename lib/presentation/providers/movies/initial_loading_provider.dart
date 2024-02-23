import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final Step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final Step2 = ref.watch(popularMoviesProvider).isEmpty;
  final Step3 = ref.watch(upComingMoviesProvider).isEmpty;
  final Step4 = ref.watch(topRatedMoviesProvider).isEmpty;

  if (Step1 || Step2 || Step3 || Step4) return true;
  return false;
});
