class AuthBuoys {
  String buoyID;
  String name;
  String password;
  String authLevel;
  bool updated;

  AuthBuoys({
    required this.buoyID,
    required this.name,
    required this.password,
    required this.authLevel,
    required this.updated,
  });

  // Constructor to convert json data to AuthBuoy objects
  factory AuthBuoys.fromJson(Map<String, dynamic> json) {
    return AuthBuoys(
      buoyID: json['buoyID'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      authLevel: json['authLevel'] as String,
      updated: json['updated'] as bool,
    );
  }
}