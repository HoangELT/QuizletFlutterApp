class CardModel {
  String term;
  String define;

  CardModel(this.term, this.define);

  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<CardModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => CardModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static CardModel fromMap(Map<String, dynamic> map) {
    return CardModel(
      map['term'],
      map['define'],
    );
  }
}
