import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teamleader_task/screens/quotation_detail_screen.dart';

import '../models/quotation_model.dart';
import '../storage/quotation_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotationOverviewScreen extends StatefulWidget {
  const QuotationOverviewScreen({Key? key}) : super(key: key);

  @override
  _QuotationOverviewScreenState createState() =>
      _QuotationOverviewScreenState();
}

class _QuotationOverviewScreenState extends State<QuotationOverviewScreen> {
  final QuotationStorage _quotationStorage = QuotationStorage();

  List<QuotationModel> _quotations = [];

  @override
  void initState() {
    super.initState();
    _loadQuotations();
  }

  Future<void> _loadQuotations() async {
    List<QuotationModel> quotations =
        await _quotationStorage.getAllQuotations();
    setState(() {
      _quotations = quotations;
    });
  }

  _navigateToDetailScreen(QuotationModel quotation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuotationDetailScreen(quotation: quotation),
      ),
    );
    // refresh quotation list
    _loadQuotations();
  }

  void _removeQuotation(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> quotationStrings = prefs.getStringList('quotations') ?? [];
    quotationStrings.removeAt(index);
    await prefs.setStringList('quotations', quotationStrings);

    setState(() {
      _quotations = quotationStrings
          .map((e) => QuotationModel.fromJson(jsonDecode(e)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations'),
      ),
      body: ListView.builder(
        itemCount: _quotations.length,
        itemBuilder: (BuildContext context, int index) {
          QuotationModel quotation = _quotations[index];
          return ListTile(
            title: Text(quotation.title),
            subtitle: Text(quotation.customerInfo),
            trailing: IconButton(
              onPressed: () {
                _removeQuotation(index);
              },
              icon: const Icon(Icons.restore_from_trash_rounded),
            ),
            onTap: () => _navigateToDetailScreen(quotation),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          QuotationModel quotation = QuotationModel(
            id: UniqueKey().toString(),
            title: '',
            customerInfo: '',
            companyName: '',
            companyAddress: '',
            emailAddress: '',
            vatNumber: '',
            lineItems: [],
            images: [],
          );
          await _navigateToDetailScreen(quotation);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
