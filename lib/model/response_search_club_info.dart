class ResponseSearchClubInfo {
  String? clubAdmin;
  String? clubCreateTime;
  String? clubDescription;
  String? clubImg;
  String? clubName;
  int? clubSports;
  String? clubSi;
  String? clubGu;
  String? clubGun;
  String? adminUid;
  String? clubSiDescription;
  String? clubGuDescription;
  String? clubGunDescription;
  String? clubAdminName;
  String? memberCount;
  String? clubKey;
  String? creClubTime;

  ResponseSearchClubInfo(
      {this.clubAdmin,
        this.clubCreateTime,
        this.clubDescription,
        this.clubImg,
        this.clubName,
        this.clubSports,
        this.clubSi,
        this.clubGu,
        this.clubGun,
        this.adminUid,
        this.clubSiDescription,
        this.clubGuDescription,
        this.clubGunDescription,
        this.clubAdminName,
        this.memberCount,
        this.clubKey,
        this.creClubTime}
      );

  ResponseSearchClubInfo.fromJson(Map<String, dynamic> json) {
    clubAdmin = json['clubAdmin'];
    clubCreateTime = json['clubCreateTime'];
    clubDescription = json['clubDescription'];
    clubImg = json['clubImg'];
    clubName = json['clubName'];
    clubSports = json['clubSports'];
    clubSi = json['clubSi'];
    clubGu = json['clubGu'];
    clubGun = json['clubGun'];
    adminUid = json['adminUid'];
    clubSiDescription = json['clubSiDescription'];
    clubGuDescription = json['clubGuDescription'];
    clubGunDescription = json['clubGunDescription'];
    clubAdminName = json['clubAdminName'];
    memberCount = json['memberCount'];
    clubKey = json['clubKey'];
    creClubTime = json['creClubTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clubAdmin'] = clubAdmin;
    data['clubCreateTime'] = clubCreateTime;
    data['clubDescription'] = clubDescription;
    data['clubImg'] = clubImg;
    data['clubName'] = clubName;
    data['clubSports'] = clubSports;
    data['clubSi'] = clubSi;
    data['clubGu'] = clubGu;
    data['clubGun'] = clubGun;
    data['adminUid'] = adminUid;
    data['clubSiDescription'] = clubSiDescription;
    data['clubGuDescription'] = clubGuDescription;
    data['clubGunDescription'] = clubGunDescription;
    data['clubAdminName'] = clubAdminName;
    data['memberCount'] = memberCount;
    data['clubKey'] = clubKey;
    data['creClubTime'] = creClubTime;
    return data;
  }
}