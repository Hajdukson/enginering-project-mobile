import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog(this.icon, {Key? key, required this.dialogContent, required this.height, required this.width}) : super(key: key);
  final List<Widget> dialogContent;
  final double height;
  final double width;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.blueGrey
              ),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Icon(icon, 
                  color: Colors.white,
                  size: 30,
                  ),),),
            ...dialogContent,
            Align(
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
                  child: const Text("Zamknij", style: TextStyle(color: Colors.white),),
                  onPressed: () => Navigator.of(context).pop(),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}