import 'package:flutter/material.dart';

class TimeInputField extends StatefulWidget {
  const TimeInputField({super.key});

  @override
  _TimeInputFieldState createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Picker Example')),
      body: Center(
        child: TextFormField(
          controller: _timeController,
          decoration: const InputDecoration(
            labelText: 'Select Time',
            suffixIcon: Icon(Icons.access_time),
          ),
          readOnly: true,
          onTap: () => _selectTime(context),
        ),
      ),
    );
  }
}
