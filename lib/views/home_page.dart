import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/utils/confimation_dialog_box.dart';
import 'package:flutter_attendance_system/utils/prompt_dialog_box.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:provider/provider.dart';
import '../viewmodel/attendance_view_model.dart';
import '../viewmodel/auth_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userModel = authViewModel.userModel;
    final timeDateViewModel = Provider.of<TimeDateViewModel>(context);
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _showSpinner = true;
      });
      try {
        await attendanceViewModel.fetchUserAttendance(timeDateViewModel.dateTime);
      } finally {
        setState(() {
          _showSpinner = false;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Flutter HR Portal',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              setState(() {
                _showSpinner = true;
              });
              try {
                await authViewModel.logout(context);
              } finally {
                setState(() {
                  _showSpinner = false;
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(
                255, 224, 219, 219), // Set the background color of the body
            child: Column(
              children: [
                Container(
                  color: Colors.deepOrange,
                  height: 100,
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Welcome back'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  userModel?.displayName ?? 'User',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' - ${userModel?.uid ?? 'uid'}',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 30,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  timeDateViewModel.formattedDateTime,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 30,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  timeDateViewModel.formattedDate,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  attendanceViewModel.statusMessage(),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder:
                                              (context) => ConfimationDialogBox(
                                                    title: 'Confirm Time In',
                                                    content:
                                                        'Are you sure you want to time in?',
                                                    onYes: () async {
                                                      setState(() {
                                                        _showSpinner = true;
                                                      });
                                                      try {
                                                        await attendanceViewModel
                                                            .timeIn();
                                                        await attendanceViewModel
                                                            .fetchUserAttendance(
                                                                timeDateViewModel
                                                                    .dateTime);
                                                        Navigator.pop(context);
                                                      } finally {
                                                        setState(() {
                                                          _showSpinner = false;
                                                        });
                                                      }
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              attendanceViewModel
                                                                      .isSuccessInOut
                                                                  ? PromptDialogBox(
                                                                      icon: Icons
                                                                          .check_circle,
                                                                      title:
                                                                          'Time In Successful',
                                                                      content:
                                                                          'You have successfully time in',
                                                                      buttonText:
                                                                          'OK',
                                                                      isSuccess:
                                                                          attendanceViewModel
                                                                              .isSuccessInOut,
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                    )
                                                                  : PromptDialogBox(
                                                                      icon: Icons
                                                                          .error_outline,
                                                                      title:
                                                                          'Time In Failed',
                                                                      content: attendanceViewModel
                                                                              .errorMessage ??
                                                                          'You have failed to time in',
                                                                      buttonText:
                                                                          'OK',
                                                                      isSuccess:
                                                                          attendanceViewModel
                                                                              .isSuccessInOut,
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                    ));
                                                    },
                                                    onNo: () =>
                                                        Navigator.pop(context),
                                                  ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'TIME IN',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder:
                                              (context) => ConfimationDialogBox(
                                                    title: 'Confirm Time Out',
                                                    content:
                                                        'Are you sure you want to time out?',
                                                    onYes: () async {
                                                      await attendanceViewModel
                                                          .timeOut();
                                                      await attendanceViewModel
                                                          .fetchUserAttendance(
                                                              timeDateViewModel
                                                                  .dateTime);
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              attendanceViewModel
                                                                      .isSuccessInOut
                                                                  ? PromptDialogBox(
                                                                      icon: Icons
                                                                          .check_circle,
                                                                      title:
                                                                          'Time Out Successful',
                                                                      content:
                                                                          'You have successfully time out',
                                                                      buttonText:
                                                                          'OK',
                                                                      isSuccess:
                                                                          attendanceViewModel
                                                                              .isSuccessInOut,
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                    )
                                                                  : PromptDialogBox(
                                                                      icon: Icons
                                                                          .error_outline,
                                                                      title:
                                                                          'Time Out Failed',
                                                                      content: attendanceViewModel
                                                                              .errorMessage ??
                                                                          'You have failed to time out',
                                                                      buttonText:
                                                                          'OK',
                                                                      isSuccess:
                                                                          attendanceViewModel
                                                                              .isSuccessInOut,
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                    ));
                                                    },
                                                    onNo: () =>
                                                        Navigator.pop(context),
                                                  ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'TIME OUT',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          'lib/assets/profile.png',
                          width: 100,
                          height: 100,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
