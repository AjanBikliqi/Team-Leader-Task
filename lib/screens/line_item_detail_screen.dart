import 'package:flutter/material.dart';

import '../models/line_item_model.dart';

class LineItemDetailScreen extends StatefulWidget {
  final LineItemModel lineItem;

  const LineItemDetailScreen({Key? key, required this.lineItem})
      : super(key: key);

  @override
  _LineItemDetailScreenState createState() => _LineItemDetailScreenState();
}

class _LineItemDetailScreenState extends State<LineItemDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late LineItemModel _lineItem;

  @override
  void initState() {
    super.initState();
    _lineItem = widget.lineItem;
  }

  void _saveLineItem() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    form.save();
    _lineItem.totalPrice = _lineItem.price * _lineItem.quantity;
    Navigator.pop(context, _lineItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Line item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _lineItem.title,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _lineItem.title = value!;
              },
            ),
            TextFormField(
              initialValue: _lineItem.price.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) {
                _lineItem.price = double.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _lineItem.quantity.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) {
                _lineItem.quantity = int.parse(value!);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveLineItem();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
