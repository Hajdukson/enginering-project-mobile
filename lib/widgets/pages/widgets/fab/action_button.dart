import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip
  });

  final void Function()? onPressed;
  final Widget icon;
  final String? tooltip;
  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>{

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.blue,
      elevation: 4.0,
      child: IconButton(
        onPressed: widget.onPressed,
        icon: widget.icon,
        color: Colors.white,
        tooltip: widget.tooltip,
      ),
    );
  }
}