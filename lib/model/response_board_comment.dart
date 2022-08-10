class ResponseBoardComment {
  WriteUserInfo? writeUserInfo;
  String? createTime;
  String? comment;

  ResponseBoardComment({this.writeUserInfo, this.createTime, this.comment});

  ResponseBoardComment.fromJson(Map<String, dynamic> json) {
    writeUserInfo = json['writeUserInfo'] != null
        ? WriteUserInfo.fromJson(json['writeUserInfo'])
        : null;
    createTime = json['createTime'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (writeUserInfo != null) {
      data['writeUserInfo'] = writeUserInfo!.toJson();
    }
    data['createTime'] = createTime;
    data['comment'] = comment;
    return data;
  }
}

class WriteUserInfo {
  String? userImg;
  String? userName;

  WriteUserInfo({this.userImg, this.userName});

  WriteUserInfo.fromJson(Map<String, dynamic> json) {
    userImg = json['userImg'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userImg'] = userImg;
    data['userName'] = userName;
    return data;
  }
}
