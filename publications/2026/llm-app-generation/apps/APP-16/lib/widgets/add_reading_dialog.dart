import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/blood_pressure_reading.dart';
import '../providers/blood_pressure_provider.dart';

class AddReadingDialog extends StatefulWidget {
  final BloodPressureReading? editReading;

  const AddReadingDialog({
    super.key,
    this.editReading,
  });

  @override
  State<AddReadingDialog> createState() => _AddReadingDialogState();
}

class _AddReadingDialogState extends State<AddReadingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDateTime = DateTime.now();
  final Set<String> _selectedTags = <String>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editReading != null) {
      _initializeWithExistingReading();
    }
  }

  void _initializeWithExistingReading() {
    final reading = widget.editReading!;
    _systolicController.text = reading.systolic.toString();
    _diastolicController.text = reading.diastolic.toString();
    _pulseController.text = reading.pulse.toString();
    _notesController.text = reading.notes ?? '';
    _selectedDateTime = reading.dateTime;
    _selectedTags.addAll(reading.tags);
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.mediumSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.mediumBorderRadius),
                  topRight: Radius.circular(AppConstants.mediumBorderRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.editReading != null ? Icons.edit : Icons.add,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppConstants.smallSpacing),
                  Expanded(
                    child: Text(
                      widget.editReading != null ? 'Edit Reading' : 'Add New Reading',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Form content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blood pressure inputs
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                              controller: _systolicController,
                              label: 'Systolic',
                              hint: '120',
                              min: AppConstants.minSystolicValue,
                              max: AppConstants.maxSystolicValue,
                            ),
                          ),
                          const SizedBox(width: AppConstants.mediumSpacing),
                          Expanded(
                            child: _buildNumberField(
                              controller: _diastolicController,
                              label: 'Diastolic',
                              hint: '80',
                              min: AppConstants.minDiastolicValue,
                              max: AppConstants.maxDiastolicValue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Pulse input
                      _buildNumberField(
                        controller: _pulseController,
                        label: 'Pulse (bpm)',
                        hint: '72',
                        min: AppConstants.minPulseValue,
                        max: AppConstants.maxPulseValue,
                      ),
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Date and time picker
                      _buildDateTimePicker(),
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Tags selection
                      _buildTagsSection(),
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Notes input
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          hintText: 'Add any additional notes...',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        maxLength: 500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.all(AppConstants.mediumSpacing),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.mediumSpacing),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveReading,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.editReading != null ? 'Update' : 'Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int min,
    required int max,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return 'Please enter a valid number';
        }
        if (intValue < min || intValue > max) {
          return '$label must be between $min and $max';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        InkWell(
          onTap: _selectDateTime,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: Text(
                    '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} at ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        Wrap(
          spacing: AppConstants.smallSpacing,
          runSpacing: 4,
          children: AppConstants.commonTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveReading() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final systolic = int.parse(_systolicController.text);
      final diastolic = int.parse(_diastolicController.text);
      final pulse = int.parse(_pulseController.text);

      final reading = BloodPressureReading.create(
        id: widget.editReading?.id,
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        dateTime: _selectedDateTime,
        tags: _selectedTags.toList(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      final provider = context.read<BloodPressureProvider>();
      bool success;

      if (widget.editReading != null) {
        success = await provider.updateReading(reading);
      } else {
        success = await provider.addReading(reading);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.editReading != null
                  ? 'Reading updated successfully!'
                  : AppConstants.successReadingSaved,
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? AppConstants.errorGeneric),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}