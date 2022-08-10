import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:study_flutter/utils/constants.dart';

import 'login/init_login_page.dart';
import 'login/login_page.dart';
import 'main_page.dart';

//https://dev-yakuza.posstree.com/ko/flutter/splash-screen/
Future<void> main() async {
  bool isGoToNext = await initInfoData();
  if(isGoToNext) {
    // Main or initLogin
    runApp(MyApp(screenType: ScreenType.initLogin));
  } else {
    //todo dialog finish
  }
}

Future<bool> initInfoData() async {
  /*final appInfo = await _getAppInfo();
  final response = await http.get(Uri.parse('${apiBaseUrl}/init/initInfo'));
  var initInfo = jsonDecode(response.body) as ResponseInitInfo;

  // 버전 체크
  if (_isAppVersionNew(initInfo.versionInfo?.appNewVersion ?? '1.0.0', appInfo.version)) {
    //todo app update popup show
  }*/

  /*if (isLogin) {
    if (myPageInfo.isEmpty()) {
      //myPage
    } else {
      //Main
    }
  } else {
    //initLoginState
  }*/

  bool data = false;

  // Change to API call
  await Future.delayed(Duration(seconds: 1), () {
    data = true;
  });

  return data;
}

bool _isAppVersionNew(String serverVersion, String appVersion) {
  var returnValue = false;
  var server = serverVersion.split('.');
  var appVer = appVersion.split('.');
  for (int i = 0; i < server.length; i++) {
    if (i < appVer.length) {
      if (int.parse(server[i]) > int.parse(appVer[i])) {
        returnValue = true;
      } else {
        continue;
      }
    }
  }
  return returnValue;
}

Future<PackageInfo> _getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return info;
}

class MyApp extends StatelessWidget {
  final ScreenType screenType;
  const MyApp({Key? key, required this.screenType}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationNextScreen(screenType: screenType),
    );
  }
}

class NavigationNextScreen extends StatefulWidget {
  final ScreenType screenType;
  const NavigationNextScreen({Key? key, required this.screenType}) : super(key: key);

  @override
  _NavigationNextScreenState createState() => _NavigationNextScreenState();
}

class _NavigationNextScreenState extends State<NavigationNextScreen> {
  Widget screenView = const LoginPage(pageIndex: 1,);

  @override
  void initState() {
    if (widget.screenType == ScreenType.initLogin) {
      screenView = const LoginPage(pageIndex: 1,);
    } else {
      screenView = MainPage();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: screenView,
      ),
    );
  }

}