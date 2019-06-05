import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/view/overview/blocks/block_structure.dart';
import 'package:islington_navigation_flutter/model/app/structures.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class BlocksDetails extends StatefulWidget {
  BlocksDetails(
      {this.block_id,
      this.block_name,
      this.latitude,
      this.longitude,
      this.image});

  int block_id;
  String block_name;
  double latitude;
  double longitude;
  String image;

  @override
  _BlocksDetailsState createState() => _BlocksDetailsState();
}

class _BlocksDetailsState extends State<BlocksDetails> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  List<Structures> structureList;
  String structure_type = "";
  int number = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categorizeStructures(http.Client(), widget.block_id).then((value) {
      setState(() {
        structureList = value;
      });
    });
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      print("inside refresher setState : ");
      categorizeStructures(http.Client(), widget.block_id).then((value) {
        setState(() {
          structureList = value;
        });
      });
    });

    Future.delayed(Duration(seconds: 2));
    // print("inside refresher : ");
  }

  List<Widget> _buildGridTiles(dynamic data, int block_id, String block_name) {
    List<Widget> widgets = new List<Widget>.generate(data.length, (int index) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: BlockDetailsTile(
            structures: data[index],
            block_id: block_id,
            block_name: block_name),
      );
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.block_name),
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
          child: structureList != null
              ? structureList.isNotEmpty
                  ? GridView.count(
                      addRepaintBoundaries: true,
                      padding: EdgeInsets.all(20.0),
                      crossAxisCount: 2,
                      // crossAxisSpacing: 4.0,
                      scrollDirection: Axis.vertical,
                      //mainAxisSpacing: 1.0,
                      children: _buildGridTiles(
                          structureList, widget.block_id, widget.block_name))
                  : Center(
                      child: Text(
                        "No Structure assigned to this block!!!",
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
        ));
  }
}

class BlockDetailsTile extends StatefulWidget {
  BlockDetailsTile({
    @required this.structures,
    @required this.block_id,
    @required this.block_name,
  });

  Structures structures;
  int block_id;
  String block_name;

  @override
  _BlockDetailsTileState createState() => _BlockDetailsTileState();
}

class _BlockDetailsTileState extends State<BlockDetailsTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              elevation: 10.0,
              child: Column(
                // alignment: Alignment(0.0, 1.0),
                children: <Widget>[
                  Text(widget.structures.structure_id.toString()),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        widget.structures.structure_type,
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) {
                    return BlockStructure(
                        structure_type: widget.structures.structure_type,
                        block_id: widget.block_id,
                        block_name: widget.block_name);
                  },
                ),
              );
            }));
  }
}
