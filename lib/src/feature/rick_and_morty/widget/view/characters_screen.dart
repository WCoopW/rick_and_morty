import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/characters_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/characters_list.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/error_view.dart';

/// {@template characters_screen}
/// CharactersScreen displays a list of characters with lazy loading.
/// {@endtemplate}
class CharactersScreen extends StatefulWidget {
  /// {@macro characters_screen}
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  @override
  Widget build(BuildContext context) {
    final scope = CharactersScope.of(context, listen: true);
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async => scope.refreshCharacters(),
      child: CustomScrollView(
        controller: scope.scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: MediaQuery.sizeOf(context).height > 600,
            floating: true,
            snap: true,
            title: const Text(
              'Rick and Morty',
            ),
          ),
          if (scope.state.hasError && scope.state.characters?.isEmpty == true)
            SliverFillRemaining(
              hasScrollBody: false,
              child: ErrorView(
                message: scope.state.message ?? 'Error with fetching characters',
                onRetry: scope.fetchCharacters,
              ),
            ),
          if (scope.state.characters?.isNotEmpty == true) CharactersList(),
        ],
      ),
    ));
  }
}
