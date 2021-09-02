class FoodModel {
  String id;
  String idStore;
  String nameManu;
  String quantity;
  String price;
  String images;

  FoodModel(
      {this.id,
      this.idStore,
      this.nameManu,
      this.quantity,
      this.price,
      this.images});

  FoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idStore = json['id_store'];
    nameManu = json['name_manu'];
    quantity = json['quantity'];
    price = json['price'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_store'] = this.idStore;
    data['name_manu'] = this.nameManu;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['images'] = this.images;
    return data;
  }
}
