import 'package:buddy_go/features/events/services/event_services.dart';
import 'package:buddy_go/features/home/screens/home_screen.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class CustomModalSheet extends StatefulWidget {
  final String eventId;

  const CustomModalSheet({super.key, required this.eventId});

  @override
  State<CustomModalSheet> createState() => _CustomModalSheetState();
}

class _CustomModalSheetState extends State<CustomModalSheet> {
  final EventServices eventServices = EventServices();
  bool _loading = false;

  List<String> messages = [
    "I just don't like it",
    "It's Spam",
    "Nudity or sexual activity",
    "Hate speech or symbols",
    "False information",
    "Bullying or harrasment",
    "Violence or dangerous organization",
    "Scam or fraud",
    "Intellectual property violation",
    "Sale of illegalor regulated goods",
  ];
  bool _showSecond = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      child: AnimatedCrossFade(
        alignment: Alignment.center,
        secondChild: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.report,
                color: Colors.red,
                size: 10.h,
              ),
              Text(
                "Event Reported!",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Our team will look into it soon",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              CustomButton(
                buttonText: "Okay",
                loading: _loading,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
        crossFadeState:
            _showSecond ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500),
        firstChild: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 1.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0XFF444444),
                      borderRadius: BorderRadius.circular(20)),
                  height: 0.8.h,
                  width: 20.w,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Report",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "Why are you reporting this event?",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    minLeadingWidth: 0,
                    leading: null,
                    title: Text(
                      messages[index],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      _showSecond = true;
                      _loading = true;
                      setState(() {});
                      await eventServices.reportEvent(
                          context: context,
                          eventId: widget.eventId,
                          message: messages[index]);
                      _loading = false;
                      setState(() {});
                    },
                  );
                },
                itemCount: messages.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
