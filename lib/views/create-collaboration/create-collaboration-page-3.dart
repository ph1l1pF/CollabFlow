import 'package:ugcworks/models/collaboration.dart';
import 'package:flutter/material.dart';
import 'package:ugcworks/utils/theme_utils.dart';

class PartnerStep extends StatefulWidget {
  final void Function(Partner partner, bool next) onFinish;
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialCompanyName;
  final String initialIndustry;
  final String initialCustomerNumber;

  const PartnerStep({
    super.key,
    required this.onFinish,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialCompanyName,
    required this.initialIndustry,
    required this.initialCustomerNumber,
  });

  @override
  State<PartnerStep> createState() => _PartnerStepState();
}

class _PartnerStepState extends State<PartnerStep> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyNameController;
  late TextEditingController _industryController;
  late TextEditingController _customerNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _companyNameController = TextEditingController(text: widget.initialCompanyName);
    _industryController = TextEditingController(text: widget.initialIndustry);
    _customerNumberController = TextEditingController(text: widget.initialCustomerNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _industryController.dispose();
    _customerNumberController.dispose();
    super.dispose();
  }

  void _submit(bool next) {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onFinish(
        Partner(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          companyName: _companyNameController.text,
          industry: _industryController.text,
          customerNumber: _customerNumberController.text,
        ),
        next,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeUtils.getBackgroundDecoration(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Partnerdaten bearbeiten'),
          elevation: 0,
        ),
        body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Brand & Kontakt",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildField("Name Ansprechpartner", controller: _nameController),
            _buildField("E-Mail", controller: _emailController, keyboardType: TextInputType.emailAddress),
            _buildField("Telefonnummer", controller: _phoneController, keyboardType: TextInputType.phone),
            _buildField("Firmenname", controller: _companyNameController),
            _buildField("Branche", controller: _industryController),
            _buildField("Kundennummer", controller: _customerNumberController),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _submit(false),
                  child: const Text("Zurück"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _submit(true),
                  child: const Text("Weiter"),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildField(
    String label, {
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + ' (optional)',
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
