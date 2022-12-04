import 'package:flutter/material.dart';

class TwoInputDialog extends StatelessWidget {
  const TwoInputDialog({
    required Key key, 
    required this.firstInput, 
    required this.firstInputMessage, 
    required this.secoundInput,
    required this.secoundInputMessage,
    required this.submitButtonText,
    required this.submitHandler
    }) : super(key: key);
  final TextEditingController firstInput;
  final String firstInputMessage;
  final TextEditingController secoundInput;
  final String secoundInputMessage;
  final String submitButtonText;
  final VoidCallback submitHandler;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: key,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 200,
          child: Column(children: [
            TextFormField(  
              controller: firstInput,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return firstInputMessage;
                }
              },
            ),
            TextFormField(
              controller: secoundInput,
              validator: (value) {
                if(double.tryParse(value!) == null || value.isEmpty) {
                  return secoundInputMessage;
                }
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () => submitHandler.call(),  
              child: Text(submitButtonText))
          ]),
        ),
        
      ),
    );
  }
}