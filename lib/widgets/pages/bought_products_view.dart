import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import '../generics/models/selectable_item_.dart';
import '../generics/selectable_list.dart';

// class BoughtProductsView extends StatefulWidget {
//   BoughtProductsView({Key? key, required this.child}) : super(key: key);

//   final SelectableList child;
//   @override
//   State<BoughtProductsView> createState() => BoughtProductsViewState();
// }

// class BoughtProductsViewState extends State<BoughtProductsView> {
//   List<SelectableItem<BoughtProduct>> searchableBoughtProducts = [];
//   late final GlobalKey<SelectableListState> _globalKey;

//   @override
//   void initState() {
//     super.initState();
//     _globalKey = widget.child.key as GlobalKey<SelectableListState>;
//   }
//   @override
//   Widget build(BuildContext context) {    
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           margin: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Expanded(
//                 child: widget.child,
//               ),
            
//             ]
//           ),
//         ),
//       ),
//     );
//   }
// }


        // ElevatedButton(onPressed: () {
        //   final globalKey = widget.child.key as GlobalKey<SelectableListState>;
        //   List<SelectableItem<BoughtProduct>> boughtProducts = [];
        //   if(globalKey.currentState != null){
        //     if(globalKey.currentState?.widget.selectableItems.any((element) => element.isSelected) == true){
        //       boughtProducts = globalKey.currentState?.widget.selectableItems.where((element) => element.isSelected).toList() as List<SelectableItem<BoughtProduct>>;
        //       globalKey.currentState?.widget.selectableItems.removeWhere((element) => element.isSelected);
        //       globalKey.currentState?.setState(() { });
        //     }
        //   }
        //   print(boughtProducts.length);
          
        // }, child: Text("Delete"))

        //  onPressed: () {
        //                           setDialogValues(index);
        //                           showDialog(
        //                               context: context,
        //                               builder: (context) {
        //                                 return Dialog(
        //                                   child: Container(
        //                                     height: 300,
        //                                     width: 200,
        //                                     child: Expanded(
        //                                         child: Container(
        //                                           margin: EdgeInsets.all(10),
        //                                           child: Column(
        //                                             mainAxisAlignment: MainAxisAlignment.center,
        //                                             children: [
        //                                               Form(
        //                                                 key: formKey,
        //                                                 child: Column(
        //                                                   children: [
        //                                                     TextFormField(
        //                                                       controller: nameController,
        //                                                       validator: (value) {
        //                                                         if(value == null || value.isEmpty) {
        //                                                           return "Enter valid name";
        //                                                         }
        //                                                       },
        //                                                     ),
        //                                                     TextFormField(
        //                                                       decoration: InputDecoration(
                                                                
        //                                                       ),
        //                                                       controller: priceController,
        //                                                       validator: (value) {
        //                                                         if(value == null || value.isEmpty || double.tryParse(value) == null) {
        //                                                           return "Enter valid price";
        //                                                         }
        //                                                       },
        //                                                     ),
        //                                                     SizedBox(height: 30,),
        //                                                     ElevatedButton(onPressed: () {
        //                                                       if(formKey.currentState!.validate()) {
        //                                                         setState(() {
        //                                                           searchableBoughtProducts[index].data.name = nameController.text; 
        //                                                           searchableBoughtProducts[index].data.price = double.tryParse(priceController.text); 
        //                                                         });
        //                                                         Navigator.of(context).pop();
        //                                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edited sucded")));
        //                                                       }
        //                                                     }, child: Text("Submit"))
        //                                                 ],
        //                                               ),
        //                                             )
        //                                         ],
        //                                       ),
        //                                     )
        //                                   ),
        //                                 ),
        //                               );
        //                             }
        //                           );
        //                         },