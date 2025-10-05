import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/characters_state.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

part 'characters_event.freezed.dart';

@freezed
class CharactersEvent with _$CharactersEvent {
  const CharactersEvent._();

  @With<_ProcessingStateEmitter>()
  @With<_SuccessfulStateEmitter>()
  @With<_ErrorStateEmitter>()
  @With<_IdleStateEmitter>()
  const factory CharactersEvent.fetchCharacters(int page) = FetchCharactersEvent;
}

mixin _ProcessingStateEmitter on CharactersEvent {
  CharactersState processing({
    required final CharactersState state,
    final List<CharacterEntity>? characters,
    final String? message,
  }) =>
      CharactersState.processing(
        message: message ?? 'Processing',
        characters: characters ?? state.characters,
        endOfList: state.endOfList,
      );
}

mixin _SuccessfulStateEmitter on CharactersEvent {
  CharactersState successful({
    required final CharactersState state,
    required final List<CharacterEntity> characters,
    required final bool endOfList,
    final String? message,
  }) =>
      CharactersState.successful(
        characters: characters,
        message: message ?? 'Successful',
        endOfList: state.endOfList,
      );
}

mixin _ErrorStateEmitter on CharactersEvent {
  CharactersState error({
    required final CharactersState state,
    final List<CharacterEntity>? characters,
    final String? message,
  }) =>
      CharactersState.error(
        characters: characters ?? state.characters,
        message: message ?? 'An error has occurred',
        endOfList: state.endOfList,
      );
}

mixin _IdleStateEmitter on CharactersEvent {
  CharactersState idle({
    required final CharactersState state,
    final String? message,
  }) =>
      CharactersState.idle(
        message: message ?? 'Idle',
        characters: state.characters,
        endOfList: state.endOfList,
      );
}
