import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final texts = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title ?? ""),
      content: Text(widget.description ?? ""),
      actions: [
        OutlinedButton(onPressed: widget.onYesClickAction, child: Text(texts.yes)),
        OutlinedButton(onPressed: widget.onNoClickAction, child: Text(texts.no))
      ],
    );
  }
}