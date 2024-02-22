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
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    //watch porque esta pendiente del estado ( el ref se utiliza del riverpod)
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovie = ref.watch(moviesSlideShowProvider);
    if (slideShowMovie.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        color: colors.primary,
      ));
    }

    // ListView permite mostrar una lista de elementos
    // el item count es la cantidad de elementos que se van a mostrar
    // el itemBuilder es la funcion que se va a ejecutar por cada elemento
    return Column(
      children: [
        const CustomAppbar(),
        MoviesSlideshow(movies: slideShowMovie),
        MovieHorizontalListview(
          movies: nowPlayingMovies,
          title: 'En Cines',
          subTitle: 'Lunes 25',
          // read no watch porque se usa read dentro de las funciones
          loadNextPage: () =>
              ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
        )
      ],
    );
  }
}
