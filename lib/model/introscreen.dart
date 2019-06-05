import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/page_model.dart';

final onBoardingList = [
  PageModel(
      color: Color(0xFF678FB4),
      heroAssetPath: 'assets/main.png',
      iconAssetPath: 'assets/profile.png',
      title: Text('Welcome to Islington Navigation',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
              fontFamily: 'Montserrat')),
      body: Text(
        'Get the overview of college and structures',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'Montserrat'),
      )),
  PageModel(
      color: Color(0xFF65B0B4),
      heroAssetPath: 'assets/profile.png',
      iconAssetPath: 'assets/profile.png',
      title: Text('Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
              fontFamily: 'Montserrat')),
      body: Text(
        'Login to add Routine and gain additional feature of app',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'Montserrat'),
      )),
  PageModel(
      color: Color(0xFF9B90BC),
      heroAssetPath: 'assets/mapscreen.png',
      iconAssetPath: 'assets/profile.png',
      title: Text('Search Structures',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
              fontFamily: 'Montserrat')),
      body: Text(
        'Get the direction to the sturucture from current location',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'Montserrat'),
      )),
];
