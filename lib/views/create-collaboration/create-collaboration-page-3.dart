import 'package:ugcworks/models/collaboration.dart';
import 'package:flutter/material.dart';
import 'package:ugcworks/utils/theme_utils.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)?.editPartnerData ?? 'Edit Partner Data'),
          elevation: 0,
        ),
        body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              AppLocalizations.of(context)?.brandAndContact ?? "Brand & Contact",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildField(AppLocalizations.of(context)?.contactPersonName ?? "Contact Person", controller: _nameController),
            _buildField(AppLocalizations.of(context)?.email ?? "E-Mail", controller: _emailController, keyboardType: TextInputType.emailAddress),
            _buildField(AppLocalizations.of(context)?.phoneNumber ?? "Phone Number", controller: _phoneController, keyboardType: TextInputType.phone),
            _buildField(AppLocalizations.of(context)?.companyName ?? "Company Name", controller: _companyNameController),
            _buildField(AppLocalizations.of(context)?.industry ?? "Industry", controller: _industryController),
            _buildField(AppLocalizations.of(context)?.customerNumber ?? "Customer Number", controller: _customerNumberController),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submit(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, size: 20),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)?.back ?? "Back",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submit(true),
                    style: AppColors.primaryButtonStyle.copyWith(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.next ?? "Next",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
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
          labelText: '$label (${AppLocalizations.of(context)?.optional ?? "optional"})',
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
