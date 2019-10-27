import 'address.dart';

class Shop {
  String id;
  int shopId = 0;
  String shopKeeper = 'Max';
  String name = 'MyShopName'; 
  String email = 'my_shop@alice.de';
  int phone = 017655378408;
  List<bool> workingDays = [false, false,false,false,false,false,false];
  int workingHours = 8;
  int numOfWorker = 3;
  Address address;
  String imageUrl = 'uml_to_image';
  String shopArt = 'barber';

  Shop({
    this.id,
    this.name,
    this.shopKeeper,
    this.email,
    this.phone,
    this.workingDays,
    this.workingHours,
    this.imageUrl,
    this.numOfWorker,
    this.address,
    this.shopArt,
  });

  Shop.fromMap(Map<String, dynamic> data, String id)
    : this(
        id : id,
        shopKeeper: data['shopKeeper'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        workingDays: data['workingDays'],
        workingHours: data['workingHours'],
        imageUrl: data['imageUrl'],
        numOfWorker: data['numOfWorker'],
        address: data['address'],
        shopArt: data['shopArt'],
      );
}