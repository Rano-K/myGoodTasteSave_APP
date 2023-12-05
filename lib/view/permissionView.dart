// ignore_for_file: avoid_print, camel_case_types

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:my_favorite_goodtaste_list_app/view/home.dart';
import 'package:permission_handler/permission_handler.dart';

class Permission_View extends StatefulWidget {
  const Permission_View({super.key});
  @override
  State<Permission_View> createState() => _Permission_ViewState();
}

// ignore: camel_case_types
class _Permission_ViewState extends State<Permission_View> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/BigSizeLogo.png'),
              radius: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 300,
              child: const Center(
                child: Text(
                  '맛집저장을 이용하기 위해 \n아래 권한을 허용해주세요.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),

            //Divider
            Container(
                width: 300,
                child: Divider(
                    color: const Color.fromARGB(255, 253, 94, 35),
                    thickness: 2.0)),

            //camera권한블럭>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            const SizedBox(
              width: 300,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('images/permission_camera_icon.png'),
                    radius: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '카메라',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '즉시 촬영 후 맛집 저장리스트를 작성하는 과정에서 반드시 필요한 권한입니다.',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<camera권한블럭 끝
            SizedBox(
              height: 10,
            ),
            //gallery권한블럭 시작>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            Container(
              width: 300,
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('images/permission_gallery_icon.png'),
                    radius: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '앨범',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '핸드폰 앨범에서 사진을 불러와 맛집 저장리스트를 작성하는 과정에서 반드시 필요한 권한입니다.',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Gallery권한블럭 끝
            SizedBox(
              height: 10,
            ),
            //위치권한블럭 시작>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            Container(
              width: 300,
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('images/permission_location_icon.png'),
                    radius: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '위치권한',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '현재 위치정보를 가져와 맛집map에 표시하는 과정에서 반드시 필요한 권한입니다.',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Gallery권한블럭 끝
            IconButton.filled(
                onPressed: allPermission, icon: const Icon(Icons.check))
          ],
        ),
      ),
    );
  }

  //=================Function====================

  /*
    1. 카메라 촬영(Permission handler 사용)
    2. 앨범 권한(Permission handler 사용)
    3. 위치 권한(Geolocator 사용)
  */
  /// 모든 권한 체크후 다음으로 넘어갈 것.
  allPermission() async {
    var statusCamera = await Permission.camera.status; //카메라 권한 체크
    var statusPhoto = await Permission.photos.status; //앨범 권한 체크
    var statusLocation = await Geolocator.checkPermission();

    // 모든 권한이 허용되었는지 확인
    if (statusCamera.isGranted &&
        statusPhoto.isGranted &&
        (statusLocation == LocationPermission.whileInUse ||
            statusLocation == LocationPermission.always)) {
      // 모든 권한이 허용된 경우 Home으로 이동
      Get.off(const Home());
    } else {
      // 권한 중 하나라도 거부된 경우, 각 권한 요청
      if (!statusCamera.isGranted) {
        await Permission.camera.request();
      }
      if (!statusPhoto.isGranted) {
        await Permission.photos.request();
      }
      if (statusLocation == LocationPermission.denied ||
          statusLocation == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
      // 모든 권한을 다시 확인 후 여전히 거부된 권한이 있다면 에러 대화상자 표시
      if (!statusCamera.isGranted ||
          !statusPhoto.isGranted ||
          (statusLocation != LocationPermission.whileInUse &&
              statusLocation != LocationPermission.always)) {
        errorDialog();
      }
    }
  }

  /// 3. 사용자의 위치를 허용하시겠습니까?
  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('사용자가 위치 권한을 거부했습니다');
        errorDialog();
      } else {
        print('위치 권한이 부여되었습니다.');
        Get.to(const Home());
      }
    } else if (permission == LocationPermission.deniedForever) {
      print('위치 권한이 영구적으로 거부되어있습니다');
      errorDialog();
    } else {
      print('위치 권한이 이미 부여되었거나, 사용자가 권한 요청을 수락했습니다. 위치 관련 작업을 계속할 수 있습니다.');
      setState(() {
        const Home();
      });
    }
  }

  /// 앱사용불가 팝업알림
  /// OK 버튼 => appSettings로 넘어가게
  errorDialog() {
    Get.defaultDialog(
        title: '앱 사용 불가',
        middleText: '모든 권한을 허용하지 않으면 앱이용이 불가능합니다. 권한을 허용해주세요',
        barrierDismissible: false,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text('설정으로 이동'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('뒤로가기'),
              ),
            ],
          ),
        ]);
  }

  //현재위치 가져오기
  // getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.best,
  //           forceAndroidLocationManager: true)
  //       .then((position) {
  //     currentPosition = position;
  //     lat = currentPosition.latitude;
  //     lng = currentPosition.longitude;
  //     setState(() {
  //       //print
  //       print(lat.toString() + ":" + lng.toString());
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
}



