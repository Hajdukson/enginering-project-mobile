import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TwoInputDialog extends StatelessWidget {
  TwoInputDialog({
    Key? key,
    required this.formKey,
    required this.submitHandler,
    required this.firstInput,
    required this.secondInput
    }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final VoidCallback submitHandler;
  final Widget firstInput;
  final Widget secondInput;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    
    return Dialog(
      child: Form(
        key: formKey,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 250,
          child: Column(children: [
            firstInput,
            const SizedBox(height: 20,),
            secondInput,
            const SizedBox(height: 20,),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(onPressed: () => submitHandler.call(),  
                  child: Text(texts.submit)),
              ),
            )
          ]),
        ),
      ),
    );
  }
}