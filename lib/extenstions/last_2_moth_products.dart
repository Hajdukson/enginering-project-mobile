import 'package:money_manager_mobile/models/bought_product.dart';

extension Last2MonthProducts on List<BoughtProduct> {
  List<BoughtProduct> getProductFromLast2Month(int month, int year) {
    month = month + 1;
    // Just makeing sure, that list is sorted
    sort((first, next) => first.boughtDate!.compareTo(next.boughtDate!));
    var productsUpToChoosenMonth = where((product) => 
      product.boughtDate!.isBefore(DateTime(year, month)) && 
      product.boughtDate!.isAfter(DateTime(year, month - 2)));
    return productsUpToChoosenMonth.toList();
  }  
}