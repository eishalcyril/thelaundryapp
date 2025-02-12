import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeCalender extends StatefulWidget {
  const DateRangeCalender({super.key, required this.onDateChange});
  final void Function(DateTime startDate, DateTime endDate) onDateChange;

  @override
  State<DateRangeCalender> createState() => _DateRangeCalenderState();
}

class _DateRangeCalenderState extends State<DateRangeCalender> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = args.value.startDate;
        endDate = args.value.endDate ?? args.value.startDate;
        widget.onDateChange(startDate, endDate);
      }
    });
  }

  void onDateRangeSelect(String name) {
    setState(() {
      DateTime now = DateTime.now();
      int currentWeekday = now.weekday;
      if (name == 'Today') {
        startDate = now;
        endDate = now;
      } else if (name == 'Tomorrow') {
        startDate = now.add(const Duration(days: 1));
        endDate = now.add(const Duration(days: 1));
      } else if (name == 'This_Week') {
        int differenceFromMonday = currentWeekday - DateTime.monday;
        startDate = now.subtract(Duration(days: differenceFromMonday));
        endDate = startDate.add(const Duration(days: 6));
      } else if (name == 'This_Month') {
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
      }
      widget.onDateChange(startDate, endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          top: 100,
          right: 10,
          bottom: 100,
          child: Container(
            constraints: const BoxConstraints(minHeight: 100, minWidth: 100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            onDateRangeSelect('Today');
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.transparent),
                            elevation: WidgetStateProperty.all(0),
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Today',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          onDateRangeSelect('Tomorrow');
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text('Tomorrow'),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          onDateRangeSelect('This_Week');
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text('This Week'),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          onDateRangeSelect('This_Month');
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text('This Month'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: SfDateRangePickerTheme(
                      data: const SfDateRangePickerThemeData(
                          backgroundColor: Colors.white,
                          headerBackgroundColor: Colors.white,
                          weekendDatesTextStyle: TextStyle(color: Colors.red)),
                      child: SfDateRangePicker(
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSubmit: (p0) {
                          Navigator.pop(context);
                        },
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode:
                            DateRangePickerSelectionMode.extendableRange,
                        extendableRangeSelectionDirection:
                            ExtendableRangeSelectionDirection.both,
                        showActionButtons: true,
                        initialSelectedRange:
                            PickerDateRange(DateTime.now(), DateTime.now()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
