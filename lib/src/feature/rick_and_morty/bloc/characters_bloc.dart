import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/src/core/network/exceptions/network_exceptions.dart';
import 'package:rick_and_morty/src/core/network/utils/error_handler.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/characters_event.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/bloc/characters_state.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/i_characters_repository.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState>
    implements EventSink<CharactersEvent> {
  final ICharactersRepository repository;

  CharactersBloc({
    required this.repository,
    CharactersState initialState = const CharactersState.idle(endOfList: false),
  }) : super(initialState) {
    on<CharactersEvent>(
      (event, emit) => event.map(
        fetchCharacters: (event) => _fetchCharacters(event, emit),
      ),
    );
  }

  _fetchCharacters(FetchCharactersEvent event, Emitter<CharactersState> emit) async {
    try {
      // Get current characters list
      final currentCharacters = state.characters ?? <CharacterEntity>[];

      emit(event.processing(
        state: state,
        characters: currentCharacters,
      ));

      final result = await repository.getCharactersByPage(event.page);

      // Combine existing characters with new ones
      final allCharacters = [...currentCharacters, ...result.characters];

      emit(event.successful(
        state: state,
        characters: allCharacters,
        endOfList: result.lastPage == event.page,
      ));
    } on NetworkException catch (e) {
      NetworkErrorHandler.logError(e, 'CharactersBloc._fetchCharacters');
      final userMessage = NetworkErrorHandler.getUserFriendlyMessage(e);
      emit(event.error(
        state: state,
        characters: state.characters,
        message: userMessage,
      ));
    } on Object catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleException(e, stackTrace);
      NetworkErrorHandler.logError(networkException, 'CharactersBloc._fetchCharacters');

      emit(event.error(
        state: state,
        characters: state.characters,
        message: 'Произошла неожиданная ошибка',
      ));
    }
  }
}
