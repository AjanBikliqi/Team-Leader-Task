import 'dart:convert';

import 'line_item_model.dart';

class QuotationModel {
  String id;
  String title;
  String customerInfo;
  String companyName;
  String companyAddress;
  String emailAddress;
  String vatNumber;
  List<LineItemModel> lineItems;
  List<String> images;

  QuotationModel({
    required this.id,
    required this.title,
    required this.customerInfo,
    required this.companyName,
    required this.companyAddress,
    required this.emailAddress,
    required this.vatNumber,
    required this.lineItems,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'customerInfo': customerInfo,
        'companyName': companyName,
        'companyAddress': companyAddress,
        'emailAddress': emailAddress,
        'vatNumber': vatNumber,
        'lineItems': lineItems.map((lineItem) => lineItem.toJson()).toList(),
        'images': jsonEncode(images),
      };

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> lineItemsJson = json['lineItems'] ?? [];
    List<LineItemModel> lineItems = lineItemsJson
        .map((lineItemJson) => LineItemModel.fromJson(lineItemJson))
        .toList();

    final String jsonImages = json['images'] ?? "[]";
    final List<String> images = List<String>.from(jsonDecode(jsonImages));

    return QuotationModel(
        id: json['id'],
        title: json['title'],
        customerInfo: json['customerInfo'],
        companyName: json['companyName'],
        companyAddress: json['companyAddress'],
        emailAddress: json['emailAddress'],
        vatNumber: json['vatNumber'],
        lineItems: lineItems,
        images: images);
  }
}
