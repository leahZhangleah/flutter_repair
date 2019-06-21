class HttpAddressMananger{
  //String _domain = "http://www.shyysy.xyz";
  String _domain = "http://115.159.93.175:8281";
  String _uploadVideo = "/upload/uploadVideo";
  String _addressList="/repairs/repairsUserAddress/listAll";
  String _addressDelete = "/repairs/repairsUserAddress/delete";
  String _captchaSMS = "/captchaSMS";
  String _login="/repairs/login";
  String _saveNewAddress="/repairs/repairsUserAddress/save";
  String _updateAddress ="/repairs/repairsUserAddress/update";
  String _publishOrder="/repairs/repairsOrders/save";
  String _orderList = "/repairs/repairsOrders/repairsList";
  String _closeOrder = "/repairs/repairsOrders/close/";
  String _refuseQuote = "/repairs/repairsOrdersQuote/repulse/";
  String _validCouponList = "/repairs/couponUser/myValidCoupon";
  String _usableCouponList ="/repairs/couponUser/myUsableCoupon";
  String _materialList ="/repairs/repairsMaterials/list";
  String _wechatAppId = "wx4242a941ae472561";
  String _wxPay = "/wxPay/unifiedOrder";
  String _publishedOrder = "/repairs/repairsOrders/published/";
  String _payEarnest ="/repairs/repairsOrders/payEarnest/";
  String _finishOrder = "/repairs/repairsOrders/finishOrder/";
  String _feedback = "/repairs/repairsOpinion/save";
  String _uploadImg = "/upload/uploadImg";
  String _updatePersonalInfo ="/repairs/repairsUser/update";
  String _personalInfo="/repairs/repairsUser/personalInfo";
  String _logout = "/repairs/logout";
  String _fileUploadServer = "https://tac-xiuyixiu-ho-1258818500.cos.ap-shanghai.myqcloud.com";
  String _saveAppraise = "/repairs/repairsOrdersAppraise/save";
  String _orderDetailById = "/repairs/repairsOrders/info/";
  String _repairsServiceCharge = "/repairs/repairsServiceCharge/getRepairsServiceCharge";

  String getSaveAppraiseUrl(){
    return getFullAddress(_saveAppraise);
  }

  String getUpdatePersonalInfoUrl(){
    return getFullAddress(_updatePersonalInfo);
  }
  String getUploadImgUrl(){
    return getFullAddress(_uploadImg);
  }

  String getFeedbackUrl(){
    return getFullAddress(_feedback);
  }

  String getPublishOrderUrl(){
    return getFullAddress(_publishOrder);
  }

  String getUpdateAddress(){
    return getFullAddress(_updateAddress);
  }
  String getUploadVideoAddress(){
    return getFullAddress(_uploadVideo);
  }

  String getCaptchaSMS(){
    return getFullAddress(_captchaSMS);
  }

  String getLogin(){
    return getFullAddress(_login);
  }

  String getSaveNewAddress(){
    return getFullAddress(_saveNewAddress);
  }

  String getFullAddress(String prefix){
    return _domain+prefix;
  }


  String get domain => _domain;

  String get orderList => _orderList;

  String get closeOrder => _closeOrder;

  String get refuseQuote => _refuseQuote;

  String get uploadVideo => _uploadVideo;

  String get addressList => _addressList;

  String get addressDelete => _addressDelete;

  String get captchaSMS => _captchaSMS;

  String get login => _login;

  String get saveNewAddress => _saveNewAddress;

  String get updateAddress => _updateAddress;

  String get publishOrder => _publishOrder;

  String get validCouponList => _validCouponList;

  String get materialList => _materialList;

  String get usableCouponList => _usableCouponList;

  String get payEarnest => _payEarnest;

  String get wechatAppId => _wechatAppId;

  String get wxPay => _wxPay;

  String get publishedOrder => _publishedOrder;

  String get finishOrder => _finishOrder;

  String get updatePersonalInfo => _updatePersonalInfo;

  String get uploadImg => _uploadImg;

  String get feedback => _feedback;

  String get personalInfo => _personalInfo;

  String get logout => _logout;

  String get fileUploadServer => _fileUploadServer;

  String get orderDetailById => _orderDetailById;

  String get saveAppraise => _saveAppraise;

  String get repairsServiceCharge => _repairsServiceCharge;


}