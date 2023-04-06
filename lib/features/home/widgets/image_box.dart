// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ImageBox extends StatefulWidget {
  final List<XFile?> images;
  final Function(dynamic) onTap;

  const ImageBox({
    Key? key,
    required this.images,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      spacing: 2.w,
      runSpacing: 1.h,
      children: widget.images.map((image) {
        return Stack(
          children: [
            Container(
              width: 25.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.file(
                  File(image!.path),
                  width: 25.w,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 0.8.h,
              right: 0.5.h,
              child: InkWell(
                onTap: () {
                  widget.images.remove(image);
                  setState(() {});
                  widget.onTap(image);
                },
                child: CircleAvatar(
                  radius: 1.h,
                  child: Icon(
                    Icons.close,
                    size: 1.5.h,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
