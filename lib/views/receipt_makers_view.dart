import 'package:flutter/material.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';
import 'package:money_manager_mobile/views/camera_access.dart';
import 'package:money_manager_mobile/views/receipt_view.dart';

class ReceiptMakersView extends StatefulWidget {
  const ReceiptMakersView({Key? key}) : super(key: key);

  @override
  State<ReceiptMakersView> createState() => _ReceiptMakersViewState();
}

class _ReceiptMakersViewState extends State<ReceiptMakersView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: Colors.amber, 
                tabs: [
                  Tab(text: "Skanuj paragon"),
                  Tab(text: "Stwórz paragon"),
                ]),
              Expanded(
                child: TabBarView(
                  children: [
                    CameraAccess(camera: FlavorConfig.instance.values.camera,),
                    ReceiptView(recipt: [],),
                  ],
                ))
            ],
          )
      ),
    );
  }
}