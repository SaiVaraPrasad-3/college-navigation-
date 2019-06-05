import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/constants.dart';
import 'package:path/path.dart';

class Users {
  //Data in database are stored in such manner.
  final String user_id;
  final int first_login;
  final int admin;
  final String name;
  final String gender;
  final String bio;
  final String email;
  final String user_name;
  final String password;
  final String image;
  final String phone;
  final String provider;
  final String created_at;
  final String updated_at;

  //Constructor
  Users(
      {this.user_id,
      this.first_login,
      this.admin,
      this.name,
      this.gender,
      this.bio,
      this.email,
      this.user_name,
      this.password,
      this.image,
      this.phone,
      this.provider,
      this.created_at,
      this.updated_at});

  //Static method to serialize the json format data of the users
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      user_id: json["user_id"],
      first_login: json["first_login"],
      admin: json["admin"],
      name: json["name"],
      gender: json["gender"],
      bio: json["bio"],
      email: json["email"],
      user_name: json["user_name"],
      password: json["password"],
      image: json["image"],
      phone: json["phone"],
      provider: json["provider"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }
}

//create users
Future<String> createUser(http.Client client, Users user) async {
  var createValue = {
    "user_id": user.user_id,
    "first_login": user.first_login.toString(),
    "admin": user.admin.toString(),
    "name": user.name,
    "gender": user.gender,
    "email": user.email,
    "user_name": user.user_name,
    "password": user.password,
  };

  final response = await client.post(
    URL_USER_SIGNUP,
    body: createValue,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["status"] == "200" && mapResponse["error"] == null) {
      final response = mapResponse["response"].cast<Map<String, dynamic>>();
      print(response);
      return "200";
    } else {
      print(mapResponse);
      return "501";
    }
  } else {
    print("User not Created");
    return "500";
  }
}

//create users from google signin
Future<String> createGoogleUser(http.Client client, Users user) async {
  var createValue = {
    "user_id": user.user_id,
    "first_login": user.first_login.toString(),
    "admin": user.admin.toString(),
    "name": user.name,
    "email": user.email,
    "user_name": user.user_name,
    "image": user.image,
    "provider": user.provider,
  };

  final response = await client.post(
    URL_USER_SIGNUP,
    body: createValue,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["status"] == "200" && mapResponse["error"] == null) {
      final response = mapResponse["response"].cast<Map<String, dynamic>>();
      print(response);
      return "200";
    } else {
      print(mapResponse);
      return "501";
    }
  } else {
    print("User not Created");
    return "500";
  }
}

//login user
Future<List<Users>> loginUser(http.Client client, Users user) async {
  var createValue = {
    "user_name": user.user_name,
    "password": user.password,
  };

  final response = await client.post(
    URL_USER_LOGIN,
    body: createValue,
  );

  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the users data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The users data inside "data" is the casted to <String, dynamic> mapping.
      final users = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfUsers = await users.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();
      return listOfUsers;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load users.");

    // print("Failed to load users.");
  }
}

//check email
Future<List<Users>> checkEmail(http.Client client, String email) async {
  var createValue = {
    "email": email,
  };
  final response = await client.post(
    URL_CHECK_EMAIL,
    body: createValue,
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the users data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The users data inside "data" is the casted to <String, dynamic> mapping.
      final users = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfUsers = await users.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();
      return listOfUsers;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load users.");

    // print("Failed to load users.");
  }
}

//check username
Future<List<Users>> checkUsername(http.Client client, String user_name) async {
  var createValue = {
    "user_name": user_name,
  };
  final response = await client.post(URL_CHECK_USERNAME,
      headers: {"Content-Type": "application/json"}, body: createValue);

  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the users data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The users data inside "data" is the casted to <String, dynamic> mapping.
      final users = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfUsers = await users.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();
      return listOfUsers;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load users.");

    // print("Failed to load users.");
  }
}

//create users
Future<String> updateUser(http.Client client, Users user) async {
  var createValue = {
    "name": user.name,
    "user_name": user.user_name,
    "phone": user.phone
  };

  final response = await client.patch(
    URL_USER_UPDATE + "/" + user.user_id,
    body: createValue,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["status"] == "200" && mapResponse["error"] == null) {
      final response = mapResponse["response"].cast<Map<String, dynamic>>();
      print(response);
      return "200";
    } else {
      print(mapResponse);
      return "501";
    }
  } else {
    print("User not Created");
    return "500";
  }
}

//get user with User id
Future<List<Users>> fetchUserWithUID(http.Client client, String uid) async {
  final response = await client.get(
    URL_USER_USER_ID + "/" + uid,
    headers: {"Content-Type": "application/json"},
  );
  // print(response);
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the users data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The users data inside "data" is the casted to <String, dynamic> mapping.
      final users = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfUsers = await users.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();
      return listOfUsers;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load users.");
  }
}

Future<String> addPhoto(http.Client client, File file, String uid) async {
  var updateValue = {
    "image": file != null ? base64Encode(file.readAsBytesSync()) : ''
  };
  final response = await client.patch(
    URL_USER_UPLOAD_IMAGE + "/" + uid,
    body: updateValue,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      final response = mapResponse["response"].cast<Map<String, dynamic>>();
      print(response);
      return "200";
    } else {
      print(mapResponse);
      return "501";
    }
  } else {
    print("Update not successful");
    return "500";
  }
}

uploadPhoto(File file, String uid) async {
  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  var length = await file.length();

  var uri = Uri.parse(URL_USER_UPLOAD_IMAGE + "/" + uid);

  var request = new http.MultipartRequest("PATCH", uri);
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(file.path));
  //contentType: new MediaType('image', 'png'));

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}
