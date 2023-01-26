import 'package:flutter/material.dart';

class TwoInputDialog extends StatelessWidget {
  TwoInputDialog({
    Key? key,
    this.firstLable, 
    required this.firstInput, 
    required this.firstInputMessage, 
    this.secondLable,
    required this.secoundInput,
    required this.secoundInputMessage,
    required this.submitButtonText,
    required this.submitHandler,
    required this.formKey,
    }) : super(key: key);

  final TextEditingController firstInput;
  final String firstInputMessage;
  final TextEditingController secoundInput;
  final String secoundInputMessage;
  final String submitButtonText;
  final VoidCallback submitHandler;
  final GlobalKey<FormState> formKey;
  String? firstLable;
  String? secondLable;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: formKey,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 250,
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text(firstLable ?? ""),
              ),  
              controller: firstInput,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return firstInputMessage;
                }
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(
                label: Text(secondLable ?? "")
              ),
              controller: secoundInput,
              validator: (value) {
                if(double.tryParse(value!) == null || value.isEmpty) {
                  return secoundInputMessage;
                }
              },
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(onPressed: () => submitHandler.call(),  
                  child: Text(submitButtonText)),
              ),
            )
          ]),
        ),
        
      ),
    );
  }
}