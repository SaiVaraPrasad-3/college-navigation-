import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/constants.dart';
import 'package:islington_navigation_flutter/model/app/structures.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class BlockStructure extends StatefulWidget {
  BlockStructure({
    @required this.structure_type,
    @required this.block_id,
    @required this.block_name,
  });

  final String structure_type;
  final String block_name;
  final int block_id;

  @override
  _BlockStructureState createState() => _BlockStructureState();
}

class _BlockStructureState extends State<BlockStructure> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  List<Structures> structureList;

  @override
  void initState() {
    super.initState();
    print(widget.structure_type + widget.block_id.toString());
    getStructureByStructureTypeAndBlockId(
            http.Client(), widget.structure_type, widget.block_id)
        .then((value) {
      setState(() {
        structureList = value;
      });
    });
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      print("inside refresher setState : ");
      getStructureByStructureTypeAndBlockId(
              http.Client(), widget.structure_type, widget.block_id)
          .then((value) {
        setState(() {
          structureList = value;
        });
      });
    });

    Future.delayed(Duration(seconds: 2));
    // print("inside refresher : ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.structure_type),
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
                  ? ListView.builder(
                      itemCount: structureList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StructureDetailTile(
                          structures: structureList[index],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No Structure assigned to this category!!!",
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

class StructureDetailTile extends StatefulWidget {
  StructureDetailTile({
    @required this.structures,
  });

  Structures structures;

  @override
  _StructureDetailTileState createState() => _StructureDetailTileState();
}

class _StructureDetailTileState extends State<StructureDetailTile> {
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
  }
}
