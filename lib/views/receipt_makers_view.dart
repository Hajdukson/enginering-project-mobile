import 'package:flutter/material.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';
import 'package:money_manager_mobile/views/camera_access.dart';
import 'package:money_manager_mobile/views/receipt_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiptMakersView extends StatefulWidget {
  const ReceiptMakersView({Key? key}) : super(key: key);

  @override
  State<ReceiptMakersView> createState() => _ReceiptMakersViewState();
}

class _ReceiptMakersViewState extends State<ReceiptMakersView> {
  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
          child: Column(
            children: [
              TabBar(
                labelStyle: Theme.of(context).textTheme.labelSmall,
                labelColor: Theme.of(context).primaryColorDark,
                indicatorColor: Colors.amber, 
                tabs: [
                  Tab(text: texts.analizeReceipt),
                  Tab(text: texts.addReceipt),
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