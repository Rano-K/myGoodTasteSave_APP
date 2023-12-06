import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_favorite_goodtaste_list_app/model/place.dart';

class DatabaseHandler{
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'goodtastelist.db'),//위치잡아주는게 path
      onCreate: (database, version) async { //app실행시 db없을 때 만들어 준다. 만들어져있으면 oncreate안함.
        await database.execute(
          "create table goodtastelist(id integer primary key autoincrement, name text not null, estimate text, lat real, lng real, image1 blob, actiondate text, rating integer)"
        ) ;
      } ,
      version: 1
    );
  }// name, estimate, lat, lng, image1~image5, actiondate

  //insert문
  //입력이 잘 되어있는지 확인하려면 future로 확인한다. future로 함수 선언시 return값 필요.
  insertPlace(Place place)async{
    final Database db = await initializeDB();
    await db.rawInsert(
      "insert into goodtastelist(name, estimate, lat, lng, image1, actiondate, rating ) values (?,?,?,?,?,datetime('now', 'localtime'),?)",
      [
        place.name,
        place.estimate,
        place.lat,
        place.lng,
        place.image1,
      ]
    );
  }

  //select문.
  Future<List<Place>> queryPlace() async{
    final Database db = await initializeDB(); //DB연결
    final List<Map<String, Object?>> queryResult = await db.rawQuery('select * from goodtastelist');
    //이제 쿼리리절트 가져온거 가지고 Map address에 넣어줄 예정
    return queryResult.map((e) => Place.fromMap(e)).toList();//Map을 List로 변환.
  }

  //update문
  Future updatePlace(Place place) async{
    final Database db = await initializeDB();
    await db.rawUpdate(
      'update goodtastelist set name=?, estimate=?, lat=?, lng=?, image1=?, actiondate = datetime("now", "localtime") where id=?, rating =?',
      [
        place.name,
        place.estimate,
        place.lat,
        place.lng,
        place.image1,
        place.id,
        place.rating,
      ]
    );
  }

  //delete문
  Future<int> deletePlace(Place place)async{
    final Database db = await initializeDB();//DB연결
    int removeResult = await db.rawDelete(
      'delete from address where id=?',
      [
        place.id,
      ]
    );
    return removeResult;
  }

  //searchAction


}