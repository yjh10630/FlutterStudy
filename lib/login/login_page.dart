import 'package:flutter/material.dart';
import '../dialog/common_dialog.dart';
import '../mypage/my_page.dart';
import '../utils/color_palette.dart';

const _pageDuration = Duration(milliseconds: 200);

class LoginPage extends StatefulWidget {
  final int pageIndex;
  const LoginPage({Key? key, required this.pageIndex}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //final _pageController = PageController();
  late PageController _pageController;

  final _joinFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final _searchFormKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final Map<String, TextEditingController> _controllerMap = {};
  final Map<String, FocusNode> _focusNodeMap = {};

  @override
  void initState() {
    super.initState();
    _focusNodeMap['join_email'] = FocusNode();
    _focusNodeMap['join_pw'] = FocusNode();
    _focusNodeMap['login_email'] = FocusNode();
    _focusNodeMap['login_pw'] = FocusNode();
    _focusNodeMap['forgot_email'] = FocusNode();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _focusNodeMap.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(widget.pageIndex);
      }
    });
    super.didChangeDependencies();
  }

  void _unFocus() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _unFocus();
          },
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              _JoinAndLoginScreen(
                isObscure: _isObscure,
                joinKey: _joinFormKey,
                focusNodeMap: _focusNodeMap['join_email'],
                controllerMap: _controllerMap['join_email'],
                pageController: _pageController,
                googleLoginBtnCallback: () {},
                mainBtnCallback: () {},
                passWordViewCallback: () {
                  setState((){
                    _isObscure = !_isObscure;
                  });
                },
                txtBtnLeftCallback: () {},
                txtBtnRightCallback: () {
                  _unFocus();
                  _pageController.nextPage(duration: _pageDuration, curve: Curves.easeIn);
                },
                isJoinScreen: true,
              ),
              _JoinAndLoginScreen(
                isObscure: _isObscure,
                joinKey: _loginFormKey,
                focusNodeMap: _focusNodeMap['login_email'],
                controllerMap: _controllerMap['login_email'],
                pageController: _pageController,
                googleLoginBtnCallback: () {},
                mainBtnCallback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyPage())
                  );
                },
                passWordViewCallback: () {
                  setState((){
                    _isObscure = !_isObscure;
                  });
                },
                txtBtnLeftCallback: () {
                  _unFocus();
                  _pageController.previousPage(duration: _pageDuration, curve: Curves.easeIn);
                },
                txtBtnRightCallback: () {
                  _unFocus();
                  _pageController.nextPage(duration: _pageDuration, curve: Curves.easeIn);
                },
                isJoinScreen: false,
              ),
              _FindPasswordScreen(
                findKey: _searchFormKey,
                focusNodeMap: _focusNodeMap['forgot_email'],
                controllerMap: _controllerMap['forgot_email'],
                sendEmailCallback: (){
                  showTestDialog(
                      context,
                      '비밀번호 변경 메일은 전송했습니다.',
                      '확인',
                      '취소',
                          () {
                        _pageController.previousPage(duration: _pageDuration, curve: Curves.easeIn);
                        Navigator.pop(context);
                      },
                          () {
                        Navigator.pop(context);
                      }
                  );
                },
                goToLoginCallback: (){
                  _unFocus();
                  _pageController.previousPage(duration: _pageDuration, curve: Curves.easeIn);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FindPasswordScreen extends StatelessWidget {
  const _FindPasswordScreen({
    required this.findKey,
    required this.focusNodeMap,
    required this.controllerMap,
    required this.sendEmailCallback,
    required this.goToLoginCallback
  });

  final GlobalKey<FormState> findKey;
  final FocusNode? focusNodeMap;
  final TextEditingController? controllerMap;
  final VoidCallback sendEmailCallback;
  final VoidCallback goToLoginCallback;


  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
          padding: const EdgeInsets.only(top: 50),
          color: Colors.white,
          child: Column(
            children: [
              const Text(
                '아이디 / 비밀번호 찾기',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xDE000000)
                ),
              ),
              const Text(
                '찾으려는 사용자의 이메일을 입력하세요.',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Color(0x8A000000)
                ),
              ),
              Form(
                key: findKey,
                child: Container(
                  margin: const EdgeInsets.only(top: 30, left: 24, right: 24),
                  child: TextFormField(
                    validator: (value) {
                      if (value?.isEmpty == true) { return '입력해주세요'; }
                      return null;
                    },
                    controller: controllerMap,
                    focusNode: focusNodeMap,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.send,
                    cursorColor: Palette.colorPrimaryText,
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                            Icons.account_circle_rounded,
                            color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        labelText: 'E-mail',
                        labelStyle: TextStyle(
                            color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                                color: Palette.colorPrimaryText,
                                width: 1.5
                            )
                        )
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top:10, left: 24, right: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _SimpleBtn(
                      name: '보내기',
                      callback : () {
                        if (findKey.currentState?.validate() == true) {
                          sendEmailCallback();
                        }
                      }),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24),
                alignment: Alignment.centerLeft,
                child: _SimpleTxtBtn(
                    name: '로그인 하러 가기',
                    callback: goToLoginCallback),
              )
            ],
          )
      ),
    );
  }
}

class _JoinAndLoginScreen extends StatelessWidget {
  const _JoinAndLoginScreen({
    required this.isObscure,
    required this.joinKey,
    required this.focusNodeMap,
    required this.controllerMap,
    required this.pageController,
    required this.googleLoginBtnCallback,
    required this.mainBtnCallback,
    required this.passWordViewCallback,
    required this.txtBtnLeftCallback,
    required this.txtBtnRightCallback,
    required this.isJoinScreen
  });

  final bool isObscure;
  final GlobalKey<FormState> joinKey;
  final FocusNode? focusNodeMap;
  final TextEditingController? controllerMap;
  final PageController pageController;
  final VoidCallback googleLoginBtnCallback;
  final VoidCallback mainBtnCallback;
  final VoidCallback passWordViewCallback;
  final VoidCallback txtBtnLeftCallback;
  final VoidCallback txtBtnRightCallback;
  final bool isJoinScreen;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
          padding: const EdgeInsets.only(top: 50),
          color: Colors.white,
          child: Column(
            children: [
              _HeaderTitleAndSnsLoginBtn(
                  title: isJoinScreen ? '회원가입' : '로그인',
                  callback: googleLoginBtnCallback),
              Form(
                  key: joinKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 24, right: 24),
                        child: TextFormField(
                          validator: (value) {
                            if (value?.isEmpty == true) { return '입력해주세요'; }
                            if(isValidateEmail(value!)){ return '잘못된 이메일 형식입니다.'; }
                            return null;
                          },
                          focusNode: focusNodeMap,
                          controller: controllerMap,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: Palette.colorPrimaryText,
                          cursorWidth: 1.5,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                  Icons.account_circle_rounded,
                                  color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0))
                              ),
                              labelText: 'E-mail',
                              labelStyle: TextStyle(
                                  color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(
                                      color: Palette.colorPrimaryText,
                                      width: 1.5
                                  )
                              )
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 24, right: 24),
                        child: TextFormField(
                          validator: (value) {
                            if (value?.isEmpty == true) { return '입력해주세요'; }
                            if (isValidatePwd(value!)) { return '비밀번호 형식에 맞춰 주세요'; }
                            return null;
                          },
                          focusNode: focusNodeMap,
                          controller: controllerMap,
                          obscureText: isObscure,
                          maxLength: 16,
                          textInputAction: TextInputAction.done,
                          cursorColor: Palette.colorPrimaryText,
                          cursorWidth: 1.5,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0))
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                    color: Palette.colorPrimaryText,
                                    width: 1.5
                                )
                            ),
                            helperText: '8 ~ 16 자, 문자, 특수 기호 모두포함.',
                            suffixIcon: IconButton(
                              icon: Icon(
                                  isObscure ? Icons.visibility : Icons.visibility_off,
                                  color: focusNodeMap?.hasFocus == true ? Palette.colorPrimaryText : Palette.colorSecondaryText
                              ),
                              onPressed: passWordViewCallback,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:10, left: 24, right: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: _SimpleBtn(
                            name: isJoinScreen ? '회원가입' : '로그인',
                            callback: () async {
                              if (isJoinScreen) {
                                /*if (joinKey.currentState?.validate() == true) {
                                  showTestDialog(
                                      context,
                                      '인증 메일을 보내드렸습니다.\n확인 후 인증하여 회원가입을 완료해 주세요.',
                                      '확인',
                                      '취소',
                                          () {
                                        pageController.nextPage(duration: _pageDuration, curve: Curves.easeIn);
                                        Navigator.pop(context);
                                      },
                                          () {
                                        Navigator.pop(context);
                                      }
                                  );
                                }*/
                                showTestDialog(
                                    context,
                                    '인증 메일을 보내드렸습니다.\n확인 후 인증하여 회원가입을 완료해 주세요.',
                                    '확인',
                                    '취소',
                                        () {
                                      pageController.nextPage(duration: _pageDuration, curve: Curves.easeIn);
                                      Navigator.pop(context);
                                    },
                                        () {
                                      Navigator.pop(context);
                                    }
                                );
                              } else {
                                mainBtnCallback();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isJoinScreen ? Container() : _SimpleTxtBtn(
                        name: '간편 회원 가입',
                        callback: txtBtnLeftCallback),
                    _SimpleTxtBtn(
                        name: isJoinScreen ? '로그인 하러 가기' : '아이디 / 비밀번호 찾기',
                        callback: txtBtnRightCallback)
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

bool isValidateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return !regex.hasMatch(value);
}

bool isValidatePwd(String value) {
  String pattern =
      r'^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&]).{8,15}.$';
  RegExp regex = RegExp(pattern);
  return !regex.hasMatch(value);
}

class _HeaderTitleAndSnsLoginBtn extends StatelessWidget {
  const _HeaderTitleAndSnsLoginBtn({
    Key? key, required this.title, required this.callback
  }): super(key: key);

  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xDE000000)
          ),
        ),
        const Text(
          'with your social network',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color(0x8A000000)
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top:5, left: 24, right: 24),
          child: SizedBox(
              width: double.infinity,
              height: 48,
              child: _SimpleBtn(
                  name: '구글 로그인',
                  callback: callback
              )
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top:10),
          child: const Text(
            'or',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Color(0x8A000000)
            ),
          ),
        )
      ],
    );
  }
}

class _SimpleTxtBtn extends StatelessWidget {
  const _SimpleTxtBtn({
    Key? key, required this.name, required this.callback
  }): super(key: key);

  final String name;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      child: Text(
        name,
        style: const TextStyle(
            color: Color(0x8A000000),
            fontSize: 15,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

class _SimpleBtn extends StatelessWidget {
  const _SimpleBtn({
    Key? key,
    required this.name, required this.callback
  }): super(key: key);

  final String name;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: const Color(0xff525f6f)
      ),
      onPressed: callback,
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}