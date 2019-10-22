import 'address.dart';

class Shop {
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
}