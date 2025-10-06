import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

class RefreshWrapper extends StatelessWidget {
/* -------------------------------------------------------------------------- */
  const RefreshWrapper({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);
/* -------------------------------------------------------------------------- */
  final Widget child;
  final Future Function() onRefresh;
/* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
      color: AppTheme.lightGreen,
    );
  }
/* -------------------------------------------------------------------------- */
}
