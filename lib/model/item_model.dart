class ItemModel {
  final String name;
  final String img;
  final String value;
  final String sound;
  bool accepting;

  ItemModel(
      {required this.name,
      required this.img,
      required this.value,
      required this.sound,
      this.accepting = false});
}
