import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  String wallet;

  MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      required this.hasActiveCart,
      required this.wallet});

  static final empty =
      MyUser(userId: '', email: '', name: '', hasActiveCart: false, wallet: "");

  MyUserEntity toEntity() {
    return MyUserEntity(
        userId: userId,
        email: email,
        name: name,
        hasActiveCart: hasActiveCart,
        wallet: wallet);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        name: entity.name,
        hasActiveCart: entity.hasActiveCart,
        wallet: entity.wallet);
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $hasActiveCart, $wallet';
  }
}
