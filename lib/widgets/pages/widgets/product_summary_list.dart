import 'package:flutter/cupertino.dart';
import 'package:flutter/src/animation/animation.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/product_summary_tile.dart';

class ProductSummaryList extends SelectableList<ProductSummary> {
  ProductSummaryList({
    Key? key, 
    required this.productsSummaries}) : super(
    key: key, 
    onBulkActions: [], 
    noBulkActions: [], 
    data: productsSummaries, 
    listKey: GlobalKey());
    
  final List<ProductSummary> productsSummaries;

  @override
  Widget buildChildren(SelectableItem<ProductSummary> productSummary, Animation<double> animation) {
    return ProductSummaryTile(
      productSummary: productSummary,
    );
  }

  @override
  Widget buildFilter(BuildContext context, Function(List<SelectableItem<ProductSummary>> p1) setStateOverride) {
    // TODO: implement buildFilter
    return Container();
  }
}

// Jakaś ikonka ---> Nazwa productu ---> jeżeli zaznacze ikonka V
// Divider
// Z dnia ----> Z dnia
// Cena   ----> Cena
// Inflacja