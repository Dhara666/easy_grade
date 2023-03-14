import 'dart:developer';

import 'package:easy_grade/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../constant/color_constant.dart';
import '../../provider/notification_provider.dart';
import '../../widgets/app_text.dart';

class AcademicCalender extends StatefulWidget {
  const AcademicCalender({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AcademicCalenderState();
}

class AcademicCalenderState extends State<AcademicCalender> {
  List<Appointment> _appointmentDetails = <Appointment>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.getCalender(context);
  }

  @override
  Widget build(BuildContext context) {
    log("------>Current Screen: $runtimeType");
    return Consumer(
        builder: (context, NotificationProvider notificationProvider, _) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: ColorConstant.appBlack,
          ),
          backgroundColor: ColorConstant.appWhite,
          title: AppText(
            text: S.of(context).academicCalender,
            textColor: ColorConstant.appThemeColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SfCalendar(
                  minDate: DateTime(2000),
                  view: CalendarView.month,
                  dataSource: getCalendarDataSource(notificationProvider),
                  onTap: calendarTapped,
                ),
              ),
              Expanded(
                  child: Container(
                      color: Colors.black12,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(2),
                        itemCount: _appointmentDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: const EdgeInsets.all(2),
                              height: 60,
                              color: _appointmentDetails[index].color,
                              child: ListTile(
                                leading: Column(
                                  children: <Widget>[
                                    Text(
                                      _appointmentDetails[index].isAllDay
                                          ? ''
                                          : DateFormat('hh:mm a').format(
                                              _appointmentDetails[index]
                                                  .startTime),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.7),
                                    ),
                                    Text(
                                      _appointmentDetails[index].isAllDay
                                          ? 'All day'
                                          : '',
                                      style: const TextStyle(
                                          height: 0.5, color: Colors.white),
                                    ),
                                    Text(
                                      _appointmentDetails[index].isAllDay
                                          ? ''
                                          : DateFormat('hh:mm a').format(
                                              _appointmentDetails[index]
                                                  .endTime),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.event,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                title: Text(_appointmentDetails[index].subject,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 5,
                        ),
                      )))
            ],
          ),
        ),
      );
    });
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointmentDetails =
            calendarTapDetails.appointments!.cast<Appointment>();
      });
    }
  }

  _DataSource getCalendarDataSource(NotificationProvider notificationProvider) {
    final List<Appointment> appointments = <Appointment>[];
    for (int i = 0; i < notificationProvider.eventCalender.length; i++) {
      appointments.add(Appointment(
        startTime: notificationProvider.eventCalender[i].eventDate!,
        endTime: notificationProvider.eventCalender[i].eventDate!,
        subject: notificationProvider.eventCalender[i].eventName!,
        color: ColorConstant.appBlue,
      ));
    }
    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
