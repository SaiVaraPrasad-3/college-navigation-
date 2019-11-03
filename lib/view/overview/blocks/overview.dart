import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/constants.dart';
import 'package:islington_navigation_flutter/model/app/blocks.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:islington_navigation_flutter/view/overview/blocks/blocks.dart';

class CollegeOverview extends StatefulWidget {
  static String tag = "block-page";
  @override
  CollegeOverviewState createState() {
    return new CollegeOverviewState();
  }
}

class CollegeOverviewState extends State<CollegeOverview> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  List<Blocks> blockList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllBlocks(http.Client()).then((value) {
      setState(() {
        blockList = value;
      });
    });
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      print("inside refresher setState : ");
      fetchAllBlocks(http.Client()).then((value) {
        setState(() {
          blockList = value;
        });
      });
    });

    Future.delayed(Duration(seconds: 2));
    // print("inside refresher : ");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: EasyRefresh(
        refreshHeader: BezierCircleHeader(
          key: _headerKey,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        refreshFooter: BezierBounceFooter(
          key: _footerKey,
        ),
        onRefresh: onRefresh,
        child: blockList != null
            ? blockList.isNotEmpty
                ? ListView.builder(
                    itemCount: blockList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BlocksTile(
                        block: blockList[index],
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No block added yet!!!",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
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

class BlocksTile extends StatefulWidget {
  BlocksTile({
    @required this.block,
  });

  final Blocks block;
//  final DocumentSnapshot documentSnapshot;

  @override
  BlocksTileState createState() {
    return new BlocksTileState();
  }
}

class BlocksTileState extends State<BlocksTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.35,
                  minWidth: double.infinity,
                  maxHeight: MediaQuery.of(context).size.height * 0.35),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 14.0, left: 14.0, right: 14.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            GET_BLOCK_IMAGES + widget.block.image,
                            // fit: BoxFit.fill,
                          ),
                          fit: BoxFit.cover),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 6,
                        ),
                      ]),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0))),
                    color: Colors.black54,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                    child: Center(
                      child: Text(
                        widget.block.block_name,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocksDetails(
                    block_id: widget.block.block_id,
                    block_name: widget.block.block_name,
                    latitude: widget.block.latitude,
                    longitude: widget.block.longitude,
                    image: widget.block.image);
              }));
            },
          ),
        ],
      ),
    );
  }
}

// GestureDetector(
//       child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: Container(
//           height: MediaQuery.of(context).size.height * 0.45,
//           width: double.infinity,
//           child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0)),
//               elevation: 10.0,
//               child: Stack(alignment: Alignment(0.0, 1.0), children: <Widget>[
//                 widget.block.image != null
//                     ? Image.network(
//                         GET_BLOCK_IMAGES + widget.block.image,
//                         // fit: BoxFit.fill,
//                       )
//                     : Image.asset("assets/default_avatar.png"),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                   ),
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Text(
//                       widget.block.block_name,
//                       style: TextStyle(
//                           fontSize: 21.0,
//                           fontWeight: FontWeight.w200,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ])),
//         ),
//       ),
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return BlocksDetails(
//               block_id: widget.block.block_id,
//               block_name: widget.block.block_name,
//               latitude: widget.block.latitude,
//               longitude: widget.block.longitude,
//               image: widget.block.image);
//         }));
//       },
//     )
