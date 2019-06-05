import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/constants.dart';

class Structures {
  //Data in database are stored in such manner.
  final int structure_id;
  final String structure_name;
  final String structure_type;
  final double latitude;
  final double longitude;
  final String images;
  final int block_id;
  final String block_name;
  final String floor;
  final String image;
  final String created_at;
  final String updated_at;

  //Constructor
  Structures(
      {this.structure_id,
      this.structure_name,
      this.structure_type,
      this.latitude,
      this.longitude,
      this.images,
      this.block_id,
      this.block_name,
      this.floor,
      this.image,
      this.created_at,
      this.updated_at});

  //Static method to serialize the json format data of the Structures
  factory Structures.fromJson(Map<String, dynamic> json) {
    return Structures(
      structure_id: json["structure_id"],
      structure_name: json["structure_name"],
      structure_type: json["structure_type"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      images: json["images"],
      block_id: json["block_id"],
      block_name: json["block_name"],
      floor: json["floor"],
      image: json["image"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }
}

Future<List<Structures>> fetchAllStructures(http.Client client) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_STRUCTURE_GET_ALL,
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structures.");
  }
}

Future<List<Structures>> categorizeStructures(
    http.Client client, int BLOCK_ID) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_STRUCTURE_CATEGORIZE + "/" + BLOCK_ID.toString(),
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structures.");
  }
}

Future<List<Structures>> categorizeAllStructures(
  http.Client client,
) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_STRUCTURE_CATEGORIZE_ALL,
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structures.");
  }
}

Future<List<Structures>> getAllFromCategory(
    http.Client client, String structure_name) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_GET_ALL_STRUCTURE_BY_CATEGORY + "/" + structure_name.toString(),
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structures.");
  }
}

Future<List<Structures>> getAllFromCategoryByBlockId(
    http.Client client, String structure_name, int block_id) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_GET_ALL_STRUCTURE_BY_CATEGORY +
        "/" +
        structure_name.toString() +
        "/" +
        block_id.toString(),
    headers: {"Content-Type": "application/json"},
  );
  //print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structures.");
  }
}

// get structure by structure id
Future<List<Structures>> fetchIndividualStructure(
    http.Client client, int sid) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_STRUCTURE_GET_INDIVIDUAL + "/" + sid.toString(),
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structure.");
  }
}

//get structure from block id and structure type
Future<List<Structures>> getStructureByStructureTypeAndBlockId(
    http.Client client, String structure_type, int block_id) async {
  //Get the block url from the constants.dart file inside the utils directory.

  print(structure_type + block_id.toString());
  var createValue = {
    "structure_type": structure_type,
    "block_id": block_id.toString(),
  };
  final response = await client.post(
    URL_GET_ALL_STRUCTURE_BY_BLOCK_ID_AND_STRUCTURE_TYPE,
    body: createValue,
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the Structures data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The structure data inside "data" is the casted to <String, dynamic> mapping.
      final structure = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfStructures = await structure.map<Structures>((json) {
        return Structures.fromJson(json);
      }).toList();
      return listOfStructures;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load Structures.");
  }
}
