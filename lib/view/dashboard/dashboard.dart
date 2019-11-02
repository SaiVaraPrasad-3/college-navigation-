// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter/material.dart';
// import 'package:islington_navigation_flutter/controller/utils/check_authorization.dart';
// import 'package:islington_navigation_flutter/view/overview/overview_home.dart';

// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   Widget myTiles(
//       IconData iconData, String heading, int color, Widget className) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//           return className;
//         }));
//       },
//       child: Material(
//         color: Color(color),
//         elevation: 15.0,
//         shadowColor: Color(0x802196F3),
//         borderRadius: BorderRadius.circular(24.0),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     //text
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         heading,
//                         style: TextStyle(color: Colors.white, fontSize: 20.0),
//                       ),
//                     ),
//                     //icon
//                     Material(
//                       color: Color(color),
//                       borderRadius: BorderRadius.circular(25.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Icon(
//                           iconData,
//                           color: Colors.white,
//                           size: 40.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StaggeredGridView.count(
//       crossAxisCount: 2,
//       crossAxisSpacing: 10.0,
//       mainAxisSpacing: 10.0,
//       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       children: <Widget>[
//         myTiles(Icons.school, "Bachelor", 0xffed622b, OverviewHome()),
//         myTiles(
//             Icons.local_library,
//             "Plus Two",
//             0xff26cb3c,
//             CategoryPage(
//               title: "Plus Two Colleges",
//             )),
//         myTiles(
//             Icons.import_contacts,
//             "News",
//             0xffff3266,
//             HomePage(
//               title: "News",
//             )),
//         myTiles(Icons.person, "Profile", 0xff3399fe, CheckAuth()),
//         myTiles(
//             Icons.group_work,
//             "Group Work",
//             0xff622f74,
//             HomePage(
//               title: "Gropu Work",
//             )),
//       ],
//       staggeredTiles: [
//         StaggeredTile.extent(2, 130.0),
//         StaggeredTile.extent(2, 130.0),
//         StaggeredTile.extent(1, 130.0),
//         StaggeredTile.extent(1, 130.0),
//         StaggeredTile.extent(2, 240.0),
//       ],
//     );
//   }
// }
