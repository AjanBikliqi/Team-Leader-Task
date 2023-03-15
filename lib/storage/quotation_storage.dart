import 'dart:convert';

import '../models/quotation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotationStorage {
  static const _key = 'quotations';

  Future<List<QuotationModel>> getAllQuotations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> quotationsJson = prefs.getStringList(_key) ?? [];
    List<QuotationModel> quotations = quotationsJson
        .map((json) => QuotationModel.fromJson(jsonDecode(json)))
        .toList();
    return quotations;
  }

  Future<void> saveQuotation(QuotationModel quotation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> quotationsJson = prefs.getStringList(_key) ?? [];
    int index = quotationsJson
        .indexWhere((json) => jsonDecode(json)['id'] == quotation.id);
    if (index == -1) {
      // quotation is new, add to list
      quotationsJson.add(jsonEncode(quotation.toJson()));
    } else {
      // quotation already exists, replace in list
      quotationsJson[index] = jsonEncode(quotation.toJson());
    }
    prefs.setStringList(_key, quotationsJson);
    print("Saved quotations: ${prefs.getStringList(_key)}");
  }
}
