import 'package:dio/dio.dart';
import 'package:cineapp_flutter/config/constants/environment.dart';
import 'package:cineapp_flutter/config/domain/datasource/movies_datasource.dart';
import 'package:cineapp_flutter/config/domain/entities/movie.dart';
import 'package:cineapp_flutter/infrestructure/mappers/moviedb_mapper.dart';
import 'package:cineapp_flutter/infrestructure/models/moviedb/moviedb_response.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    },
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final movieDbResponse = MovieDbResponse.fromJson(response.data);
    // listado de movie que debe retornar
    final List<Movie> movies = movieDbResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MoviedbMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }
}
