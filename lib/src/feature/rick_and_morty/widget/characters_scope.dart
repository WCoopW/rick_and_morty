import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/core/utils/extensions/context_extension.dart';
import 'package:rick_and_morty/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/characters_bloc.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/characters_event.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/characters_state.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/i_characters_repository.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorites_scope.dart';

class CharactersScope extends StatefulWidget {
  const CharactersScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static CharactersScopeState of(
    BuildContext context, {
    bool listen = true,
  }) =>
      context
          .inhOf<_CharactersInherited>(
            listen: listen,
          )
          .scopeState;

  @override
  State<CharactersScope> createState() => CharactersScopeState();
}

/* -------------------------------------------------------------------------- */
class CharactersScopeState extends State<CharactersScope> {
  ScrollController scrollController = ScrollController();
  late final CharactersBloc _charactersBloc;
  late final StreamSubscription<void> _streamSubscription;
  late final ICharactersRepository repo;
  late final FavoritesScopeState favoritesScope;
  List<int> get favoritesList =>
      FavoritesScope.of(context, listen: true).characters.map((e) => e.id).toList();

  static const double _scrollThreshold = 200.0;
/* -------------------------------------------------------------------------- */
  List<CharacterEntity> get characters => _charactersBlocState.characters ?? [];
  var currentPage = 1;
  var _charactersBlocState = const CharactersState.idle(endOfList: false);

  /* -------------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    repo = DependenciesScope.of(context).charactersRepository;
    _charactersBloc = CharactersBloc(
      repository: repo,
      initialState: _charactersBlocState,
    );
    initListeners();
  }

  /* -------------------------------------------------------------------------- */
  void initListeners() {
    _streamSubscription = _charactersBloc.stream.listen(_didStateChanged);
    favoritesScope = FavoritesScope.of(context, listen: false);
    scrollController.addListener(_onScrollCallback);
    this.fetchCharacters();
  }

  /* -------------------------------------------------------------------------- */
  void _onScrollCallback() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - _scrollThreshold) {
      if (_charactersBlocState.hasMore && !_charactersBlocState.isProcessing) {
        fetchCharacters();
      }
    }
  }

  @override
  void dispose() {
    _charactersBloc.close();
    _streamSubscription.cancel();
    scrollController.dispose();
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  void _didStateChanged(CharactersState state) {
    if (state != _charactersBlocState) {
      setState(
        () => _charactersBlocState = state,
      );

      // Increment page after successful load
      if (state.maybeMap(
        orElse: () => false,
        successful: (successful) {
          if (!successful.endOfList) {
            currentPage += 1;
          }
          return true;
        },
      )) {
        return;
      }
    }
  }

  bool isFavorite(int characterId) {
    return favoritesList.contains(characterId);
  }

  Future<void> favoriteButtonClick(int characterId) async {
    if (isFavorite(characterId)) {
      favoritesScope.removeFavorite(
        characterId,
      );
      return;
    }

    final character = characters.firstWhere((e) => e.id == characterId);
    if (character.location.isFetched()) {
      favoritesScope.addFavorite(character);
      return;
    }
    final updated = await fetchCharacterLocation(character);
    favoritesScope.addFavorite(updated);
  }

  void _showLocationErrorSnackbar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось загрузить информацию о локации.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<CharacterEntity> fetchCharacterLocation(CharacterEntity character) async {
    if (character.location.isFetched()) {
      return character;
    }

    try {
      _charactersBloc.add(CharactersEvent.fetchLocation(character));
      final stateWithLocation = await _charactersBloc.stream.firstWhere((state) => state.maybeMap(
            orElse: () => false,
            successfulAddLocation: (_) => true,
            error: (_) => true,
          ));

      if (stateWithLocation.hasError) {
        _showLocationErrorSnackbar();
        return character;
      }
      final updatedCharacter =
          stateWithLocation.characters?.firstWhere((e) => e.id == character.id) ?? character;

      if (!updatedCharacter.location.isFetched()) {
        _showLocationErrorSnackbar();
      }
      return updatedCharacter;
    } catch (e) {
      _showLocationErrorSnackbar();
      return character;
    }
  }

/* -------------------------------------------------------------------------- */
  String? get error {
    if (_charactersBlocState.hasError) {
      return _charactersBlocState.message;
    }
    return null;
  }

/* -------------------------------------------------------------------------- */
  void fetchCharacters() {
    _charactersBloc.add(
      CharactersEvent.fetchCharacters(currentPage),
    );
  }

  refreshCharacters() {
    _charactersBloc.add(
      CharactersEvent.fetchCharacters(1),
    );
  }

  /* -------------------------------------------------------------------------- */
  CharactersState get state => _charactersBlocState;

  /* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) => _CharactersInherited(
        state: _charactersBlocState,
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

  final CharactersState state;
  final CharactersScopeState scopeState;

  @override
  bool updateShouldNotify(
    _CharactersInherited oldWidget,
  ) =>
      state != oldWidget.state;
}
/* -------------------------------------------------------------------------- */