import 'package:flutter/material.dart';

/// Common dialog widgets untuk berbagai form input
class CommonDialogs {
  /// Show form dialog with custom fields
  static Future<Map<String, dynamic>?> showFormDialog({
    required BuildContext context,
    required String title,
    required List<FormFieldConfig> fields,
    Map<String, dynamic>? initialValues,
    String submitText = 'Simpan',
    String cancelText = 'Batal',
  }) async {
    final formKey = GlobalKey<FormState>();
    final Map<String, dynamic> values = Map.from(initialValues ?? {});
    
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildFormField(field, values),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                Navigator.pop(context, values);
              }
            },
            child: Text(submitText),
          ),
        ],
      ),
    );
  }

  static Widget _buildFormField(
    FormFieldConfig config,
    Map<String, dynamic> values,
  ) {
    switch (config.type) {
      case FormFieldType.text:
        return TextFormField(
          initialValue: values[config.key]?.toString() ?? config.initialValue,
          decoration: InputDecoration(
            labelText: config.label,
            hintText: config.hint,
            border: const OutlineInputBorder(),
          ),
          maxLines: config.maxLines,
          keyboardType: config.keyboardType,
          validator: config.validator,
          onSaved: (value) => values[config.key] = value,
        );
      
      case FormFieldType.dropdown:
        return DropdownButtonFormField<String>(
          value: values[config.key]?.toString() ?? config.initialValue,
          decoration: InputDecoration(
            labelText: config.label,
            border: const OutlineInputBorder(),
          ),
          items: config.options?.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          validator: config.validator,
          onChanged: (value) => values[config.key] = value,
          onSaved: (value) => values[config.key] = value,
        );
      
      case FormFieldType.number:
        return TextFormField(
          initialValue: values[config.key]?.toString() ?? config.initialValue,
          decoration: InputDecoration(
            labelText: config.label,
            hintText: config.hint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: config.validator,
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              values[config.key] = num.tryParse(value) ?? 0;
            }
          },
        );
      
      case FormFieldType.checkbox:
        return CheckboxListTile(
          title: Text(config.label),
          value: values[config.key] ?? false,
          onChanged: (value) => values[config.key] = value,
          controlAffinity: ListTileControlAffinity.leading,
        );
      
      default:
        return const SizedBox.shrink();
    }
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDangerous
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show success dialog
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Configuration for form fields
class FormFieldConfig {
  final String key;
  final String label;
  final FormFieldType type;
  final String? hint;
  final String? initialValue;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<String>? options;
  final String? Function(String?)? validator;

  FormFieldConfig({
    required this.key,
    required this.label,
    required this.type,
    this.hint,
    this.initialValue,
    this.maxLines = 1,
    this.keyboardType,
    this.options,
    this.validator,
  });
}

enum FormFieldType {
  text,
  number,
  dropdown,
  checkbox,
  date,
}
