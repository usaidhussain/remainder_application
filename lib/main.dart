import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderPage(),
    );
  }
}

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _activities = ['Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'];

  String? _selectedDay;
  String? _selectedActivity;
  TimeOfDay _selectedTime = TimeOfDay.now();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'channelId', 'Reminder Notification',
      importance: Importance.high,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'Time for $_selectedActivity!',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting the day
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Day'),
              value: _selectedDay,
              items: _daysOfWeek.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue;
                });
              },
            ),

            SizedBox(height: 16.0),

            // Dropdown for selecting activity
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Activity'),
              value: _selectedActivity,
              items: _activities.map((String activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedActivity = newValue;
                });
              },
            ),

            SizedBox(height: 16.0),

            // Time picker
            GestureDetector(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(labelText: 'Select Time'),
                child: Text(_selectedTime.format(context)),
              ),
            ),

            SizedBox(height: 24.0),

            // Button to set reminder
            ElevatedButton(
              onPressed: () {
                if (_selectedDay != null && _selectedActivity != null) {
                  _showNotification();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select all fields')),
                  );
                }
              },
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlutterLocalNotificationsPlugin {
}

