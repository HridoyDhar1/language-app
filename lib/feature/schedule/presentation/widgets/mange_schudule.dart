
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:languageapp/feature/teacher/data/models/teacher_model.dart';
import 'package:languageapp/feature/schedule/presentation/controller/scheul_controller.dart'; // Import the model

class ManageSchedulesScreen extends StatefulWidget {
  const ManageSchedulesScreen({super.key});

  @override
  State<ManageSchedulesScreen> createState() => _ManageSchedulesScreenState();
}

class _ManageSchedulesScreenState extends State<ManageSchedulesScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final ScheduleController scheduleController = Get.put(ScheduleController());
  String? selectedLocation;
  String? selectedLanguage;
  
  final List<String> locations = ["Online", "Dhaka", "Chittagong", "Sylhet"];
  final List<String> languages = ["English", "Spanish", "French", "German", "Chinese", "Arabic", "Japanese"];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _addSchedule() {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        selectedLocation != null &&
        selectedLanguage != null) {
      scheduleController.addSchedule(
        date: selectedDate!,
        time: selectedTime!,
        description: _descriptionController.text.trim(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        location: selectedLocation!,
        language: selectedLanguage!,
        image: _imageController.text.trim().isNotEmpty 
            ? _imageController.text.trim() 
            : 'https://via.placeholder.com/150',
      );

      setState(() {
        selectedDate = null;
        selectedTime = null;
        selectedLocation = null;
        selectedLanguage = null;
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _imageController.clear();
      });

      Get.snackbar(
        "Success",
        "Teacher schedule added",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please fill all fields correctly",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildTeacherCard(Teacher teacher) {
    final dateStr = DateFormat('yyyy-MM-dd').format(teacher.date);
    final timeStr = teacher.time.format(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(
          teacher.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, size: 40);
          },
        ),
        title: Text("${teacher.name} - ${teacher.language}"),
        subtitle: Text(
          "$dateStr at $timeStr\n${teacher.location} - BDT ${teacher.price}",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => scheduleController.removeSchedule(teacher.id),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text("Manage Teacher Schedules"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Teacher Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? "Please enter teacher name"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Teacher Description",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? "Please enter description"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Price (BDT)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter price";
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return "Enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _imageController,
                        decoration: const InputDecoration(
                          labelText: "Image URL (optional)",
                          border: OutlineInputBorder(),
                          hintText: "https://example.com/image.jpg",
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedLanguage,
                        items: languages
                            .map((lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: "Select Language",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() => selectedLanguage = value),
                        validator: (value) =>
                        value == null ? "Please select language" : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedLocation,
                        items: locations
                            .map((loc) =>
                            DropdownMenuItem(value: loc, child: Text(loc)))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: "Select Location",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() => selectedLocation = value),
                        validator: (value) =>
                        value == null ? "Please select location" : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickDate,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: selectedDate == null
                                        ? "Select Date"
                                        : DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                                  ),
                                  validator: (_) =>
                                  selectedDate == null ? "Select date" : null,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickTime,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: selectedTime == null
                                        ? "Select Time"
                                        : selectedTime!.format(context),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: const Icon(Icons.access_time),
                                  ),
                                  validator: (_) =>
                                  selectedTime == null ? "Select time" : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addSchedule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Add Teacher Schedule",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Teacher List (fetched live)
            const Text(
              "Current Teachers:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Obx(() {
                if (scheduleController.teachers.isEmpty) {
                  return const Center(
                    child: Text(
                      "No teachers yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: scheduleController.teachers.length,
                  itemBuilder: (context, index) =>
                      _buildTeacherCard(scheduleController.teachers[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}