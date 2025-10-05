import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

part 'characters_state.freezed.dart';

@freezed
class CharactersState with _$CharactersState {
  /* -------------------------------------------------------------------------- */
  const CharactersState._();
/* -------------------------------------------------------------------------- */
  /// Idling state
  const factory CharactersState.idle({
    final List<CharacterEntity>? characters,
    required final bool endOfList,
    @Default('Idle') final String message,
  }) = IdleCharactersState;
/* -------------------------------------------------------------------------- */
  /// Processing
  const factory CharactersState.processing({
    final List<CharacterEntity>? characters,
    required final bool endOfList,
    @Default('Processing') final String message,
  }) = ProcessingCharactersState;
/* -------------------------------------------------------------------------- */
  /// Successful
  const factory CharactersState.successful({
    required final List<CharacterEntity> characters,
    required final bool endOfList,
    @Default('Successful') final String message,
  }) = SuccessfulCharactersState;
/* -------------------------------------------------------------------------- */
  /// An error has occurred
  const factory CharactersState.error({
    final List<CharacterEntity>? characters,
    required final bool endOfList,
    @Default('An error has occurred') final String message,
  }) = ErrorCharactersState;
/* -------------------------------------------------------------------------- */
  static const CharactersState initialState = CharactersState.idle(
    characters: <CharacterEntity>[],
    endOfList: false,
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
  bool get hasMore => !endOfList;
/* -------------------------------------------------------------------------- */
}
