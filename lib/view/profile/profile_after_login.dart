import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:islington_navigation_flutter/controller/utils/constants.dart';
import 'package:islington_navigation_flutter/model/app/users.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/view/profile/update_profile.dart';

class ProfileLoggedIn extends StatefulWidget {
  ProfileLoggedIn({
    @required this.userId,
  });

  String userId;

  @override
  _ProfileLoggedInState createState() => _ProfileLoggedInState();
}

class _ProfileLoggedInState extends State<ProfileLoggedIn> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  List<Users> userList;
  File _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserWithUID(http.Client(), widget.userId).then((value) {
      setState(() {
        userList = value;
      });
    });
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      print("inside refresher setState : ");
      fetchUserWithUID(http.Client(), widget.userId).then((value) {
        setState(() {
          userList = value;
        });
      });
    });

    Future.delayed(Duration(seconds: 2));
    // print("inside refresher : ");
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void uploadImage() {
    addPhoto(http.Client(), _image, userList.first.user_id)
        .then((returnCode) async {
      if (returnCode == "200") {
        print("Image uploaded successfully");
      } else if (returnCode == "500") {
        print("Please try again later");
      }
    }).catchError((onError) {
      print("Could not edit data because: " + onError.toString());
      // Navigator.of(context).pop();
      // Navigator.pop(context);
    });

    // uploadPhoto(_image, widget.user.user_id).then((returnCode) {
    //   if
    // });
  }

  void _upload() {
    if (_image == null) return;
    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;

    http.post(URL_USER_UPLOAD_IMAGE + "/" + userList.first.user_id, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: EasyRefresh(
        refreshHeader: BezierCircleHeader(
          key: _headerKey,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        refreshFooter: BezierBounceFooter(
          key: _footerKey,
        ),
        onRefresh: onRefresh,
        // showChildOpacityTransition: false,
        child: userList != null
            ? ListView(
                padding: const EdgeInsets.all(15.0),
                children: <Widget>[
                  Center(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage: userList.first.image != null
                              ? userList.first.provider == "Google"
                                  ? NetworkImage(
                                      userList.first.image,
                                    )
                                  : NetworkImage(
                                      GET_USER_IMAGES + userList.first.image,
                                    )
                              : NetworkImage("https://t4.ftcdn.net/jpg/01/18/03/35/160_F_118033506_uMrhnrjBWBxVE9sYGTgBht8S5liVnIeY.jpg")),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: getImage,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      userList.first.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  MaterialButton(
                    color: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (builder) {
                        return UpdateProfilePage(
                            user_id: userList.first.user_id);
                      }));
                    },
                    child: Text("Update Profile"),
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          _image == null
                              ? Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          CupertinoIcons.mail_solid,
                                          color: Color(0xFF646464),
                                        ),
                                        Text(
                                          userList.first.email,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.teal),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          CupertinoIcons.profile_circled,
                                          size: 20.0,
                                          color: Color(0xFF646464),
                                        ),
                                        Text(userList.first.gender,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.teal)),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          CupertinoIcons.phone_solid,
                                          size: 20.0,
                                          color: Color(0xFF646464),
                                        ),
                                        Text(
                                            userList.first.phone == null
                                                ? "No phone added"
                                                : userList.first.phone,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.teal)),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  children: <Widget>[
                                    Image.file(_image),
                                    FlatButton(
                                      child: Text("Upload"),
                                      onPressed: () {
                                        _upload();
                                      },
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : AnimatedPadding(
                duration: Duration(seconds: 2),
                padding: EdgeInsets.symmetric(vertical: 200.0),
                curve: Curves.easeIn,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}

// class ProfileTile extends StatefulWidget {
//   ProfileTile({
//     @required this.user,
//   });
//   final Users user;
//   @override
//   _ProfileTileState createState() => _ProfileTileState();
// }

// class _ProfileTileState extends State<ProfileTile> {
//   File _image;

//   Future getImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = image;
//     });
//   }

//   void uploadImage() {
//     addPhoto(http.Client(), _image, widget.user.user_id)
//         .then((returnCode) async {
//       if (returnCode == "200") {
//         print("Image uploaded successfully");
//       } else if (returnCode == "500") {
//         print("Please try again later");
//       }
//     }).catchError((onError) {
//       print("Could not edit data because: " + onError.toString());
//       // Navigator.of(context).pop();
//       // Navigator.pop(context);
//     });

//     // uploadPhoto(_image, widget.user.user_id).then((returnCode) {
//     //   if
//     // });
//   }

//   void _upload() {
//     if (_image == null) return;
//     String base64Image = base64Encode(_image.readAsBytesSync());
//     String fileName = _image.path.split("/").last;

//     http.post(URL_USER_UPLOAD_IMAGE + "/" + widget.user.user_id, body: {
//       "image": base64Image,
//       "name": fileName,
//     }).then((res) {
//       print(res.statusCode);
//     }).catchError((err) {
//       print(err);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       // shrinkWrap: true,
//       children: <Widget>[
//         Stack(
//           children: <Widget>[
//             CircleAvatar(
//               radius: 80.0,
//               backgroundImage: widget.user.image != null
//                   ? widget.user.provider == "Google"
//                       ? NetworkImage(
//                           widget.user.image,
//                         )
//                       : NetworkImage(
//                           GET_USER_IMAGES + widget.user.image,
//                         )
//                   : Image.asset("assets/profile.png"),
//             ),
//             Positioned(
//               bottom: 15,
//               right: 0,
//               child: CircleAvatar(
//                 child: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: getImage,
//                 ),
//               ),
//             )
//           ],
//         ),
//         Text(
//           widget.user.name,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Container(
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   _image == null
//                       ? Column(
//                           children: <Widget>[
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   CupertinoIcons.mail_solid,
//                                   color: Color(0xFF646464),
//                                 ),
//                                 Text(
//                                   widget.user.email,
//                                   style: TextStyle(
//                                       fontSize: 15.0, color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10.0),
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   CupertinoIcons.profile_circled,
//                                   size: 20.0,
//                                   color: Color(0xFF646464),
//                                 ),
//                                 Text(widget.user.gender,
//                                     style: TextStyle(
//                                         fontSize: 20.0, color: Colors.teal)),
//                               ],
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   CupertinoIcons.phone_solid,
//                                   size: 20.0,
//                                   color: Color(0xFF646464),
//                                 ),
//                                 Text(
//                                     widget.user.phone == null
//                                         ? "No phone added"
//                                         : widget.user.phone,
//                                     style: TextStyle(
//                                         fontSize: 20.0, color: Colors.teal)),
//                               ],
//                             ),
//                           ],
//                         )
//                       : Column(
//                           children: <Widget>[
//                             Image.file(_image),
//                             FlatButton(
//                               child: Text("Upload"),
//                               onPressed: () {
//                                 _upload();
//                               },
//                             )
//                           ],
//                         )
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
