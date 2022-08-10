import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResponseBoardInfo {
  String? category;
  String? title;
  String? detail;
  WriteUserInfo? writeUserInfo;
  String? reviewCount;

  String? maxCount;
  String? attendCount;
  String? date;
  String? time;
  String? location;
  List<String>? photo;

  String? createTime;
  bool? isPick;
  String? pickCount;

  String? viewCount;

  ResponseBoardInfo({
    this.category,
    this.title,
    this.detail,
    this.writeUserInfo,
    this.reviewCount,
    this.maxCount,
    this.attendCount,
    this.date,
    this.time,
    this.location,
    this.photo,
    this.createTime,
    this.isPick,
    this.pickCount,
    this.viewCount
  });

  String convertDate(String date) {

    var inputDate = DateFormat('yyyyMMddHHmmss').parse(date);
    var outputDate = '';

    var diffDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day).difference(
      DateTime(
          inputDate.year,
          inputDate.month,
          inputDate.day
      )
    ).inDays;

    if (diffDay == 0) {
      // 시간 노출
      var time = DateTime(DateTime.now().hour).difference(DateTime(inputDate.hour)).inHours;
      outputDate = time == 0 ? '방금' : '${time}시간 전';
    } else if (diffDay > 0 && diffDay < 6) {
      outputDate = '${diffDay}일 전';
    } else {
      // 여기서는 연도를 비교
      var yearDiff = DateTime(DateTime.now().year).difference(DateTime(inputDate.year)).inDays;
      outputDate = yearDiff > 365 ? DateFormat('yyyy.MM.dd').format(inputDate) : DateFormat('MM.dd').format(inputDate);
    }
    return date;

  }

  String convertCategoryToTag() {
    switch(category) {
      case 'notify':
        return '공지사항';
      case 'board':
        return '그냥';
      case 'group':
        return '같이해요';
      default: return '';
    }
  }

  Color tagColor() {
    switch(category) {
      case 'notify':
        return Colors.redAccent;
      case 'board':
        return Colors.white.withOpacity(0.5);
      case 'group':
        return Colors.amberAccent;
      default: return Colors.transparent;
    }
  }

  ResponseBoardInfo.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    title = json['title'];
    detail = json['detail'];
    writeUserInfo = json['writeUserInfo'] != null
        ? WriteUserInfo.fromJson(json['writeUserInfo'])
        : null;
    reviewCount = json['reviewCount'];
    maxCount = json['maxCount'];
    attendCount = json['attendCount'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    photo = json['photo'] != null
        ? List<String>.from(json["photo"].map((x) => x))
        : null;
    createTime = json['createTime'];
    isPick = json['isPick'];
    pickCount = json['pickCount'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['title'] = title;
    data['detail'] = detail;
    if (writeUserInfo != null) {
      data['writeUserInfo'] = writeUserInfo!.toJson();
    }
    data['reviewCount'] = reviewCount;
    data['maxCount'] = maxCount;
    data['attendCount'] = attendCount;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['photo'] = photo;
    data['createTime'] = createTime;
    data['isPick'] = isPick;
    data['pickCount'] = pickCount;
    data['viewCount'] = viewCount;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userImg'] = userImg;
    data['userName'] = userName;
    return data;
  }
}