import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/tiles/bought_product_tile.dart';
import 'package:money_manager_mobile/models/eunums/sorting.dart';

class DetailsProductList extends SelectableList<BoughtProduct> {
  DetailsProductList({
    Key? key, 
    required this.boughtProducts, 
    required this.setChildState,
    required List<ActionButton> onBulkActions,
    required List<ActionButton> noBulkActions,
    required this.editProduct
    }) : 
    super(
      key: key, 
      isPage: true,
      data: boughtProducts, 
      onBulkActions: onBulkActions,
      noBulkActions: noBulkActions);

  final List<SelectableItem<BoughtProduct>> boughtProducts;
  final void Function(dynamic) setChildState;
  final void Function(BoughtProduct boughtProduct) editProduct;

  SortDate? sortDate;
  SortPrice? sortPrice;
  DateTimeRange? filterDates;
  String? price;
  bool disableFilter = false;
  bool keepExpanded = false;
  
  @override
  Widget buildChildren(SelectableItem<BoughtProduct> product, Animation<double> animation) {
    return BoughtProductTail(
      trailingButton: IconButton(onPressed: () => editProduct(product.data), icon: const Icon(Icons.edit),),
      product: product, 
      animation: animation, 
      showDate: true,);
  }

  @override
  Widget buildFilter(BuildContext context, Function(List<SelectableItem<BoughtProduct>> p1) setStateOverride) {
    final expandableControler = ExpandableController(
      initialExpanded: keepExpanded);
    final textController = TextEditingController(text: price);
    textController.selection = TextSelection.collapsed(offset: textController.text.length);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<Enum?>(
                initialValue: null,
                onSelected: (value) {
                  if(value is SortDate) {
                    sortDate = value;
                    if(sortDate == SortDate.descending) {
                      selectableItems.sort((first, next) => next.data.boughtDate!.compareTo(first.data.boughtDate!));
                      setStateOverride(selectableItems);
                    } else if(sortDate == SortDate.ascending) {
                      selectableItems.sort((first, next) => first.data.boughtDate!.compareTo(next.data.boughtDate!));
                      setStateOverride(selectableItems);
                    }
                   }

                  if(value is SortPrice) {
                    sortPrice = value;
                    if(sortPrice == SortPrice.descending){
                      selectableItems.sort((first, next) => next.data.price!.compareTo(first.data.price!));
                      setStateOverride(selectableItems);
                    } else if(sortPrice == SortPrice.ascending) {
                      selectableItems.sort((first, next) => first.data.price!.compareTo(next.data.price!));
                      setStateOverride(selectableItems);
                    }
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(value: SortPrice.ascending, child: Text("Cena rosnąco"),),
                    PopupMenuItem(value: SortPrice.descending, child: Text("Cena malejąco"),),
                    PopupMenuItem(value: SortDate.ascending, child: Text("Data rosnąco"),),
                    PopupMenuItem(value: SortDate.descending, child: Text("Data malejąco"),),
                  ];
                },
                child: const Text("Sortowanie", style: TextStyle(fontSize: 20),),),
              TextButton(
                onPressed: () {
                  expandableControler.toggle();
                }, 
                child: Row(
                  children: [
                    Icon(Icons.filter_alt, color: Theme.of(context).primaryColorDark,),
                    Text("Filtrowanie", style: Theme.of(context).textTheme.titleMedium,), 
                  ],
              ))
            ],
          ),
          ExpandableNotifier(
            controller: expandableControler,
            child: ExpandablePanel(
              controller: expandableControler,
              collapsed: Container(),
              expanded: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Cena"),
                      ),
                      onChanged: (value) {
                        var patter = RegExp(r',|-');

                        if(value.contains(patter)) {
                          disableFilter = true;
                          setChildState(disableFilter);
                        } else if(disableFilter == true){
                          disableFilter = false;
                          setChildState(disableFilter);
                        }
                        keepExpanded = true;
                        price = value;
                      },
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(onPressed: () async => setChildState(filterDates = await _showDateRange(context)),
                      child: Text(filterDates == null ? "Wybierz date" : "${DateFormat("dd.MM.yyyy").format(filterDates!.start)} - ${DateFormat("dd.MM.yyyy").format(filterDates!.end)}"),
                    ),
                    const SizedBox(width: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Resetuj filtry",
                          child: ElevatedButton(onPressed:  () => setStateOverride(_resetFilters()), 
                            child: const Icon(Icons.refresh)),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: disableFilter ? null : () => setStateOverride(_runFilter(filterDates, price)), 
                          child: const Text("Filtruj")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        )]),
      );
  }

  List<SelectableItem<BoughtProduct>> _resetFilters() {
    keepExpanded = false;
    filterDates = null;
    price = null;
    setChildState(disableFilter = false);
    return selectableItems;
  }

  List<SelectableItem<BoughtProduct>> _runFilter(DateTimeRange? dates, String? price) {
    List<SelectableItem<BoughtProduct>> result = selectableItems;
    keepExpanded = false;

    if(dates != null) {
      result = result
        .where((item) => (item.data.boughtDate!.isAfter(dates.start) 
          && item.data.boughtDate!.isBefore(dates.end)) 
          || item.data.boughtDate!.isAtSameMomentAs(dates.start)
          || item.data.boughtDate!.isAtSameMomentAs(dates.end))
        .toList();
    }

    if(price != null) {
      result = result
        .where((item) => item.data.price.toString().contains(price) 
          || item.data.price == double.parse(price))
        .toList();
    }

    return result;
  }

  Future<DateTimeRange?> _showDateRange(BuildContext context) async {
    keepExpanded = true;
    DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context, 
      locale: const Locale("pl", "PL"),
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    return dateTimeRange;
  }
}