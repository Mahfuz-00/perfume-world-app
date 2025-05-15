import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Core/Config/Theme/app_colors.dart';

class PhoneNumberInputField extends StatefulWidget {
  final ValueChanged<String> onPhoneChanged; // Callback for phone input
  final ValueChanged<String> onRelationChanged; // Callback for relation

  const PhoneNumberInputField({
    Key? key,
    required this.onPhoneChanged,
    required this.onRelationChanged,
  }) : super(key: key);

  @override
  _PhoneNumberInputFieldState createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  final TextEditingController _phoneController = TextEditingController();
  final List<String> relationOptions = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Spouse'
  ];
  String? _selectedRelation = 'Father';
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      widget.onPhoneChanged(_phoneController.text); // Callback for phone input
      print(_phoneController.text);
      _validatePhoneNumber();
    });
  }

  void _validatePhoneNumber() {
    final phoneNumber =
        _phoneController.text.replaceAll(' ', '').replaceAll('+880', '');
    setState(() {
      _isPhoneValid = phoneNumber.length ==
          10; // Validate phone number length (excluding the +880)
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '1716002011',
        //alignLabelWithHint: true,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.labelGrey,
          fontFamily: 'Roboto',
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.labelGrey,
          fontFamily: 'Roboto',
        ),
        prefixText: '+880 ',
        prefixStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.labelGrey,
          fontFamily: 'Roboto',
        ),
        suffixIcon: _isPhoneValid
            ? null
            : Icon(
                Icons.info_outline,
                color: Colors.red,
                size: 30,
              ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRelation,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRelation = newValue;
                  widget.onRelationChanged(newValue!); // Callback for relation
                });
              },
              items:
                  relationOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.labelGrey,
                        fontFamily: 'Roboto',
                      )),
                );
              }).toList(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.labelGrey,
        fontFamily: 'Roboto',
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }
}
