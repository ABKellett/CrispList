import 'package:capstone_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat calFomat = CalendarFormat.month;
  DateTime? selectedDate;
  DateTime? focusedDate = DateTime.now();

  // late Map<DateTime, List<CalEvent>> selectedEvents;
  late final ValueNotifier<List<CalEvent>> selectedEvents;

  @override
  void initState() {
    // selectedEvents = {};
    super.initState();
    selectedDate = focusedDate;
    selectedEvents = ValueNotifier(_getEventsForDay(selectedDate!));
  }

  @override
  void dispose() {
    selectedEvents.dispose();
    super.dispose();
  }

  List<CalEvent> _getEventsForDay(DateTime date) {
    // return selectedEvents[date] ?? [];
    // return kEvents[date] ?? [];
    return [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDate, selectedDay)) {
      setState(() {
        selectedDate = selectedDay;
        focusedDate = focusedDay;
      });

      selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Card(
          color: Colors.grey[200],
          child: TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2050),
            focusedDay: selectedDate ?? DateTime.now(),
            calendarFormat: calFomat,
            onFormatChanged: ((CalendarFormat _format) {
              setState(() {
                calFomat = _format;
              });
            }),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                focusedDate = focusedDay;
              });
            },
            //TODO: Fix selected day saving when changing back to widget.
            onPageChanged: (focusedDay) {
              focusedDate = focusedDay;
            },

            //Events
            eventLoader: (day) {
              return _getEventsForDay(day);
            },

            calendarStyle: CalendarStyle(
              canMarkersOverflow: true,
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              defaultDecoration: BoxDecoration(shape: BoxShape.circle),
              weekendDecoration: BoxDecoration(shape: BoxShape.circle),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Divider(),
        Container()
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Add Meal"),
        icon: Icon(Icons.add),
        backgroundColor: Color.fromARGB(189, 198, 30, 18),
      ),
    );
  }
}
