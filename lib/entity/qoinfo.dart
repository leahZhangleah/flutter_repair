import 'dart:convert';
import 'package:meta/meta.dart';

class QoInfo {
  QoInfo(
      {@required this.quoteMoney,
      @required this.maintainerUserId,
      @required this.subscriptionMoney,
      @required this.balanceMoney,
      @required this.orderNumber,
      @required this.id,
      @required this.description,
      @required this.type,
      @required this.orderState,
      @required this.contactsName,
      @required this.contactsPhone,
      @required this.contactsAddress,
      @required this.url,
      @required this.createTime});

  final String orderNumber;
  final String id;
  final String description;
  final String type;
  final int orderState;
  final String contactsName;
  final String contactsPhone;
  final String contactsAddress;
  final String url;
  final String createTime;
  final double quoteMoney;
  final String maintainerUserId;
  final double subscriptionMoney;
  final double balanceMoney;

  static List<QoInfo> allFromResponse(String response) {

    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['page']['rows']
        .cast<Map<String, dynamic>>()
        .map((obj) => QoInfo.fromMap(obj))
        .toList()
        .cast<QoInfo>();
  }

  static QoInfo fromMap(Map map) {
    return new QoInfo(
        orderNumber: map['orderNumber'],
        id: map['id'],
        description: map['description'],
        type: map['type'],
        orderState: map['orderState'],
        contactsName: map['contactsName'],
        contactsPhone: map['contactsPhone'],
        contactsAddress: map['contactsAddress'],
        url: map['repairsOrdersDescriptionList'][0]['url'],
        createTime: map['createTime'],
        quoteMoney: map['repairsOrdersQuote']['quoteMoney'],
        maintainerUserId:map['repairsOrdersQuote']['maintainerUserId'],
        subscriptionMoney:map['repairsOrdersQuote']['subscriptionMoney'],
        balanceMoney:map['repairsOrdersQuote']['balanceMoney']);
  }
}
