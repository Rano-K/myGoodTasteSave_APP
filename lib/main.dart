import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_favorite_goodtaste_list_app/view/home.dart';
import 'package:my_favorite_goodtaste_list_app/view/permissionView.dart';
import 'package:my_favorite_goodtaste_list_app/view/testPermission_handler.dart';

// import 'view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'MBC 1961 OTF M',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Permission_View(),
      debugShowCheckedModeBanner: false,
    );
  }
}



/*

  앱 수정 방향 : 모든 권한이 허용되어 있을 경우 Permission_View()가 보이는게 아니라
  home.dart가 보이도록 만들어야겠다.

  perminssionView()를 view, viewModel, model로 바꿀 필요가 있음.

*/

