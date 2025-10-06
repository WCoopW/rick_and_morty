import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/core/utils/extensions/context_extension.dart';
import 'package:rick_and_morty/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/favorites/favorites_bloc.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/favorites/favorites_event.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/favorites/favorites_state.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/i_local_characters_repository.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

class FavoritesScope extends StatefulWidget {
  const FavoritesScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static FavoritesScopeState of(
    BuildContext context, {
    bool listen = true,
  }) =>
      context
          .inhOf<_CharactersInherited>(
            listen: listen,
          )
          .scopeState;

  @override
  State<FavoritesScope> createState() => FavoritesScopeState();
}

/* -------------------------------------------------------------------------- */
class FavoritesScopeState extends State<FavoritesScope> {
  ScrollController scrollController = ScrollController();
  late final FavoritesBloc _favoritesBloc;
  late final StreamSubscription<void> _streamSubscription;
  late final ILocalCharactersRepository repo;
  String? _selectedStatus;
/* -------------------------------------------------------------------------- */
  List<CharacterEntity> get characters => _favoritesBlocState.favorites ?? [];

  List<CharacterEntity> get filteredCharacters =>
      _selectedStatus != null ? _favoritesBlocState.filteredFavorites ?? [] : characters;
  String? get selectedStatus => _selectedStatus;

  var currentPage = 1;
  var _favoritesBlocState = const FavoritesState.idle();

/* -------------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    repo = DependenciesScope.of(context).favoritesRepository;
    _favoritesBloc = FavoritesBloc(
      repository: repo,
      initialState: _favoritesBlocState,
    );
    initListeners();
  }

/* -------------------------------------------------------------------------- */
  void initListeners() {
    _streamSubscription = _favoritesBloc.stream.listen(_didStateChanged);
    this.fetchFavorites(null);
  }

  @override
  void dispose() {
    _favoritesBloc.close();
    _streamSubscription.cancel();
    scrollController.dispose();
    super.dispose();
  }

/* -------------------------------------------------------------------------- */
  void _didStateChanged(FavoritesState state) {
    if (state != _favoritesBlocState) {
      setState(
        () => _favoritesBlocState = state,
      );
    }
  }

/* -------------------------------------------------------------------------- */
  String? get error {
    if (_favoritesBlocState.hasError) {
      return _favoritesBlocState.message;
    }
    return null;
  }

/* -------------------------------------------------------------------------- */
  void fetchFavorites(String? status) {
    _favoritesBloc.add(
      FavoritesEvent.fetchFavorites(status),
    );
  }

  void addFavorite(CharacterEntity character) {
    _favoritesBloc.add(
      FavoritesEvent.addCharacter(character),
    );
  }

  void removeFavorite(int id) {
    _favoritesBloc.add(
      FavoritesEvent.removeCharacter(id),
    );
  }

  void setStatusFilter(String? status) {
    setState(() {
      _selectedStatus = status;
    });
    _favoritesBloc.add(
      FavoritesEvent.filterFavorites(status),
    );
  }

/* -------------------------------------------------------------------------- */
  FavoritesState get state => _favoritesBlocState;

/* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) => _CharactersInherited(
        state: _favoritesBlocState,
        scopeState: this,
        child: widget.child,
      );
}

/* -------------------------------------------------------------------------- */
class _CharactersInherited extends InheritedWidget {
  const _CharactersInherited({
    required super.child,
    required this.state,
    required this.scopeState,
  });

  final FavoritesState state;
  final FavoritesScopeState scopeState;

  @override
  bool updateShouldNotify(
    _CharactersInherited oldWidget,
  ) =>
      state != oldWidget.state;
}
/* -------------------------------------------------------------------------- */