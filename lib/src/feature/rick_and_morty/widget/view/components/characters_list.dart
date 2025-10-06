import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/characters_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/character_card.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/loading_indicator_view.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/loading_view.dart';

/// {@template characters_list}
/// CharactersList widget.
/// {@endtemplate}
class CharactersList extends StatelessWidget {
  /// {@macro characters_list}
  const CharactersList({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    final scope = CharactersScope.of(context, listen: true);
    return scope.characters.isEmpty
        ? SliverFillRemaining(
            hasScrollBody: false,
            child: LoadingView(),
          )
        : SliverList.builder(
            itemCount: scope.characters.length + 1,
            itemBuilder: (context, index) {
              if (index == scope.characters.length) {
                return RepaintBoundary(
                  child: const LoadingIndicatorView(),
                );
              }
              return CharacterCard(
                key: Key(scope.characters[index].id.toString()),
                character: scope.characters[index],
              );
            },
          );
  }
}
