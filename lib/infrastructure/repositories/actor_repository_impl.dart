import 'package:cineapp_flutter/domain/datasources/actors_datasource.dart';
import 'package:cineapp_flutter/domain/entities/actor.dart';
import 'package:cineapp_flutter/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDataSource datasource;
  ActorRepositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
