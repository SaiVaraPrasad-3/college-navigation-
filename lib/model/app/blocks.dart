import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/constants.dart';

class Blocks {
  //Data in database are stored in such manner.
  final int block_id;
  final String block_name;
  final double latitude;
  final double longitude;
  final String image;
  final String created_at;
  final String updated_at;

  //Constructor
  Blocks(
      {this.block_id,
      this.block_name,
      this.latitude,
      this.longitude,
      this.image,
      this.created_at,
      this.updated_at});

  //Static method to serialize the json format data of the Blocks
  factory Blocks.fromJson(Map<String, dynamic> json) {
    return Blocks(
      block_id: json["block_id"],
      block_name: json["block_name"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      image: json["image"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }
}

Future<List<Blocks>> fetchAllBlocks(http.Client client) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_BLOCKS_GET_ALL,
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the blocks data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The block data inside "data" is the casted to <String, dynamic> mapping.
      final blocks = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfBlocks = await blocks.map<Blocks>((json) {
        return Blocks.fromJson(json);
      }).toList();
      return listOfBlocks;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load blocks.");
  }
}

Future<List<Blocks>> fetchIndividualBlocks(http.Client client) async {
  //Get the block url from the constants.dart file inside the utils directory.

  final response = await client.get(
    URL_BLOCKS_GET_INDIVIDUAL,
    headers: {"Content-Type": "application/json"},
  );
//  print(response);
  //Response if success returns the code 200
  if (response.statusCode == 200) {
    //Mapping the data on the server from JSON to Map<String, dynamic>
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //The data from the server will contain two main attributes 'status' and 'response'
    //result specifies the status of the data received
    //data contains the blocks data
    //if the status is fine then it contains "200"
    if (mapResponse["status"] == 200 && mapResponse["error"] == null) {
      //The block data inside "data" is the casted to <String, dynamic> mapping.
      final blocks = mapResponse["response"].cast<Map<String, dynamic>>();
      //Creating a serialized data from the json
      final listOfBlocks = await blocks.map<Blocks>((json) {
        return Blocks.fromJson(json);
      }).toList();
      return listOfBlocks;
    } else {
      print(mapResponse);
      return [];
    }
  } else {
    //Throw exception if the response status code id not 200.
    throw Exception("Failed to load block.");
  }
}
