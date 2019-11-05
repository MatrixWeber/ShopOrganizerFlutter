import 'package:shop_organizer/entities/shop.dart';
import 'package:shop_organizer/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseCloud {
  Future<void> add(String collection, String id, Map<String, dynamic> map);
  Future<void> addShop(Shop shop);
  Future<User> getUser();
  Future<Shop> getShop();
}

class Cloud implements BaseCloud {
  final Firestore fire = Firestore.instance;

  @override
  Future<void> add(String collection, String id, Map<String, dynamic> map) async {
    await fire.collection(collection).document(id).setData(map);
  }

  @override
  Future<void> addShop(Shop shop) async {
    await fire.collection('shops').document().setData({ 'shop' : shop });
  }

  @override
  Future<User> getUser()
  {
    // final User user = await fire.collection('users').document().getData();
    // return user;
  }

  @override
  Future<Shop> getShop()
  {
    // final User user = await fire.collection('users').document().getData();
    // return user;
  }
}