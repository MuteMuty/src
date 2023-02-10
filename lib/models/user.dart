class User {
  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String password;
  final DateTime birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final Hair hair;
  final String domain;
  final String ip;
  final Address address;
  final String macAddress;
  final String university;
  final Bank bank;
  final Company company;
  final String ein;
  final String ssn;
  final String userAgent;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.domain,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      maidenName: json['maidenName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      birthDate: DateTime.parse(json['birthDate']),
      image: json['image'],
      bloodGroup: json['bloodGroup'],
      height: json['height'],
      weight: json['weight'],
      eyeColor: json['eyeColor'],
      hair: Hair.fromJson(json['hair']),
      domain: json['domain'],
      ip: json['ip'],
      address: Address.fromJson(json['address']),
      macAddress: json['macAddress'],
      university: json['university'],
      bank: Bank.fromJson(json['bank']),
      company: Company.fromJson(json['company']),
      ein: json['ein'],
      ssn: json['ssn'],
      userAgent: json['userAgent'],
    );
  }
}

class Hair {
  final String color;
  final String type;

  Hair({
    required this.color,
    required this.type,
  });

  factory Hair.fromJson(Map<String, dynamic> json) {
    return Hair(
      color: json['color'],
      type: json['type'],
    );
  }
}

class Address {
  final String address;
  final String city;
  final Coordinates coordinates;
  final String postalCode;
  final String state;

  Address({
    required this.address,
    required this.city,
    required this.coordinates,
    required this.postalCode,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      coordinates: Coordinates.fromJson(json['coordinates']),
      postalCode: json['postalCode'],
      state: json['state'],
    );
  }
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Bank {
  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      cardExpire: json['cardExpire'],
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      currency: json['currency'],
      iban: json['iban'],
    );
  }
}

class Company {
  final Address address;
  final String department;
  final String name;
  final String title;

  Company({
    required this.address,
    required this.department,
    required this.name,
    required this.title,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      address: Address.fromJson(json['address']),
      department: json['department'],
      name: json['name'],
      title: json['title'],
    );
  }
}
