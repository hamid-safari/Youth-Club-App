class Person {
  String? id;
  final String firstName;
  final String lastName;
  final int? birthDate;
  final Gender gender;
  final String phoneNumber;
  final String bgNumber;
  final String school;
  final String address;
  String? adminId;
  String? userEventId;
  final int date; //timetsamp

  Person({
    this.id,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.bgNumber,
    required this.school,
    required this.address,
    this.adminId,
    this.userEventId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "birthDate": birthDate,
        "gender": gender.name,
        "phoneNumber": phoneNumber,
        "bgNumber": bgNumber,
        "address": address,
        "school": school,
        "date": date,
        "adminId": adminId,
      };

  Person.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        birthDate = data['birthDate'],
        gender = Gender.values
            .firstWhere((element) => element.name == data['gender']),
        phoneNumber = data['phoneNumber'],
        bgNumber = data['bgNumber'],
        address = data['address'],
        adminId = data['adminId'],
        school = data['school'],
        date = data['date'];
}

enum Gender {
  male,
  female,
  diverse;

  @override
  String toString() => name;
}
