import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/favorites/favorites_state.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

part 'favorites_event.freezed.dart';

@freezed
class FavoritesEvent with _$FavoritesEvent {
  const FavoritesEvent._();

  @With<_ProcessingStateEmitter>()
  @With<_SuccessfulStateEmitter>()
  @With<_ErrorStateEmitter>()
  @With<_IdleStateEmitter>()
  const factory FavoritesEvent.fetchFavorites(String? status) = FetchFavoritesEvent;
  @With<_ProcessingStateEmitter>()
  @With<_SuccessfulStateEmitter>()
  @With<_ErrorStateEmitter>()
  @With<_IdleStateEmitter>()
  const factory FavoritesEvent.filterFavorites(String? status) = FilterFavoritesEvent;
  @With<_ProcessingStateEmitter>()
  @With<_SuccessfulStateEmitter>()
  @With<_ErrorStateEmitter>()
  @With<_IdleStateEmitter>()
  const factory FavoritesEvent.addCharacter(CharacterEntity character) = AddFavoriteEvent;
  @With<_ProcessingStateEmitter>()
  @With<_SuccessfulStateEmitter>()
  @With<_ErrorStateEmitter>()
  @With<_IdleStateEmitter>()
  const factory FavoritesEvent.removeCharacter(int id) = RemoveFavoriteEvent;
}

mixin _ProcessingStateEmitter on FavoritesEvent {
  FavoritesState processing({
    required final FavoritesState state,
    final List<CharacterEntity>? favorites,
    final String? sortStatus,
    final String? message,
  }) =>
      FavoritesState.processing(
        message: message ?? 'Processing',
        favorites: favorites ?? state.favorites,
        sortStatus: sortStatus ?? state.sortStatus,
      );
}

mixin _SuccessfulStateEmitter on FavoritesEvent {
  FavoritesState successful({
    required final FavoritesState state,
    required final List<CharacterEntity> favorites,
    final List<CharacterEntity>? filteredFavorites,
    final String? sortStatus,
    final String? message,
  }) =>
      FavoritesState.successful(
        favorites: favorites,
        message: message ?? 'Successful',
        filteredFavorites: filteredFavorites ?? state.filteredFavorites,
        sortStatus: sortStatus ?? state.sortStatus,
      );
}

mixin _ErrorStateEmitter on FavoritesEvent {
  FavoritesState error({
    required final FavoritesState state,
    final List<CharacterEntity>? favorites,
    final List<CharacterEntity>? filteredFavorites,
    final String? sortStatus,
    final String? message,
  }) =>
      FavoritesState.error(
        favorites: favorites ?? state.favorites,
        filteredFavorites: filteredFavorites ?? state.filteredFavorites,
        message: message ?? 'An error has occurred',
        sortStatus: sortStatus ?? state.sortStatus,
      );
}

mixin _IdleStateEmitter on FavoritesEvent {
  FavoritesState idle({
    required final FavoritesState state,
    final String? message,
    final List<CharacterEntity>? filteredFavorites,
  }) =>
      FavoritesState.idle(
        message: message ?? 'Idle',
        favorites: state.favorites,
        filteredFavorites: filteredFavorites ?? state.filteredFavorites,
        sortStatus: state.sortStatus,
      );
}
