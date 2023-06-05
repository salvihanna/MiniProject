import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

import 'DailyCount.dart';
import 'Roleassign_warden.dart';
import 'checkBox.dart';
import 'monthlyExp.dart';
import 'verify.dart';

class Calendar extends StatefulWidget {
  final String? uid;
  Calendar({Key? key, this.uid}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? selectedValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DatePicker(
          DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.blue,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            setState(() {
              selectedValue = date;
              print(selectedValue);
            });
          },
        ),
        CheckboxList(date: selectedValue),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return DailyCount();
                    }));
                  },
                  child: Text("Daily Count")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return RoleAssign();
                    }));
                  },
                  child: Text("Role Assign")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return VerifyUser();
                    }));
                  },
                  child: Text("User Verify")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return MonthlyExp(uid: widget.uid);
                    }));
                  },
                  child: const Text("Monthly Expence")),
            )
          ],
        )

        //the announcement and review below
      ],
    );
  }
}