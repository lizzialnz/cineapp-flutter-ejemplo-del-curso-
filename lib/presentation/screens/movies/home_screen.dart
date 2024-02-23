import 'package:cineapp_flutter/presentation/providers/providers.dart';
import 'package:cineapp_flutter/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // se puede llegar a este componente con este nombre
  static const name = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}
// Para utilizar el metodo red.read() se puede crear un ConsumerStatefulWidget

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    //watch porque esta pendiente del estado ( el ref se utiliza del riverpod)
    final slideShowMovie = ref.watch(moviesSlideShowProvider);
    //Listar peliculas
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    if (slideShowMovie.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        color: colors.primary,
      ));
    }

    // CustomScrollView es un widget que permite tener un scroll personalizado
    //SliverList es un widget que permite tener una lista de elementos
    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        title: CustomAppbar(),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        //widget anterior
        return Column(
          children: [
            // const CustomAppbar(),
            MoviesSlideshow(movies: slideShowMovie),
            MovieHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En Cines',
              subTitle: 'Lunes 25',
              // read no watch porque se usa read dentro de las funciones
              loadNextPage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),
            //*proximamente
            MovieHorizontalListview(
              movies: upComingMovies,
              title: 'Próximamente',
              subTitle: 'Este mes',
              loadNextPage: () =>
                  ref.read(upComingMoviesProvider.notifier).loadNextPage(),
            ),
            //*populares
            MovieHorizontalListview(
              movies: popularMovies,
              title: 'Populares',
              subTitle: 'Solo Aquí',
              loadNextPage: () =>
                  ref.read(popularMoviesProvider.notifier).loadNextPage(),
            ),
            //*mejor valoradas
            MovieHorizontalListview(
              movies: topRatedMovies,
              title: 'Mejor Calificadas',
              subTitle: 'De Siempre',
              loadNextPage: () =>
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
            ),

            const SizedBox(height: 20),
          ],
        );
      }, childCount: 1))
    ]);
  }
}
