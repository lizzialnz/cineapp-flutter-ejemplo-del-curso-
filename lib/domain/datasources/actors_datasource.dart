import 'package:cineapp_flutter/domain/entities/actor.dart';

abstract class ActorsDataSource {
  //* el future espera una lista de actores
  Future<List<Actor>> getActorsByMovie(String movieId);
}
