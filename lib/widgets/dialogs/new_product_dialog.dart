import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                      return "Pole nie może być puste";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                    label: Text("Nazwa"),),
                  onChanged: ((value) => firstInput = value),
                  controller: firstInputController,
                  style: style),
                const SizedBox(height: 30,),
                TextFormField(
                  validator: ((value) {
                    if(value == null || value.isEmpty) {
                      return "Pole nie może być puste";
                    } 
                    if(double.tryParse(value) == null) {
                      return "Podaj liczbę";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                    label: Text("Cena"),),
                  onChanged: ((value) => secondInput = value),
                  controller: secondInputController,
                  style: style,
                ),
                const SizedBox(height: 35,),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  }, 
                  child: Text(selectedDate != null ? DateFormat('dd.MM.yyyy').format(selectedDate!) : "Wybierz datę zakupu", style: style,)),
                if(!isDateSelected)
                  const Text("Nie wybrano daty zakupu", style: TextStyle(color: Colors.red),),
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
                      child: const Text("Zatwierdź")),),)
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
      locale: const Locale("pl", "PL"),
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