import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/widgets/dialogs/two_input_dialog.dart';

class DateInputDialog extends StatefulWidget {
  DateInputDialog({Key? key, 
    required this.formKey,
    required this.textInputLabel, 
    required this.submit
    }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final String textInputLabel;
  final void Function() submit;


  @override
  State<DateInputDialog> createState() => DateInputDialogState();
}

class DateInputDialogState extends State<DateInputDialog> {
  DateTime? selectedDate;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TwoInputDialog(
      formKey: widget.formKey, 
      submitHandler: widget.submit, 
      firstInput: buildFirstInput, 
      secondInput: buildScundInput);
  }

  Widget get buildScundInput => TextButton(
    onPressed: () => _selectDate(context), 
    child: Text(selectedDate == null ? "Wybierz date" : DateFormat.yMMMMd("pl").format(selectedDate!), style: const TextStyle(fontSize: 20),),);

  Widget get buildFirstInput => TextFormField(
    controller: textController,
    decoration: InputDecoration(
      label: Text(widget.textInputLabel),
    ),
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("pl", "PL"),
      initialDate: DateTime.now(), 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      selectedDate = picked;
      setState(() { });
    }
  }
}