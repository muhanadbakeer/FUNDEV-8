import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/login_model.dart';
import '../statc/cubit/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<loginstate> {
  LoginCubit() : super(OnInitialLoginStats());

  void login({required String email, required String password}) async {
    emit(OnStartLoginStats());
    try{
      final url = Uri.parse("http://10.0.2.2:5172");
      final response = await http.post(
          url,
          headers: {"Accept": "application/json"},
          body: {
            'email': email,
            'password': password,
          });
      print("respons staats code${response.statusCode}");
      print("response body${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        LoginModel login = LoginModel.fromJson(data);
        emit(OnLoadedloginstats(login.data!.accessToken??""));
      } else {
        emit(OnErrorloginstats("something went wrong"));
      }
    }catch(e){
      emit(OnErrorloginstats(e.toString()));
    }
  }
}



