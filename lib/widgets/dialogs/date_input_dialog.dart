import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/widgets/dialogs/two_input_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateInputDialog extends StatefulWidget {
  DateInputDialog({Key? key, 
    required this.formKey,
    required this.textInputLabel, 
    required this.submit,
    this.initialDate,
    this.initialText
    }) : super(key: key);

  DateTime? initialDate;
  String? initialText;
  final GlobalKey<FormState> formKey;
  final String textInputLabel;
  final void Function() submit;

  @override
  State<DateInputDialog> createState() => DateInputDialogState();
}

class DateInputDialogState extends State<DateInputDialog> {
  DateTime? selectedDate;
  final textController = TextEditingController();
  late final texts = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    textController.text = widget.initialText ?? "";
    return TwoInputDialog(
      formKey: widget.formKey, 
      submitHandler: widget.submit, 
      firstInput: buildFirstInput, 
      secondInput: buildScundInput());
  }

  Widget buildScundInput()  {
    const textStyle = TextStyle(fontSize: 20);
    if(widget.initialDate != null){
      selectedDate = widget.initialDate;
    }
    return TextButton(
      onPressed: () => _selectDate(context), 
      child: Text(selectedDate == null ? texts.selectDate : DateFormat.yMMMMd("pl").format(selectedDate!), style: textStyle,),);}

  Widget get buildFirstInput => TextFormField(
    controller: textController,
    decoration: InputDecoration(
      label: Text(widget.textInputLabel),
    ),
  );

  Future<void> _selectDate(BuildContext context) async {
    widget.initialDate = null;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      selectedDate = picked;
      setState(() { });
    }
  }
}