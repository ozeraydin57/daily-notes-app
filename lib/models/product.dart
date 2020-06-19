class Product {
  int id;
  String name;
  String description;
  String date;
  int done;
  int active;

  Product({this.name, this.description, this.date, this.done, this.active});
  Product.withId({this.id, this.name, this.description, this.date, this.done, this.active});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["date"] = date;
    map["done"] = done;
    map["active"] = active;

    if (id != null) map["id"] = id;

    return map;
  }

  Product.fromObject(dynamic o) {
    this.id = int.tryParse(o["id"].toString());
    this.name = o["name"];
    this.description = o["description"];
    this.date = o["date"];
    this.done = int.parse(o["done"].toString());
    this.active = int.parse(o["active"].toString());
  }
}
