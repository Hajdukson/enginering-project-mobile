import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({required this.dialogContent});
  final List<Widget> dialogContent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 300,
        width: 300,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.blueGrey
              ),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Icon(Icons.question_mark, 
                  color: Colors.black,
                  size: 30,
                  ),),),
            ...dialogContent,
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(const Size(120, 30)),
                      elevation: MaterialStateProperty.all<double>(5),
                      backgroundColor: MaterialStateProperty.all<Color>((Colors.blueGrey)),
                      shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))
                      ),
                    child: const Text("Zamknij"),
                    onPressed: () => Navigator.of(context).pop(),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}