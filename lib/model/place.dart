import 'dart:typed_data';



class Place{
  final int? id; //autoincrement
  final String name;
  final String estimate;
  final double lat;
  final double lng;
  final Uint8List image1;
  final DateTime? actiondate;
  final double rating;

  Place(
    {
      this.id, //optional이라 required가 필요없다.
      required this.name,
      required this.estimate,
      required this.lat,
      required this.lng,
      required this.image1,
      required this.actiondate,
      required this.rating,
    
      
    }
  );

//생성자가 생성자를 부르는 방법
  // factory Address.fromMap(Map<String, dynamic> res){
  //   return Address(
  //     id: res['id'],
  //     name: res['name'],
  //     image: res['image']
  //   );
  // }
//위의 주석과 완전 동일한 방법. flutter에만 존재하는 key값 활용.
  Place.fromMap(Map<String, dynamic> res)
    : id=res['id'],
      name=res['name'],
      estimate=res['estimate'],
      lat=res['lat'],
      lng=res['lng'],
      image1=res['image1'],
      actiondate=DateTime.parse(res['actiondate']),
      rating = res['rating'];


}