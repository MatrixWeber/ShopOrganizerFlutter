class User {
  String name = 'Mustermann';
  String firstName = 'Max';
  String email = 'max.mustermann@gmail.com';
  int phone = 017655378408;
  bool isAdmin = false;
  bool isClient = false;
  String imageUrl = 'uml_to_image';
  String uid = 'uid';

  User({
    this.name,
    this.firstName,
    this.email,
    this.phone,
    this.isAdmin,
    this.isClient,
    this.imageUrl,
    this.uid,
  });

  User.fromMap(Map<String, dynamic> data)
      : this(
          firstName: data['firstName'],
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
          isAdmin: data['isAdmin'],
          isClient: data['isClient'],
          imageUrl: data['imageUrl'],
          uid: data['uid'],
        );

  Map<String, dynamic> getMap() {
    final Map<String, dynamic> map = 
      {
        'firstName': firstName,
        'name': name,
        'email': email,
        'phone': phone,
        'isAdmin': isAdmin,
        'isClient': isClient,
        'imageUrl': imageUrl,
        'uid': uid,
      };
    return map;
  }
}
