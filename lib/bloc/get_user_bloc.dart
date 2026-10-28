import 'package:bloc/bloc.dart';
import 'package:flutter_study/api_service/api_service.dart';
import 'package:flutter_study/user_model/user_model.dart';
import 'package:meta/meta.dart';

part 'get_user_event.dart';
part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final ApiService _api;
  GetUserBloc({required ApiService api}) :_api = api, super(GetUserInitial()) {
    List<UserModel> users = [];

    on<GetUserRequ>((event, emit)async {
     emit(Loading());
     try {
      final response = await _api.get();
      users = response;
      if (users.isEmpty) {
        emit(EmptyState(messsage: 'User Empty'));
      } else {
        emit(SuccessState(users: users));
      }
       
     } catch (e) {
       emit(FailureState(messsage: e.toString()));
     }
    });


        on<SearchUser>((event, emit) {
          final String quary = event.q?.trim().toLowerCase() ?? '';
      if (users.isEmpty) {
        emit(EmptyState(messsage: 'User Empty'));
        return;
      }

      if(quary.isEmpty){
        emit(SuccessState(users: users));
        return;
      }

      List<UserModel> fillterUser = users.where((e) {
        final String titile = e.name?.toLowerCase() ?? '';
        return titile.contains(quary);
      }).toList();

      if (fillterUser.isEmpty) {
        emit(EmptyState(messsage: 'No Maching Results'));
      }else {
        emit(SuccessState(users: fillterUser));
      }
       
    });
  }
}
