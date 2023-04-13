import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/Dashboard/screns/dashboard_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/features/home/widgets/image_box.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/widgets/custom_button.dart';

DateTime _selectedStartDate = DateTime.now();
DateTime _selectedEndDate = DateTime.now();

class CreateEventScreen extends StatefulWidget {
  static const routename = '/create-event-screen';
  final EventModel? eventModel;

  const CreateEventScreen({
    Key? key,
    this.eventModel,
  }) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  XFile? coverImage;
  List<XFile>? eventImage;
  bool saving = false;

  TimeOfDay? _startDay;
  TimeOfDay? _endDay;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: 0.5).animate(_animationController);
    if (widget.eventModel != null) {
      final event = widget.eventModel!;
      _titleController.text = event.title;
      _aboutController.text = event.about;
      _orgController.text = event.organizer;
      _selectedStartDate = event.startDateTime;
      _selectedEndDate = event.endDateTime;
      _startDay = TimeOfDay(
          hour: event.startDateTime.hour, minute: event.startDateTime.minute);
      _endDay = TimeOfDay(
          hour: event.endDateTime.hour, minute: event.endDateTime.minute);
      getImages();
    }
    super.initState();
  }

  Future<void> getImages() async {
    coverImage = await _fileFromImageUrl(widget.eventModel!.image, 0);
    eventImage ??= [];
    for (int i = 0; i < widget.eventModel!.images!.length; i++) {
      eventImage!
          .add(await _fileFromImageUrl(widget.eventModel!.images![i], i + 1));
    }
    setState(() {});
  }

  Future<XFile> _fileFromImageUrl(imageUrl, int index) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file =
        File(path.join(documentDirectory.path, 'File Name${index}.jpg'));

    file.writeAsBytesSync(response.bodyBytes);
    return XFile(file.path);
  }

  bool validate() {
    if (_titleController.text.isEmpty ||
        _aboutController.text.isEmpty ||
        _orgController.text.isEmpty ||
        coverImage == null ||
        eventImage == null ||
        eventImage!.isEmpty ||
        _startDay == null ||
        _endDay == null) {
      return true;
    }
    return false;
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: (index == 0 ? _startDay : _endDay) ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (index == 0) {
          _startDay = pickedTime;
        } else {
          _endDay = pickedTime;
        }
      });
    }
  }

  void pickImage(ImageSource source, bool singleImage) async {
    if (singleImage) {
      final pickedFile = await _picker.pickImage(source: source);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio4x3,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Pick Cover Image",
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
          )
        ],
        compressQuality: 100,
      );
      coverImage = XFile(croppedFile!.path);
    } else {
      final pickedFiles = await _picker.pickMultiImage();
      eventImage ??= [];
      eventImage!.addAll(pickedFiles);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _animationController.forward().then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: RotationTransition(
                          turns: _animation,
                          child: Icon(
                            Icons.keyboard_arrow_up_outlined,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.eventModel == null
                                ? "Add Event"
                                : "Edit Event",
                            style: GoogleFonts.poppins(
                                fontSize: 20.sp, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.sp,
                      )
                    ],
                  ),

                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    controller: _titleController,
                    cursorColor: Colors.white,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: "Event Name",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (details) => true,
                    child: CalendarRangePicker(),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    controller: _orgController,
                    cursorColor: Colors.white,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: "Organized by",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Time",
                              style: GoogleFonts.poppins(fontSize: 10.sp),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => _selectTime(context, 0),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.3)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(1.5.w),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    _startDay != null
                                        ? '${_startDay!.hour}:${_startDay!.minute.toString().padLeft(2, '0')} ${_startDay!.period == DayPeriod.am ? 'am' : 'pm'}'
                                        : '',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Time",
                              style: GoogleFonts.poppins(fontSize: 10.sp),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => _selectTime(context, 1),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.3)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(1.5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: backgroundColor,
                                  ),
                                  child: Text(
                                    _endDay != null
                                        ? '${_endDay!.hour}:${_endDay!.minute.toString().padLeft(2, '0')} ${_endDay!.period == DayPeriod.am ? 'am' : 'pm'}'
                                        : '',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff272A70),
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: TextFormField(
                      controller: _aboutController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: InputDecoration(
                        hintText: "Event Description",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        // focusedBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        // border: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                      ),
                      minLines: 4,
                      maxLines: 4,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Add Cover Image",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      InkWell(
                        onTap: () {
                          pickImage(ImageSource.gallery, true);
                        },
                        child: SvgPicture.asset("assets/icons/add_image.svg"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  if (coverImage != null)
                    ImageBox(
                      images: [coverImage],
                      onTap: (image) {
                        coverImage = null;
                      },
                    ),

                  SizedBox(
                    height: 3.h,
                  ),

                  Row(
                    children: [
                      Text(
                        "Add More images",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      InkWell(
                          onTap: () => pickImage(ImageSource.gallery, false),
                          child: SvgPicture.asset("assets/icons/add_image.svg"))
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  if (eventImage != null)
                    ImageBox(
                      images: eventImage!,
                      onTap: (images) {
                        eventImage = images;
                      },
                    ),
                  // TextFormField(
                  //   readOnly: true,
                  //   onTap: () {
                  //     pickImage(ImageSource.gallery, true);
                  //   },
                  //   cursorColor: Colors.white,
                  //   decoration: InputDecoration(
                  //     hintText: "Upload Profile",
                  //     hintStyle: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 3.h,
                  // ),
                  // TextFormField(
                  //   readOnly: true,
                  //   onTap: () {
                  //     pickImage(ImageSource.gallery, false);
                  //   },
                  //   cursorColor: Colors.white,
                  //   decoration: InputDecoration(
                  //     hintText: "Upload Event Images",
                  //     hintStyle: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      loading: saving,
                      buttonText: "Save",
                      onPressed: () async {
                        if (validate()) {
                          Fluttertoast.showToast(
                              msg: "Please eneter all fields");
                        } else {
                          Fluttertoast.showToast(msg: "Saving");
                          _selectedStartDate = DateTime(
                              _selectedStartDate.year,
                              _selectedStartDate.month,
                              _selectedStartDate.day,
                              _startDay!.hour,
                              _startDay!.minute);
                          _selectedEndDate = DateTime(
                            _selectedEndDate.year,
                            _selectedEndDate.month,
                            _selectedEndDate.day,
                            _endDay!.hour,
                            _endDay!.minute,
                          );

                          setState(() {
                            saving = true;
                          });

                          if (widget.eventModel == null) {
                            await HomeServices()
                                .createEvent(
                              organizer: _orgController.text,
                              context: context,
                              title: _titleController.text,
                              about: _aboutController.text,
                              startDate: _selectedStartDate,
                              endDate: _selectedEndDate,
                              profileImage: coverImage!,
                              images: eventImage!,
                            )
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          } else {
                            await HomeServices()
                                .editEvent(
                              id: widget.eventModel!.id,
                              organizer: _orgController.text,
                              context: context,
                              title: _titleController.text,
                              about: _aboutController.text,
                              startDate: _selectedStartDate,
                              endDate: _selectedEndDate,
                              profileImage: coverImage!,
                              images: eventImage!,
                            )
                                .then((value) {
                              Navigator.of(context).popUntil((route) =>
                                  route.settings.name ==
                                  DashBoardScreen.routename);
                              Navigator.of(context).pushReplacementNamed(
                                  DashBoardScreen.routename);
                            });
                          }

                          setState(() {
                            saving = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarRangePicker extends StatefulWidget {
  @override
  _CalendarRangePickerState createState() => _CalendarRangePickerState();
}

class _CalendarRangePickerState extends State<CalendarRangePicker> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool firstTap = false;

  DateTime _focusedDay = DateTime.now();
  final DateTime _selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 365)),
          selectedDayPredicate: (DateTime date) {
            if (_selectedStartDate == null || _selectedEndDate == null) {
              return false;
            } else if (date.isAfter(_selectedStartDate) &&
                date.isBefore(_selectedEndDate)) {
              return true;
            } else if (date.isAtSameMomentAs(_selectedStartDate) ||
                date.isAtSameMomentAs(_selectedEndDate)) {
              return true;
            } else if (date.isAtSameMomentAs(_selectedStartDate) &&
                date.isAtSameMomentAs(_selectedEndDate)) {
              return true;
            } else {
              return false;
            }
          },
          onDaySelected: (date, events) {
            if (firstTap == false || date.isBefore(_selectedStartDate)) {
              _selectedStartDate = date;
              if (_selectedEndDate.isBefore(date)) _selectedEndDate = date;
              firstTap = true;
              setState(() {});
            } else if (firstTap) {
              _selectedEndDate = date;

              firstTap = false;
              setState(() {});
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          rowHeight: 6.h,
          daysOfWeekHeight: 4.h,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade400),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedTextStyle: const TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade400),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            outsideDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            disabledDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            weekendTextStyle: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
            weekNumberTextStyle: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonShowsNext: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            formatButtonTextStyle: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            headerPadding: EdgeInsets.symmetric(vertical: 3.h),
            formatButtonPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            formatButtonDecoration: BoxDecoration(
              color: Color(0xffB70450),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          rangeSelectionMode: RangeSelectionMode.toggledOn,
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          'Start Date :  ${DateFormat('MMMM dd, yyyy').format(_selectedStartDate)}',
          style: GoogleFonts.poppins(fontSize: 10.sp),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          'End Date :  ${DateFormat('MMMM dd, yyyy').format(_selectedEndDate)}',
          style: GoogleFonts.poppins(fontSize: 10.sp),
        ),
      ],
    );
  }
}
