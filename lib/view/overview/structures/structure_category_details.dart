import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/constants.dart';
import 'package:islington_navigation_flutter/model/app/structures.dart';

class StructureCategoryDetail extends StatefulWidget {
  StructureCategoryDetail({
    @required this.category_name,
    this.block_id,
  });

  String category_name;
  int block_id;

  @override
  _StructureCategoryDetailState createState() =>
      _StructureCategoryDetailState();
}

class _StructureCategoryDetailState extends State<StructureCategoryDetail> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  List<Structures> structureList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Category name: ${widget.category_name}");
    widget.block_id == null
        ? getAllFromCategory(http.Client(), widget.category_name).then((value) {
            setState(() {
              structureList = value;
            });
          })
        : getAllFromCategory(http.Client(), widget.category_name).then((value) {
            setState(() {
              structureList = value;
            });
          });
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      print("inside refresher setState : ");
      getAllFromCategory(http.Client(), widget.category_name).then((value) {
        setState(() {
          structureList = value;
        });
      });
    });

    Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category_name),
        centerTitle: true,
      ),
      body: EasyRefresh(
          refreshHeader: BezierCircleHeader(
            key: _headerKey,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          refreshFooter: BezierBounceFooter(
            key: _footerKey,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onRefresh: onRefresh,
          child: structureList != null
              ? structureList.isNotEmpty
                  ? ListView.builder(
                      itemCount: structureList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StructureCategoryDetailTile(
                            structures: structureList[index]);
                      },
                    )
                  : Center(
                      child: Text(
                        "No structure added yet!!!",
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
                )),
    );
  }
}

class StructureCategoryDetailTile extends StatefulWidget {
  StructureCategoryDetailTile({
    @required this.structures,
  });

  final Structures structures;

  @override
  _StructureCategoryDetailTileState createState() =>
      _StructureCategoryDetailTileState();
}

class _StructureCategoryDetailTileState
    extends State<StructureCategoryDetailTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 15.0,
            borderRadius: BorderRadius.circular(25.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(widget.structures.structure_name,
                            style:
                                TextStyle(color: Colors.red, fontSize: 30.0)),
                        Text(widget.structures.block_name,
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0)),
                        IconButton(
                          color: Colors.black,
                          icon: Icon(
                            Icons.map,
                            size: 35.0,
                          ),
                          onPressed: () {
                            print("Clicked me");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(25.0),
                    child: Image(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topRight,
                      image: NetworkImage(
                        GET_STRUCTURE_IMAGES + widget.structures.images,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    // Padding(
    //   padding: EdgeInsets.all(20.0),
    //   child: Container(
    //     height: MediaQuery.of(context).size.height * 0.30,
    //     width: double.infinity,
    //     child: Card(
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    //       elevation: 15.0,
    //       child:
    //       Stack(
    //         alignment: Alignment(0.0, 0.25),
    //         children: <Widget>[
    //           widget.structures.images != null
    //               ? Image.network(
    //                   GET_STRUCTURE_IMAGES + widget.structures.images,
    //                   fit: BoxFit.fill,
    //                 )
    //               : Image.asset("assets/default_avatar.png"),
    //           Container(
    //             decoration: BoxDecoration(
    //               color: Colors.black,
    //             ),
    //             width: double.infinity,
    //             child: ListTile(
    //               title: Text(widget.structures.structure_name,
    //                   style: TextStyle(color: Colors.white)),
    //               subtitle: Text(widget.structures.block_name,
    //                   style: TextStyle(color: Colors.white)),
    //               trailing: IconButton(
    //                 color: Colors.white,
    //                 icon: Icon(
    //                   Icons.map,
    //                 ),
    //                 onPressed: () {
    //                   print("Clicked me");
    //                 },
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
