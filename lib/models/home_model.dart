class HomeModel {
  late bool status;
  late HomeDataModel data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductsModel> products = [];
  // late String? ad;

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    // ad = json['ad'];
    json['banners'].forEach((element) {
      banners.add(BannerModel(id: element['id'], image: element['image']));
    });
    json['products'].forEach((element) {
      products.add(ProductsModel(
          id: element['id'],
          name: element['name'],
          description: element['description'],
          discount: element['discount'],
          images: element['images'],
          inCart: element['in_cart'],
          inFavorites: element['in_favorites'],
          oldPrice: element['old_price'],
          price: element['price'],
          image: element['image']));
    });
  }
}

class BannerModel {
  late int id;
  late String image;

  BannerModel({required this.id, required this.image});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late dynamic image;
  late String name;
  late String description;
  late List<dynamic> images;
  late dynamic inFavorites;
  late bool inCart;

  ProductsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.discount,
    required this.images,
    required this.inCart,
    required this.inFavorites,
    required this.oldPrice,
    required this.price,
    required this.image,
  });

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
