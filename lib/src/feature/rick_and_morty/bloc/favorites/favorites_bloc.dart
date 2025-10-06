import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/favorites/favorites_event.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/favorites/favorites_state.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/i_local_characters_repository.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState>
    implements EventSink<FavoritesEvent> {
  final ILocalCharactersRepository repository;

  FavoritesBloc({
    required this.repository,
    FavoritesState initialState = const FavoritesState.idle(),
  }) : super(initialState) {
    on<FavoritesEvent>(
      (event, emit) => event.map(
        addCharacter: (event) => _addFavorite(event, emit),
        fetchFavorites: (event) => _fetchFavorites(event, emit),
        filterFavorites: (event) => _filterFavorites(event, emit),
        removeCharacter: (event) => _removeFavorite(event, emit),
      ),
    );
  }

  _fetchFavorites(FetchFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(event.processing(
        state: state,
        favorites: state.favorites,
      ));
      final result = await repository.getFavorites(event.status);

      emit(event.successful(
        state: state,
        favorites: result,
      ));
    } catch (e) {
      emit(event.error(
        state: state,
        favorites: state.favorites,
        message: 'Произошла ошибка при получении избранных',
      ));
    } finally {
      emit(event.idle(
        state: state,
      ));
    }
  }

  _filterFavorites(FilterFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(event.processing(
        state: state,
      ));
      final filteredFavorites = await repository.getFavorites(event.status);
      emit(event.successful(
        state: state,
        favorites: state.favorites ?? [],
        filteredFavorites: filteredFavorites,
      ));
    } catch (e) {
      emit(event.error(
        state: state,
        favorites: state.favorites,
        message: 'Произошла ошибка при фильтрации избранных',
      ));
    } finally {
      emit(event.idle(
        state: state,
      ));
    }
  }

  _addFavorite(AddFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(event.processing(
        state: state,
      ));
      final result = await this.repository.addFavorite(event.character);
      if (result > 0) {
        emit(event.successful(
          state: state,
          favorites: [...(state.favorites ?? <CharacterEntity>[]), event.character],
        ));
      } else {
        emit(event.error(
          state: state,
          favorites: state.favorites,
          message: 'Произошла ошибка при добавлении в избранное',
        ));
      }
    } on Object catch (e) {
      emit(event.error(
        state: state,
        favorites: state.favorites,
        message: 'Произошла ошибка при добавлении в избранное',
      ));
    } finally {
      emit(event.idle(
        state: state,
      ));
    }
  }

  _removeFavorite(RemoveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(event.processing(
        state: state,
      ));
      final result = await repository.removeFavorite(event.id);
      if (result > 0) {
        final favorites = await repository.getFavorites(state.sortStatus);
        emit(event.successful(
          state: state,
          favorites: favorites,
        ));
      }
    } catch (e) {
      emit(event.error(
        state: state,
        favorites: state.favorites,
        message: 'Произошла ошибка при удалении из избранного',
      ));
    } finally {
      emit(event.idle(
        state: state,
      ));
    }
  }
}
