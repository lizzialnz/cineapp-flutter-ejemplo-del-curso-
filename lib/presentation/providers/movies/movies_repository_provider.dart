//no va a cambiar el valor de la instancia de MoviesRepository

import 'package:cineapp_flutter/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cineapp_flutter/infrastructure/repositories/movie_respository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// este repositorio es inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRespositoryImpl(MoviedbDatasource());
});
