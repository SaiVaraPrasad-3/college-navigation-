import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/model/app/structures.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:islington_navigation_flutter/view/overview/structures/structure_category_details.dart';

class StructureCategory extends StatefulWidget {
  @override
  _StructureCategoryState createState() => _StructureCategoryState();
}

class _StructureCategoryState extends State<StructureCategory> {
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
    categorizeAllStructures(http.Client()).then((value) {
      setState(() {
        structureList = value;
      });
    });
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      print("inside refresher setState : ");
      categorizeAllStructures(http.Client()).then((value) {
        setState(() {
          structureList = value;
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
          child: structureList != null
              ? structureList.isNotEmpty
                  ? ListView.builder(
                      itemCount: structureList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StructureCategoryTile(
                          structure: structureList[index],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No Structure added yet!!!",
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

class StructureCategoryTile extends StatefulWidget {
  StructureCategoryTile({
    @required this.structure,
  });

  final Structures structure;

  @override
  _StructureCategoryTileState createState() => _StructureCategoryTileState();
}

class _StructureCategoryTileState extends State<StructureCategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          elevation: 5.0,
          child: ListTile(
            title: Text(widget.structure.structure_type),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return StructureCategoryDetail(
            category_name: widget.structure.structure_type,
          );
        }));
      },
    );
  }
}
