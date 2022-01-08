class CategoriesModel {
  late bool status;
  late CategoriesDataModel data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  late int? currentPage;
  List<DataModel> data = [];

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((e) {
      data.add(DataModel(
        name: e['name'],
        image: e['image'],
        id: e['id'],
      ));
    });
  }
}

class DataModel {
  late int? id;
  late String? name;
  late String? image;

  DataModel({
    required this.id,
    required this.image,
    required this.name,
  });

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
