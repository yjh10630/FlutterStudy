class ResponseMyPageInfo {
  String? comment;
  String? createTime;
  String? email;
  String? height;
  String? img;
  String? name;
  String? sex;
  String? weight;
  String? uid;
  String? age;
  String? position;
  List<LocationInfo>? activeArea;

  ResponseMyPageInfo(
      {this.comment,
      this.createTime,
      this.email,
      this.height,
      this.img,
      this.name,
      this.sex,
      this.weight,
      this.uid,
      this.age,
      this.position,
      this.activeArea});

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'createTime': createTime,
      'email': email,
      'height': height,
      'img': img,
      'name': name,
      'sex': sex,
      'weight': weight,
      'uid': uid,
      'age': age,
      'position': position,
      'activeArea': activeArea
    };
  }
}

class LocationInfo {
  String? si;
  String? gu;
  String? siDescription;
  String? guDescription;
  getLocationTxt() => '${siDescription} - ${guDescription}';
}

class MyPageDataSet {
  MyPageViewType viewType;
  String? value;
  String? hint;
  bool isReadOnly;
  List<MyPageDataSet>? list;
  MyPageDataSet({required this.viewType, this.hint, this.value, this.isReadOnly = false, this.list});
}

enum MyPageViewType {
  myPageImage,
  myPageName,
  myPageHeightWeightSex,  // 키, 몸무게, 성별
  myPageHeight,
  myPageWeight,
  myPageSex,
  myPageDivider,
  myPageActiveArea,
  myPageAdd,
  myPageClubType,
  myPagePositionAge, // 포지션, 나이
  myPagePosition,
  myPageAge,
  myPageMessage,
  myPageEmpty
}

List<MyPageDataSet> myPageContents = <MyPageDataSet>[
  MyPageDataSet(viewType: MyPageViewType.myPageImage),
  MyPageDataSet(viewType: MyPageViewType.myPageName, hint: '이름'),
  MyPageDataSet(viewType: MyPageViewType.myPageHeightWeightSex,
      list: [
        MyPageDataSet(viewType: MyPageViewType.myPageHeight, hint: '키', isReadOnly: true),
        MyPageDataSet(viewType: MyPageViewType.myPageWeight, hint: '몸무게', isReadOnly: true),
        MyPageDataSet(viewType: MyPageViewType.myPageSex, hint: '성별', isReadOnly: true),
      ]),
  MyPageDataSet(viewType: MyPageViewType.myPagePositionAge,
      list: [
        MyPageDataSet(viewType: MyPageViewType.myPagePosition, hint: '포지션', isReadOnly: true),
        MyPageDataSet(viewType: MyPageViewType.myPageAge, hint: '출생연도', isReadOnly: true),
      ]),
  MyPageDataSet(viewType: MyPageViewType.myPageDivider, hint: '활동지역 최소 1개 최대 3개 까지 등록 가능'),
  MyPageDataSet(viewType: MyPageViewType.myPageActiveArea, hint: '활동지역', isReadOnly: true),
  MyPageDataSet(viewType: MyPageViewType.myPageMessage, hint: '간단하게 하고싶은말'),
];

List<String> getSelectorList(MyPageViewType viewType) {
  switch(viewType) {
    case MyPageViewType.myPageHeight: return _heightList;
    case MyPageViewType.myPageWeight: return _weightList;
    case MyPageViewType.myPageSex: return _sexList;
    case MyPageViewType.myPagePosition: return _positionList;
    case MyPageViewType.myPageAge: return _birthList;
    case MyPageViewType.myPageActiveArea: return ['커스텀 예정'];
    default: return [];
  }
}

String getSelectorTitle(MyPageViewType viewType) {
  switch(viewType) {
    case MyPageViewType.myPageHeight: return '키를 선택해 주세요.';
    case MyPageViewType.myPageWeight: return '몸무게를 선택해주세요.';
    case MyPageViewType.myPageSex: return '성별을 선택해주세요.';
    case MyPageViewType.myPagePosition: return '포지션을 선택해주세요.';
    case MyPageViewType.myPageAge: return '출생연도를 선택해주세요.';
    case MyPageViewType.myPageActiveArea: return '활동지역을 선택해주세요.';
    default: return '';
  }
}

List<String> _heightList = List<String>.generate(80, (index) => "${index + 131}").toList();
List<String> _weightList = List<String>.generate(80, (index) => "${index + 41}").toList();
List<String> _sexList = ['남자', '여자'].toList();
List<String> _positionList = ['포인트가드 [1]', '슈팅가드 [2]', '스몰포워드 [3]', '파워포워드 [4]', '센터 [5]'].toList();
List<String> _birthList = [for (var i = 1960; i <= DateTime.now().year; i++) i.toString()].toList();
