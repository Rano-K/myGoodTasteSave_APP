import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:my_favorite_goodtaste_list_app/view/insertPlace.dart';
import 'package:my_favorite_goodtaste_list_app/model/database_handeler.dart';
import 'package:my_favorite_goodtaste_list_app/model/place.dart';
import 'package:my_favorite_goodtaste_list_app/view/mapPlace.dart';
import 'package:my_favorite_goodtaste_list_app/view/updatePlace.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //field

  //searchBar(AppBar)
  late TextEditingController searchController;

  //database-SQLite
  late DatabaseHandler handler;

  //Segment Widget = 버튼 모양
  Map<int, Widget> segmentWidgets = {
    //이건 나중에 생각해야겠는데?
  };

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Get.to(const InsertPlace())!.then((value) => reloadData());
              },
              icon: const Icon(Icons.add_outlined),
            )
          ],
          title: const Center(
            child: Column(
              children: [
                Text(
                  '        My Good Expeirence',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
            future: handler.queryPlace(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Place>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.green,
                              icon: Icons.edit,
                              label: 'Edit',
                              onPressed: (context) {
                                const UpdatePlace();
                                // ignore: avoid_print
                                print("Editable");
                                Get.to(UpdatePlace());
                              },
                            ),
                            SlidableAction(
                              backgroundColor: Colors.red,
                              icon: Icons.edit,
                              label: 'Delete',
                              onPressed: (context) {
                                // DeletePlace();
                                print("Deletable");
                              },
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.amber,
                              icon: Icons.edit,
                              label: 'Map',
                              onPressed: (context) {
                                Get.to(MapPlace(lat: snapshot.data![index].lat, lng: snapshot.data![index].lng,));
                                print("Go to map");
                              },
                            ),
                          ],
                        ),
                        child: Card(
                          child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      Image.memory(
                                        snapshot.data![index].image1,
                                        width: 100,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "이름: ${snapshot.data![index].name}",
                                                overflow: TextOverflow.ellipsis,
                                                ),
                                            Text(
                                                "별점:${snapshot.data![index].rating}",
                                                overflow: TextOverflow.fade,
                                              ),
                                            Text(
                                                "평가: ${snapshot.data![index].estimate}",
                                                overflow: TextOverflow.fade,
                                                maxLines: 2,
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(snapshot.data![index].actiondate != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(snapshot.data![index].actiondate!)
                                  : 'No Date'),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  //-----Function-----
  reloadData() {
    handler.queryPlace();
    setState(() {});
  }

  
}//END