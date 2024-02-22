// Origenes de Datos
import 'package:cineapp_flutter/config/domain/entities/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
