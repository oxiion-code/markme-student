import 'package:equatable/equatable.dart';
import 'package:markme_student/core/models/section.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_event.dart';
import 'package:markme_student/features/student/models/student.dart';

class EditProfileState extends Equatable{
  const EditProfileState();
  @override
  List<Object?> get props => [];
}
class EditProfileInitial extends EditProfileState{

}
class EditProfileLoading extends EditProfileState{

}
class SectionsLoadedForStudent extends EditProfileState{
  final List<String> sections;
  const SectionsLoadedForStudent({required this.sections});
  @override
  List<Object?> get props => [sections];
}

class EditProfileSuccess extends EditProfileState{
  final Student student;
  const EditProfileSuccess(this.student);
  @override
  List<Object?> get props => [student];
}

class SectionChangedForStudent extends EditProfileState{
  final String sectionId;
  const SectionChangedForStudent({required this.sectionId});
  @override
  List<Object?> get props => [sectionId];
}

class EditProfileError extends EditProfileState{
  final String message;
  const EditProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}
class UpdatedStudentRegOrRoll extends EditProfileState{

}
class LoadedSectionDetails extends EditProfileState{
  final Section section;
  const LoadedSectionDetails({required this.section});
  @override
  List<Object?> get props => [section];
}