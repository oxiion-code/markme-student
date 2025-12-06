class Student {
  final String id; // ✅ Firebase UID
  final String phoneNumber; // ✅ Phone number
  final String profilePhotoUrl;
  final String rollNo;
  final String regdNo;
  final String name;
  final String branchId; // 🔥 Changed from branch to branchId
  final String sectionId; // 🔥 New field
  final String group; // 🔥 New field
  final String fatherName;
  final String motherName;
  final String studentMobileNo;
  final String fatherMobileNo;
  final String motherMobileNo;
  final String email;
  final String dob;
  final String category;
  final String admissionDate;
  final String sex;
  final String deviceToken; // For notifications & attendance tracking
  final String batchId; // Link student to batch
  final String courseId; // Link student to course
  final HostelAddress hostelAddress;
  final NormalAddress normalAddress;

  Student({
    required this.id,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    required this.rollNo,
    required this.regdNo,
    required this.name,
    required this.branchId,
    required this.sectionId,
    required this.group,
    required this.fatherName,
    required this.motherName,
    required this.studentMobileNo,
    required this.fatherMobileNo,
    required this.motherMobileNo,
    required this.email,
    required this.dob,
    required this.category,
    required this.admissionDate,
    required this.sex,
    required this.deviceToken,
    required this.batchId,
    required this.courseId,
    required this.hostelAddress,
    required this.normalAddress,
  });

  Student copyWith({
    String? id,
    String? phoneNumber,
    String? profilePhotoUrl,
    String? rollNo,
    String? regdNo,
    String? name,
    String? branchId,
    String? sectionId,
    String? group,
    String? fatherName,
    String? motherName,
    String? studentMobileNo,
    String? fatherMobileNo,
    String? motherMobileNo,
    String? email,
    String? dob,
    String? category,
    String? admissionDate,
    String? sex,
    String? deviceToken,
    String? batchId,
    String? courseId,
    HostelAddress? hostelAddress,
    NormalAddress? normalAddress,
  }) {
    return Student(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      rollNo: rollNo ?? this.rollNo,
      regdNo: regdNo ?? this.regdNo,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      sectionId: sectionId ?? this.sectionId,
      group: group ?? this.group,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      studentMobileNo: studentMobileNo ?? this.studentMobileNo,
      fatherMobileNo: fatherMobileNo ?? this.fatherMobileNo,
      motherMobileNo: motherMobileNo ?? this.motherMobileNo,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      category: category ?? this.category,
      admissionDate: admissionDate ?? this.admissionDate,
      sex: sex ?? this.sex,
      deviceToken: deviceToken ?? this.deviceToken,
      batchId: batchId ?? this.batchId,
      courseId: courseId ?? this.courseId,
      hostelAddress: hostelAddress ?? this.hostelAddress,
      normalAddress: normalAddress ?? this.normalAddress,
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) => Student.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      rollNo: map['rollNo'] ?? '',
      regdNo: map['regdNo'] ?? '',
      name: map['name'] ?? '',
      branchId: map['branchId'] ?? '', // 🔥 updated
      sectionId: map['sectionId'] ?? '', // 🔥 new
      group: map['group'] ?? '', // 🔥 new
      fatherName: map['fatherName'] ?? '',
      motherName: map['motherName'] ?? '',
      studentMobileNo: map['studentMobileNo'] ?? '',
      fatherMobileNo: map['fatherMobileNo'] ?? '',
      motherMobileNo: map['motherMobileNo'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      category: map['category'] ?? '',
      admissionDate: map['admissionDate'] ?? '',
      sex: map['sex'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      batchId: map['batchId'] ?? '',
      courseId: map['courseId'] ?? '',
      hostelAddress: HostelAddress.fromMap(map['hostelAddress'] ?? {}),
      normalAddress: NormalAddress.fromMap(map['normalAddress'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'profilePhotoUrl': profilePhotoUrl,
      'rollNo': rollNo,
      'regdNo': regdNo,
      'name': name,
      'branchId': branchId, // 🔥 updated
      'sectionId': sectionId, // 🔥 new
      'group': group, // 🔥 new
      'fatherName': fatherName,
      'motherName': motherName,
      'studentMobileNo': studentMobileNo,
      'fatherMobileNo': fatherMobileNo,
      'motherMobileNo': motherMobileNo,
      'email': email,
      'dob': dob,
      'category': category,
      'admissionDate': admissionDate,
      'sex': sex,
      'deviceToken': deviceToken,
      'batchId': batchId,
      'courseId': courseId,
      'hostelAddress': hostelAddress.toMap(),
      'normalAddress': normalAddress.toMap(),
    };
  }
}

class HostelAddress {
  final String hostel;
  final String block;
  final String roomNo;
  HostelAddress({
    required this.hostel,
    required this.block,
    required this.roomNo,
  });
  HostelAddress copyWith({String? hostel, String? block, String? roomNo}) {
    return HostelAddress(
      hostel: hostel ?? this.hostel,
      block: block ?? this.block,
      roomNo: roomNo ?? this.roomNo,
    );
  }

  factory HostelAddress.fromJson(Map<String, dynamic> json) =>
      HostelAddress.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
  factory HostelAddress.fromMap(Map<String, dynamic> map) {
    return HostelAddress(
      hostel: map['hostel'] ?? '',
      block: map['block'] ?? '',
      roomNo: map['roomNo'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {'hostel': hostel, 'block': block, 'roomNo': roomNo};
  }
}

class NormalAddress {
  final String atPo;
  final String cityVillage;
  final String dist;
  final String state;
  final String pin;
  NormalAddress({
    required this.atPo,
    required this.cityVillage,
    required this.dist,
    required this.state,
    required this.pin,
  });
  NormalAddress copyWith({
    String? atPo,
    String? cityVillage,
    String? dist,
    String? state,
    String? pin,
  }) {
    return NormalAddress(
      atPo: atPo ?? this.atPo,
      cityVillage: cityVillage ?? this.cityVillage,
      dist: dist ?? this.dist,
      state: state ?? this.state,
      pin: pin ?? this.pin,
    );
  }

  factory NormalAddress.fromJson(Map<String, dynamic> json) =>
      NormalAddress.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
  factory NormalAddress.fromMap(Map<String, dynamic> map) {
    return NormalAddress(
      atPo: map['atPo'] ?? '',
      cityVillage: map['cityVillage'] ?? '',
      dist: map['dist'] ?? '',
      state: map['state'] ?? '',
      pin: map['pin'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'atPo': atPo,
      'cityVillage': cityVillage,
      'dist': dist,
      'state': state,
      'pin': pin,
    };
  }
}
