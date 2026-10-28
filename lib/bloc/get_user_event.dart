part of 'get_user_bloc.dart';

@immutable
sealed class GetUserEvent {}

final class GetUserRequ extends GetUserEvent {}
final class SearchUser extends GetUserEvent {
  final String? q;

  SearchUser({required this.q});
}
