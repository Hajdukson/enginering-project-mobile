import 'package:uuid/uuid.dart';

class SelectableItem<T> {
  String keyHelper = Uuid().v1();
  bool isSelected = false;
  T data;
  SelectableItem(this.data);
}