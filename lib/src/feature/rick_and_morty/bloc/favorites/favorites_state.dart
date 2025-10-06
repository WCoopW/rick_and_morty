import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
/* -------------------------------------------------------------------------- */
  const FavoritesState._();
/* -------------------------------------------------------------------------- */
  /// Idling state
  const factory FavoritesState.idle({
    final List<CharacterEntity>? favorites,
    final List<CharacterEntity>? filteredFavorites,
    @Default(null) final String? sortStatus,
    @Default('Idle') final String message,
  }) = IdleFavoritesState;
/* -------------------------------------------------------------------------- */
  /// Processing
  const factory FavoritesState.processing({
    final List<CharacterEntity>? favorites,
    final List<CharacterEntity>? filteredFavorites,
    @Default(null) final String? sortStatus,
    @Default('Processing') final String message,
  }) = ProcessingFavoritesState;
/* -------------------------------------------------------------------------- */
  /// Successful
  const factory FavoritesState.successful({
    required final List<CharacterEntity> favorites,
    final List<CharacterEntity>? filteredFavorites,
    @Default(null) final String? sortStatus,
    @Default('Successful') final String message,
  }) = SuccessfulFavoritesState;
/* -------------------------------------------------------------------------- */
  /// An error has occurred
  const factory FavoritesState.error({
    final List<CharacterEntity>? favorites,
    final List<CharacterEntity>? filteredFavorites,
    @Default(null) final String? sortStatus,
    @Default('An error has occurred') final String message,
  }) = ErrorFavoritesState;
/* -------------------------------------------------------------------------- */
  static const FavoritesState initialState = FavoritesState.idle(
    favorites: <CharacterEntity>[],
    filteredFavorites: <CharacterEntity>[],
    sortStatus: null,
  );
/* -------------------------------------------------------------------------- */
  /// If an error has occurred
  bool get hasError => maybeMap<bool>(
        orElse: () => false,
        error: (_) => true,
      );
/* -------------------------------------------------------------------------- */
  /// Is in progress state
  bool get isProcessing => maybeMap<bool>(
        orElse: () => false,
        processing: (_) => true,
      );
/* -------------------------------------------------------------------------- */
}
