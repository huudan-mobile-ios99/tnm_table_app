import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/screen/admin/bloc/list_bloc.dart';
import 'package:tournament_client/screen/admin/view/list.dart';


class ListRankingPage extends StatelessWidget {
  const ListRankingPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        lazy: false,
        create: (_) => ListBloc(httpClient: http.Client())..add(ListFetched()),
        child:  const ListRanking(),
      ),
    );
  }
}
