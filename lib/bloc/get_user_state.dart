part of 'get_user_bloc.dart';

@immutable
sealed class GetUserState {}

final class GetUserInitial extends GetUserState {}

final class Loading extends GetUserState {}
final class EmptyState extends GetUserState {
  final String messsage;

  EmptyState({required this.messsage});
}
final class SuccessState extends GetUserState {
  final List<UserModel> users;

  SuccessState({required this.users});
}
final class FailureState extends GetUserState {
  
  final String messsage;

  FailureState({required this.messsage});
}