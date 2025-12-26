import 'package:flutter/material.dart';
import 'package:classpall_flutter/models/event_models/event_model.dart';
import 'package:classpall_flutter/services/event_services/event_service.dart';
import 'event_create_success.dart';

class EventCreateForm extends StatefulWidget {
  const EventCreateForm({super.key});

  @override
  State<EventCreateForm> createState() => _EventCreateFormState();
}

class _EventCreateFormState extends State<EventCreateForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isRequired = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày và giờ')),
      );
      return;
    }

    final eventDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final event = EventModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      eventDate: eventDate,
      isMandatory: _isRequired,
      status: 'active',
      totalRegistered: 0,
      totalClass: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await EventService().createEvent(event);

    if (!mounted) return;

    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const EventCreateSuccessDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tạo sự kiện mới',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text('Tên sự kiện *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Không được bỏ trống' : null,
                decoration:
                    const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              const Text('Mô tả'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration:
                    const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration:
                            const InputDecoration(labelText: 'Ngày *'),
                        child: Text(
                          _selectedDate == null
                              ? 'Chọn ngày'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      child: InputDecorator(
                        decoration:
                            const InputDecoration(labelText: 'Giờ *'),
                        child: Text(
                          _selectedTime == null
                              ? 'Chọn giờ'
                              : _selectedTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text('Địa điểm *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Không được bỏ trống' : null,
                decoration:
                    const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              CheckboxListTile(
                value: _isRequired,
                onChanged: (v) => setState(() => _isRequired = v!),
                title: const Text('Sự kiện bắt buộc'),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Tạo sự kiện'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
