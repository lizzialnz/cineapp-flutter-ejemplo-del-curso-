// llamar el datasource y de ahi los metodos
import 'package:cineapp_flutter/config/domain/datasource/movies_datasource.dart';
import 'package:cineapp_flutter/config/domain/entities/movie.dart';
import 'package:cineapp_flutter/config/domain/repositories/movies_repositories.dart';

class MovieRespositoryImpl extends MovieRepository {
  final MoviesDatasource datasource;
  MovieRespositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}
