import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/app_utils.dart';
import '../models/auth_info.dart';
import '../../student/models/student.dart';
import '../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckAuthStatus>(_checkAuthStatus);
    on<UpdateDataEvent>(_updateData);
    on<LogoutRequested>(_onLogoutRequest);
    on<LoadAllCollegesEvent>(_onLoadAllColleges);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await authRepository.sendOtp(phoneNumber: event.phoneNumber);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verificationId) => emit(OtpSent(verificationId)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.verifyOtp(
      verificationId: event.verificationId,
      otp: event.otp,
    );

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (authInfo) async {
        final uid = authInfo.uid;
        final userDataResult = await authRepository.getUserdata(uid: uid,collegeId: event.collegeId);
        Student student;

        if (userDataResult.isLeft()) {
          student = Student(
            id: uid,
            phoneNumber: authInfo.phoneNumber,
            name: '',
            regdNo: '',
            rollNo: '',
            profilePhotoUrl: '',
            branchId: '',
            group: '',
            sectionId: '',
            fatherName: '',
            motherName: '',
            studentMobileNo: '',
            fatherMobileNo: '',
            motherMobileNo: '',
            email: '',
            dob: '',
            category: '',
            admissionDate: '',
            sex: '',
            deviceToken: '',
            batchId: '',
            courseId: '',
            hostelAddress: HostelAddress(hostel: '', block: '', roomNo: ''),
            normalAddress: NormalAddress(
              atPo: '',
              cityVillage: '',
              dist: '',
              state: '',
              pin: '',
            ),
          );
          await authRepository.updateStudentData(student: student,collegeId: event.collegeId);
        } else {
          student = userDataResult.getOrElse(() => throw Exception());
        }

        final isProfileComplete =
            student.name.isNotEmpty && student.profilePhotoUrl.isNotEmpty;

        if (!isProfileComplete) {
          emit(ProfileIncomplete(student));
        } else {
          emit(
            AuthenticationSuccess(
              authInfo: authInfo,
              isNewUser: false,
              student: student,
            ),
          );
        }
      },
    );
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(UnAuthenticated());
      return;
    }

    final result = await authRepository.getUserdata(uid: currentUser.uid,collegeId: event.collegeId);
    result.fold((failure) => emit(AuthError(failure.message)), (student) {
      final isProfileComplete =
          student.name.isNotEmpty && student.profilePhotoUrl.isNotEmpty;

      if (!isProfileComplete) {
        emit(ProfileIncomplete(student));
      } else {
        emit(UserAlreadyLoggedIn(student));
      }
    });
  }

  Future<void> _onLogoutRequest(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.logout();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }

  FutureOr<void> _updateData(
    UpdateDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final currentDeviceId = await AppUtils.getCurrentDeviceToken();

    final updatedStudent = event.student.copyWith(deviceToken: currentDeviceId);

    final result = await authRepository.updateStudentData(
      student: updatedStudent,
      profilePhoto: event.file,
      collegeId: event.collegeId
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (student) => emit(StudentUpdateSuccess(student)),
    );
  }

  FutureOr<void> _onLoadAllColleges(
      LoadAllCollegesEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(SelectCollegeLoading());
    final result = await authRepository.loadAllColleges();
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (colleges) => emit(LoadedAllCollegeDetails(colleges: colleges)),
    );
  }
}
