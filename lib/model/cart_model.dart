class CartModel {
  int id;
  String idStore;
  String nameStore;
  String idFood;
  String nameFood;
  String price;
  String amount;
  String sum;

  CartModel(
      {this.id,
      this.idStore,
      this.nameStore,
      this.idFood,
      this.nameFood,
      this.price,
      this.amount,
      this.sum});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idStore = json['idStore'];
    nameStore = json['nameStore'];
    idFood = json['idFood'];
    nameFood = json['nameFood'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idStore'] = this.idStore;
    data['nameStore'] = this.nameStore;
    data['idFood'] = this.idFood;
    data['nameFood'] = this.nameFood;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    return data;
  }
}
