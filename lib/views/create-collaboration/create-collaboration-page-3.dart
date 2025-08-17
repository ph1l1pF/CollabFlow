import 'package:collabflow/models/collaboration.dart';
import 'package:flutter/material.dart';

class PartnerStep extends StatefulWidget {
  final void Function(Partner partner) onNext;

  const PartnerStep({super.key, required this.onNext});

  @override
  State<PartnerStep> createState() => _PartnerStepState();
}

class _PartnerStepState extends State<PartnerStep> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String phone = '';
  String companyName = '';
  String industry = '';
  String customerNumber = '';

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onNext(
        Partner(
          name: name,
          email: email,
          phone: phone,
          companyName: companyName,
          industry: industry,
          customerNumber: customerNumber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Brand & Kontakt",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildField("Name Ansprechpartner", onSaved: (val) => name = val),
            _buildField(
              "E-Mail",
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => email = val,
            ),
            _buildField(
              "Telefonnummer",
              keyboardType: TextInputType.phone,
              onSaved: (val) => phone = val,
            ),
            _buildField("Firmenname", onSaved: (val) => companyName = val),
            _buildField("Branche", onSaved: (val) => industry = val),
            _buildField("Kundennummer", onSaved: (val) => customerNumber = val),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Fertigstellen"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label, {
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        onSaved: (val) => onSaved(val ?? ''),
      ),
    );
  }
}
