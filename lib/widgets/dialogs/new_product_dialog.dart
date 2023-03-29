import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewProductDialog extends StatefulWidget {
  const NewProductDialog({Key? key, required this.addProductCall}) : super(key: key);
  final Function(String, String, DateTime) addProductCall;

  @override
  State<NewProductDialog> createState() => _NewProductDialogState();
}

class _NewProductDialogState extends State<NewProductDialog> {
  DateTime? selectedDate;
  String? firstInput;
  String? secondInput;
  bool isDateSelected = true;
  late final texts = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      fontSize: 16,);

    final formKey = GlobalKey<FormState>();
    final firstInputController = TextEditingController(text: firstInput);
    final secondInputController = TextEditingController(text: secondInput);

    return Dialog(
      child: SizedBox(
        height: 360,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: ((value) {
                    if(value == null || value.isEmpty) {
                      return texts.fieldCannotBeEmpty;
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    label: Text(texts.name),),
                  onChanged: ((value) => firstInput = value),
                  controller: firstInputController,
                  style: style),
                const SizedBox(height: 30,),
                TextFormField(
                  validator: ((value) {
                    if(value == null || value.isEmpty) {
                      return texts.fieldCannotBeEmpty;
                    } 
                    if(double.tryParse(value) == null) {
                      return texts.enterPrice;
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    label: Text(texts.price),),
                  onChanged: ((value) => secondInput = value),
                  controller: secondInputController,
                  style: style,
                ),
                const SizedBox(height: 35,),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  }, 
                  child: Text(selectedDate != null ? DateFormat('dd.MM.yyyy').format(selectedDate!) : texts.selectBoughtDate, style: style,)),
                if(!isDateSelected)
                  Text(texts.dateNotSelected, style: const TextStyle(color: Colors.red),),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: () {
                        if(formKey.currentState!.validate()) {
                          if(selectedDate == null) {
                            isDateSelected = false;
                            setState(() { });
                          } else {
                            widget.addProductCall(firstInputController.text, secondInputController.text, selectedDate!);
                          }
                        }
                      },  
                      child: Text(texts.submit)),),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      isDateSelected = true;
      selectedDate = picked;
      setState(() { });
    }
  }
}