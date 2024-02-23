// Quienes llaman al data source, y evita que se haga de forma directa
import 'package:cineapp_flutter/config/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpComing({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
}
