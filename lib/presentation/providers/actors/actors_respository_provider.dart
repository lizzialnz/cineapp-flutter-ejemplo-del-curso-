import 'package:cineapp_flutter/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cineapp_flutter/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorMovieDbDatasource());
});
