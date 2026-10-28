import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, ReadContext;
import 'package:flutter_study/api_service/api_service.dart';
import 'package:flutter_study/bloc/get_user_bloc.dart';
import 'package:flutter_study/src/detail_page.dart';
import 'package:flutter_study/user_model/user_model.dart';

class HomaPage extends StatelessWidget {
  const HomaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserBloc(api: ApiService())..add(GetUserRequ()),
      child: Scaffold(
        appBar: AppBar(title: Text('Home Page')),
        body: HomepageHelper(),
      ),
    );
  }
}

class HomepageHelper extends StatefulWidget {
  const HomepageHelper({super.key});

  @override
  State<HomepageHelper> createState() => _HomepageHelperState();
}

class _HomepageHelperState extends State<HomepageHelper> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          controller: _searchController,
          hintText: 'Search Users here...',
          onChanged: (value) {
            GetUserBloc bloc = context.read<GetUserBloc>();
            bloc.add(SearchUser(q: value));
          },
        ),
        SizedBox(height: 20),
        Expanded(
          child: BlocBuilder<GetUserBloc, GetUserState>(
            builder: (context, state) {
              if (state is Loading) {
                return Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is EmptyState) {
                return Center(child: Text(state.messsage));
              } else if (state is SuccessState) {
                final List<UserModel> users = state.users;

                return RefreshIndicator(
                  onRefresh: () async {
                    GetUserBloc bloc = context.read<GetUserBloc>();
                    bloc.add(GetUserRequ());
                    _searchController.clear();
                    await bloc.stream.firstWhere(
                      (state) =>
                          state is FailureState ||
                          state is EmptyState ||
                          state is SuccessState,
                    );
                  },
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final UserModel user = users[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(user: user)));
                        },
                        child: Container(
                          padding: .all(30),
                          margin: .symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: .4),
                          ),
                          child: Column(
                            children: [
                              Text(user.name ?? 'Un Title'),
                              Text('${user.email} | ${user.phone}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is FailureState) {
                return Center(child: Text(state.messsage));
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
