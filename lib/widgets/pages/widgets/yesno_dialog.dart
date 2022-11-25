import 'package:flutter/material.dart';

class YesNoDialog extends StatefulWidget {
  final String? title;
  final String? description;
  final Function()? onYesClickAction;
  final Function()? onNoClickAction;

  const YesNoDialog({
    Key? key, 
    this.title, 
    this.description, 
    this.onNoClickAction, 
    this.onYesClickAction}) : super(key: key);

  @override
  State<YesNoDialog> createState() => _YesNoDialogState();
}

class _YesNoDialogState extends State<YesNoDialog> 
    with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ""),
      content: Text(widget.description ?? ""),
      actions: [
        OutlinedButton(onPressed: widget.onYesClickAction, child: const Text("Yes")),
        OutlinedButton(onPressed: widget.onNoClickAction, child: const Text("No"))
      ],
    );
  }
}