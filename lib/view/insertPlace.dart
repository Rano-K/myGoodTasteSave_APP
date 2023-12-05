import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_favorite_goodtaste_list_app/model/place.dart';
import 'package:my_favorite_goodtaste_list_app/model/database_handeler.dart';
import 'package:my_favorite_goodtaste_list_app/view/home.dart';

class InsertPlace extends StatefulWidget {
  const InsertPlace({super.key});

  @override
  State<InsertPlace> createState() => _InsertPlaceState();
}

class _InsertPlaceState extends State<InsertPlace> {
  late DatabaseHandler handler;
  late TextEditingController nameController;
  late TextEditingController estimateController;

  //map
  late MapController mapController;
  late List location; //여기에 내 list를 담아줄 예정이나 card에서 입력한 값이 들어가야 한다.

  //location
  late Position currentPosition; //현재위치 저장
  late int kindChoice; //몇번째 버튼 클릭중인지

  late String name;
  late String estimate;
  late double lat;
  late double lng;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  late DateTime actionDate;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nameController = TextEditingController();
    estimateController = TextEditingController();
    mapController = MapController();
    location = [];
    kindChoice = 0;
    checkLocationPermission();
    actionDate = DateTime.now();
    print(actionDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('맛집추가', style: TextStyle(fontWeight: FontWeight.bold),)),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getImageFromGallery(ImageSource.gallery)!;
                    },
                    child: const Text('Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getImageFromGallery(ImageSource.camera)!;
                    },
                    child: const Text('Camera'),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 380,
                    height: 200,
                    color: Colors.grey,
                    child: Center(
                      child: imageFile == null
                          ? const Text("Image is not selected")
                          : Image.file(File(imageFile!.path)),
                    ),
                  ),
                  if (imageFile != null)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          imageFile = null; // 이미지 파일을 null로 설정합니다.
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              //name start<<<<<<<<<<<<<<<<<<<<<<<<<
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: '이름',
                    labelStyle: TextStyle(color: Colors.amber),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ), //>>>>>>>>>>>>>>>>>>>>>>name end
              //estimate start<<<<<<<<<<<<<<<<<<<<<<<<<
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: estimateController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        hintText: '평가',
                        labelStyle: TextStyle(color: Colors.amber),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  RatingBar.builder(
            
                    
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      // ignore: avoid_print
                      print(rating);
                    },
                  ),
                ],
              ),
            
              //>>>>>>>>>>>>>>>>>>>>estimate End
            
              ElevatedButton(
                onPressed: () {
                  insertAction();
                },
                child: const Text('입력'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  //================================================
  //--------------------Function--------------------
  //================================================
  getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path); //image경로/
      setState(() {});
    }
  }

  // getCamera(ImageSource imageSource)async{
  //   final XFile? takingCamera = await picker.

  // }

  insertAction() async {
    
    name = nameController.text;
    estimate = estimateController.text;

    // name, imageFile이 null일 경우
    if (name.isEmpty || imageFile == null) {
      _showErrorDialog();
      return;
    }

    //File타입을 Byte 타입으로 변환하기. 왜냐하면 blob은 전부 byte타입이므로. Uint8List
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var addressInsert = Place(
      name: name,
      estimate: estimate,
      lat: lat,
      lng: lng,
      image1: getImage,
      actiondate: actionDate,
    );


    
    await handler.insertPlace(addressInsert); //handler에 image넣기.
    _showDialog();
  }

  //모든 정보가 정상적으로 입력 되었을 때 보여줄 메세지
  _showDialog() {
    Get.defaultDialog(
        title: '입력 결과',
        middleText: '입력이 완료되었습니다.',
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          )
        ]);
  }

  //lat,lng외 정보가 입력되지 않았을 때 보여줄 메시지
  _showErrorDialog(){
    Get.defaultDialog(
      title: 'Error',
      middleText: '사진은 최소 1장, 이름은 반드시 입력해주세요.',
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: (){
            Get.back();
          }, 
          child: const Text('Ok'),
        ),
      ]

    );
  }

  //------Map FUNCTION-------

  //사용자의 위치를 허용하시겠습니까? 에서 세가지 선택지에 대한 답변
  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((position) {
      currentPosition = position;
      lat = currentPosition.latitude;
      lng = currentPosition.longitude;
      setState(() {
        //print
        print(lat.toString() + ":" + lng.toString());
      });
    }).catchError((e) {
      print(e);
    });
  }

  
}//END