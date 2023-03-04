import 'package:flutter/material.dart';

class NewProductDialog extends StatefulWidget {
  const NewProductDialog({Key? key, required this.addProductCall}) : super(key: key);
  final Function(String, String, DateTime) addProductCall;

  @override
  State<NewProductDialog> createState() => _NewProductDialogState();
}

class _NewProductDialogState extends State<NewProductDialog> {
  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      fontSize: 20,);

    final formKey = GlobalKey<FormState>();
    final firstInputController = TextEditingController();
    final secondInputController = TextEditingController();

    return Dialog(
      child: SizedBox(
        height: 320,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Nazwa"),),
                  controller: firstInputController,
                  style: style),
                const SizedBox(height: 30,),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Cena"),),
                  controller: secondInputController,
                  style: style,
                ),
                const SizedBox(height: 30,),
                TextButton(
                  onPressed: () => _selectDate(context), 
                  child: Text("Wybierz date", style: style,)),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: () {
                        if(formKey.currentState!.validate()) {
                          widget.addProductCall(firstInputController.text, secondInputController.text, selectedDate);
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
      selectedDate = picked;
      setState(() { });
    }
  }
}