import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/product_summary_tile.dart';

class ProductSummaryList extends SelectableList<ProductSummary> {
  ProductSummaryList({
    Key? key, 
    required this.productsSummaries,
    required this.filterHandler,
    }) : super(
    key: key, 
    onBulkActions: [], 
    noBulkActions: [],
    noItemSelectedVoidCallBack: () => print("navigate"),
    data: productsSummaries, 
    listKey: GlobalKey());
    
  final List<ProductSummary> productsSummaries;
  final void Function(String, DateTimeRange?, GlobalKey<FormState>) filterHandler;

  @override
  Widget buildChildren(SelectableItem<ProductSummary> product, Animation<double> animation) {
    return ProductSummaryTile(
      productSummary: product,
    );
  }

  @override
  Widget buildFilter(BuildContext context, Function(List<SelectableItem<ProductSummary>>) setStateOverride) {
    final textController = TextEditingController();
    DateTimeRange? selectedDates;
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
              labelText: 'Nazwa product',),
            ),
            ElevatedButton(
              onPressed: () async { 
                selectedDates = await _showDateRange(context); }, child: const Text("Wybierz date") ),
            ElevatedButton(onPressed: () => filterHandler(textController.text, selectedDates, formKey), child: Text("Filtruj"))
          ],
        )),
    );
  }

  Future<DateTimeRange?> _showDateRange(BuildContext context) async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context, 
      locale: const Locale("pl", "PL"),
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    return dateTimeRange;
  }
}