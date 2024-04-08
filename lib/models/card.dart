class CardModel {
  String cardId;
  String term;
  String define;

  CardModel(this.cardId, this.term, this.define);

  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<CardModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => CardModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static CardModel fromMap(Map<String, dynamic> map) {
    return CardModel(
      map['cardId'], // Lấy giá trị cardId từ map
      map['term'], // Lấy giá trị term từ map
      map['define'], // Lấy giá trị define từ map
    );
  }

  // Phương thức tạo một Map từ đối tượng CardModel
  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'term': term,
      'define': define,
    };
  }

  // Phương thức chuyển đổi từ List<CardModel> sang List<Map<String, dynamic>>
  List<Map<String, dynamic>> cardsToMapList(List<CardModel> cards) {
    return cards.map((card) => card.toMap()).toList();
  }
}
