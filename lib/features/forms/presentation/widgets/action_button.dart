import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.color,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonWidget = Material(
      shape: const CircleBorder(),
      clipBehavior: .antiAlias,
      color: color ?? theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(
        message: tooltip!,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
