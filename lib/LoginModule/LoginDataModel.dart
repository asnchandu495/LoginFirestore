import 'dart:convert';

class LoginDataModel {

  LoginDataModel({required this.email,required this.password});

  final String email;
  final String password;

  factory LoginDataModel.fromJson(Map<String, dynamic> jsonData) {
    return LoginDataModel(email: jsonData['email'], password: jsonData['password']);
  }

  static Map<String, dynamic> toMap(LoginDataModel model) => {

    'email' : model.email,
    'password' : model.password,

  };

  static String encode(List<LoginDataModel> model) => json.encode(
    model.map<Map<String, dynamic>>((model) => LoginDataModel.toMap(model))
  );

  static List<LoginDataModel> decode(String model) => (json.decode(model) as List<dynamic>).map<LoginDataModel>((item) => LoginDataModel.fromJson(item)).toList();

}