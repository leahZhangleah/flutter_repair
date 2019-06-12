import 'dart:convert';

class Description {
  Description({this.fileName, this.url,this.type});

  final String fileName;
  final String url;
  final int type;

  static Description allFromResponse(String response) {
    Description description=Description.fromMap(json.decode(response)['data']);
    return description;
  }

  static Description fromMap(dynamic map) {
    return new Description(
        fileName: map['fileName'],
        url: map['url'],
        type: map['type']);
  }
}
