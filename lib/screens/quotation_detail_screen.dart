import 'dart:io';

import 'package:flutter/material.dart';

import '../models/line_item_model.dart';
import '../models/quotation_model.dart';
import '../storage/quotation_storage.dart';
import 'line_item_detail_screen.dart';
import 'package:image_picker/image_picker.dart';

class QuotationDetailScreen extends StatefulWidget {
  final QuotationModel quotation;

  const QuotationDetailScreen({Key? key, required this.quotation})
      : super(key: key);

  @override
  _QuotationDetailScreenState createState() => _QuotationDetailScreenState();
}

class _QuotationDetailScreenState extends State<QuotationDetailScreen> {
  final QuotationStorage _quotationStorage = QuotationStorage();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  late QuotationModel _quotation;

  @override
  void initState() {
    super.initState();
    _quotation = widget.quotation;
  }

  void _saveQuotation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _quotationStorage.saveQuotation(_quotation);
      Navigator.pop(context);
    }
  }

  _navigateToLineItemDetailScreen(LineItemModel lineItem) async {
    final editedLineItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LineItemDetailScreen(lineItem: lineItem),
      ),
    );
    if (editedLineItem != null) {
      setState(() {
        _quotation.lineItems.remove(lineItem);
        _quotation.lineItems.add(editedLineItem);
      });
    }
  }

  void _deleteLineItem(LineItemModel lineItem) {
    setState(() {
      _quotation.lineItems.remove(lineItem);
    });
  }

  selectImage() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Choose')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                          child: Text('Camera'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final pickedFile = await _imagePicker.pickImage(
                                source: ImageSource.camera);
                            if (pickedFile != null) {
                              setState(() {
                                _quotation.images.add(pickedFile.path);
                                print(
                                    "Selected image path: ${pickedFile.path}");
                                print(
                                    "Updated list of images: ${_quotation.images}");
                              });
                            }
                          }),
                      ElevatedButton(
                          child: Text('Gallery'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final pickedFile = await _imagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _quotation.images.add(pickedFile.path);
                                print(
                                    "Selected image path: ${pickedFile.path}");
                                print(
                                    "Updated list of images: ${_quotation.images}");
                              });
                            }
                          })
                    ])
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _quotation.title,
              decoration: const InputDecoration(
                labelText: 'Title / description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _quotation.title = value!;
              },
            ),
            TextFormField(
              initialValue: _quotation.customerInfo,
              decoration: const InputDecoration(
                labelText: 'Customer info',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer info';
                }
                return null;
              },
              onSaved: (value) {
                _quotation.customerInfo = value!;
              },
            ),
            TextFormField(
              initialValue: _quotation.companyName,
              decoration: const InputDecoration(
                labelText: 'Company name',
              ),
              onSaved: (value) {
                _quotation.companyName = value!;
              },
            ),
            TextFormField(
              initialValue: _quotation.companyAddress,
              decoration: const InputDecoration(
                labelText: 'Company address',
              ),
              onSaved: (value) {
                _quotation.companyAddress = value!;
              },
            ),
            TextFormField(
              initialValue: _quotation.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
              ),
              onSaved: (value) {
                _quotation.emailAddress = value!;
              },
            ),
            TextFormField(
              initialValue: _quotation.vatNumber,
              decoration: const InputDecoration(
                labelText: 'VAT number',
              ),
              onSaved: (value) {
                _quotation.vatNumber = value!;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Line items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._quotation.lineItems.map(
              (lineItem) => ListTile(
                title: Text(lineItem.title),
                trailing: Text('${lineItem.totalPrice}'),
                onTap: () => _navigateToLineItemDetailScreen(lineItem),
                onLongPress: () => _deleteLineItem(lineItem),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final lineItem = LineItemModel(
                  totalPrice: 0,
                  title: '',
                  price: 0,
                  quantity: 0,
                );
                await _navigateToLineItemDetailScreen(lineItem);
              },
              child: const Text('Add line item'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text("Add Image"),
              onPressed: () async {
                await selectImage();
              },
            ),
            _quotation.images.isEmpty
                ? Container()
                : GridView.count(
                    mainAxisSpacing: 5.0,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: _quotation.images.map((path) {
                      return Image.file(File(path));
                    }).toList(),
                  ),
            ElevatedButton(
              onPressed: () {
                _saveQuotation();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
