class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  String wallet;

  MyUserEntity(
      {required this.userId,
      required this.email,
      required this.name,
      required this.hasActiveCart,
      required this.wallet});

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'wallet': wallet
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        hasActiveCart: doc['hasActiveCart'],
        wallet: doc['wallet']);
  }
}
