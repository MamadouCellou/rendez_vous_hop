import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class PriseRendezVous extends StatefulWidget {
  const PriseRendezVous({super.key});

  @override
  State<PriseRendezVous> createState() => _PriseRendezVousState();
}

class _PriseRendezVousState extends State<PriseRendezVous> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<String, Map<String, String>> _workHours = {
    'Monday': {'start': '09:00', 'end': '15:00'},
    'Tuesday': {'start': '09:00', 'end': '17:00'},
    'Wednesday': {'start': '09:00', 'end': '17:00'},
    'Thursday': {'start': '09:00', 'end': '17:00'},
    'Friday': {'start': '09:00', 'end': '17:00'},
    // Ajoutez d'autres jours si nécessaire
  };

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });

    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    final String dayOfWeek = DateFormat('EEEE').format(selectedDay);

    print('Selected date: $formattedDate');
    print('Day of the week: $dayOfWeek');
  }

  List<String> _generateTimeSlots(Map<String, String> workHours) {
    List<String> timeSlots = [];
    DateFormat dateFormat = DateFormat.Hm();

    DateTime startTime = dateFormat.parse(workHours['start']!);
    DateTime endTime = dateFormat.parse(workHours['end']!);

    while (startTime.isBefore(endTime)) {
      DateTime slotEndTime = startTime.add(Duration(minutes: 30));
      if (slotEndTime.isAfter(endTime)) {
        slotEndTime = endTime;
      }
      timeSlots.add('${dateFormat.format(startTime)} - ${dateFormat.format(slotEndTime)}');
      startTime = slotEndTime;
    }
    return timeSlots;
  }

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(_selectedDate);
    Map<String, String>? workHours = _workHours[dayOfWeek];

    List<String> timeSlots = workHours != null ? _generateTimeSlots(workHours) : [];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: buildCardDocteur(),
                ),
                Divider(color: Colors.black.withOpacity(0.5)),
                SizedBox(height: 20),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDate,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Créneaux horaires disponibles:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: timeSlots.map((slot) {
                    return ListTile(
                      title: Text(slot),
                      onTap: () {
                        // Handle slot selection
                        print('Selected time slot: $slot');
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final String formattedDate =
                        DateFormat('yyyy-MM-dd').format(_selectedDate);
                    final String dayOfWeek =
                        DateFormat('EEEE').format(_selectedDate);

                    // Handle the date and day of the week
                    print('Selected date: $formattedDate');
                    print('Day of the week: $dayOfWeek');

                    // Navigate or perform any action with the selected date
                  },
                  child: Text("Confirmer le rendez-vous"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardDocteur() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(40),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/cellou.jpg'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: 120,
                  width: 141,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dr. Jane Cooper",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                "Dentiste",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 17,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 5),
                  Text(
                    "New York",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.trending_up),
                  SizedBox(width: 5),
                  Text(
                    "20+",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
