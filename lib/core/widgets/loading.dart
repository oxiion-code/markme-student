import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class StudentHandLoading extends StatelessWidget{
  const StudentHandLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child:SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset("assets/animations/student_loading.json"),
      ),
    );
  }
}
class DefaultLoading extends StatelessWidget{
  const DefaultLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child:SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset("assets/animations/find_data_loading.json"),
      ),
    );
  }
}