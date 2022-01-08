class FavoritesModel {
  late bool status;
  late Data data;

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  late int currentPage;
  late List<DataFavorites> data;
  late String firstPageUrl;
  late dynamic from;
  late int lastPage;
  late String lastPageUrl;
  late dynamic nextPageUrl;
  late String path;
  late int perPage;
  late dynamic prevPageUrl;
  late dynamic to;
  late int total;

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    data = <DataFavorites>[];
    json['data'].forEach((v) {
      data.add(DataFavorites.fromJson(v));
    });
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class DataFavorites {
  late int id;
  late Product product;

  DataFavorites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = Product.fromJson(json['product']);
  }
}

class Product {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late String description;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
