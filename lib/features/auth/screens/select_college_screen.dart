import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/models/college_detail.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SelectCollegeScreen extends StatefulWidget {
  const SelectCollegeScreen({super.key});

  @override
  State<SelectCollegeScreen> createState() => _SelectCollegeScreenState();
}

class _SelectCollegeScreenState extends State<SelectCollegeScreen> {
  CollegeDetail? selectedCollege;
  List<CollegeDetail> colleges = [];

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadAllCollegesEvent());
  }
  Future<bool> showCollegeCodeDialog(
      BuildContext context,
      CollegeDetail college,
      ) {
    final TextEditingController codeController = TextEditingController();

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter College Code"),
          content: TextField(
            controller: codeController,
            autofocus: true,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
              labelText: "College Code",
              hintText: "Enter college id",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final inputCode =
                codeController.text.trim().toLowerCase();
                final collegeId =
                college.id.trim().toLowerCase();

                final isMatch = inputCode == collegeId;

                Navigator.pop(context, isMatch);
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SelectCollegeLoading) {
          AppUtils.showCustomLoading(context);
        } else if(state is LoadedAllCollegeDetails) {
          AppUtils.hideCustomLoading(context);
        }else if(state is AuthError) {
         AppUtils.hideCustomLoading(context);
        }
        if (state is LoadedAllCollegeDetails) {
          setState(() {
            colleges = state.colleges;
          });
        } else if (state is AuthError) {
          AppUtils.showCustomSnackBar(context, state.error);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
            top: 12,
          ),
          child: CustomButton(
            onTap: () async {
              if(selectedCollege==null){
                AppUtils.showCustomSnackBar(context, "Select a college to continue", isError: true);
              }else{
                final isMatched=await showCollegeCodeDialog(context, selectedCollege!);
                if(isMatched && selectedCollege!=null){
                  context.push("/authPhoneNumber",extra: selectedCollege!);
                }else{
                  AppUtils.showCustomSnackBar(context, "Invalid college code", isError:  true);
                }
              }
            },
            text: "Continue",
            icon: Icons.arrow_circle_right_rounded,
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Image
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Colors.transparent],
                      stops: [0.0, 0.8, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    "assets/images/select_college_image.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Heading
                      Text(
                        'Select your college',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey[900],
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Subtitle
                      Text(
                        'Choose your institution in which your phone number is registered as teacher.',
                        style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// College Dropdown
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CollegeDetail>(
                              value: selectedCollege,
                              hint: const Text('Select college'),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              items: colleges
                                  .map(
                                    (college) => DropdownMenuItem(
                                  value: college,
                                  child: Text(college.collegeName),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCollege = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
