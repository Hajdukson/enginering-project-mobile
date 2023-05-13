import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/widgets/dialogs/two_input_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateInputDialog extends StatefulWidget {
  DateInputDialog({Key? key, 
    required this.formKey,
    required this.textInputLabel, 
    required this.submit,
    required this.typableFieldValidator,
    this.initialDate,
    this.initialText
    }) : super(key: key);

  DateTime? initialDate;
  String? initialText;
  String? Function(String?) typableFieldValidator;
  final GlobalKey<FormState> formKey;
  final String textInputLabel;
  final Future<void> Function() submit;

  @override
  State<DateInputDialog> createState() => DateInputDialogState();
}

class DateInputDialogState extends State<DateInputDialog> {
  DateTime? selectedDate;
  String? typableValue;
  bool isDateSelected = true;
  final textController = TextEditingController();
  late final texts = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    textController.text = widget.initialText ?? "";
    return TwoInputDialog(
      formKey: widget.formKey, 
      submitHandler: () async {
        if(widget.formKey.currentState!.validate() && selectedDate != null) {
          await widget.submit();
          return;
        }
        isDateSelected = false;
        setState(() {});
      },
      firstInput: buildFirstInput(), 
      secondInput: buildSecondInput());
  }

  Widget buildSecondInput()  {
    const textStyle = TextStyle(fontSize: 20);
    if(widget.initialDate != null){
      selectedDate = widget.initialDate;
    }
    return Column(
      children: [
        TextButton(
          onPressed: () => _selectDate(context), 
          child: Text(selectedDate == null ? texts.selectDate : DateFormat("yMMMMd", Platform.localeName).format(selectedDate!), style: textStyle,),),
        if(!isDateSelected)
          Text(texts.dateNotSelected, style: const TextStyle(color: Colors.red),),
      ],
    );}

  Widget buildFirstInput() {
    return TextFormField(
      controller: textController,
      onChanged: (value) => textController.text = value,
      validator: widget.typableFieldValidator,
      decoration: InputDecoration(
        label: Text(widget.textInputLabel),
        ),
      );
  }

  Future<void> _selectDate(BuildContext context) async {
    widget.initialDate = null;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      selectedDate = picked;
      isDateSelected = true;
      setState(() { });
    }
  }
}