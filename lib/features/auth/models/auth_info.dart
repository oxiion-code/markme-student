import 'package:markme_student/core/models/college_detail.dart';

class AuthInfo{
  final String uid;
  final String phoneNumber;
  final bool isNewUser;
  final CollegeDetail? collegeDetail;
  const AuthInfo({required this.uid, required this.phoneNumber,required this.isNewUser, this.collegeDetail});
}