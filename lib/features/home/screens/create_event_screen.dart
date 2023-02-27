import 'dart:io';

import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CreateEventScreen extends StatefulWidget {
  static const routename = '/create-event-screen';

  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  final ImagePicker _picker = ImagePicker();
  XFile? images;
  List<XFile>? eventImage;

  void pickImage(ImageSource source, bool singleImage) async {
    if (singleImage) {
      final pickedFile = await _picker.pickImage(source: source);
      images = pickedFile;
    } else {
      final pickedFiles = await _picker.pickMultiImage();
      eventImage = pickedFiles;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Create Event",
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    controller: _titleController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    controller: _aboutController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "About",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 8,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () {
                      pickImage(ImageSource.gallery, true);
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Upload Profile",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () {
                      pickImage(ImageSource.gallery, false);
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Upload Event Images",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      HomeServices().createEvent(
                          context: context,
                          title: _titleController.text,
                          about: _aboutController.text,
                          startDate: startDate,
                          endDate: endDate,
                          profileImage: images!,
                          images: eventImage!);
                    },
                    child: Text("Save"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
