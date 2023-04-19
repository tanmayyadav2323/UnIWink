import 'dart:async';
import 'dart:developer';

import 'package:buddy_go/widgets/big_load_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:sizer/sizer.dart';

class MapScreen extends StatefulWidget {
  static const routename = 'search-page';
  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late TextEditingController textEditingController = TextEditingController();
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: true,
  );

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textEditingController.text);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPickerLocation(
      controller: controller,
      topWidgetPicker: Padding(
        padding: const EdgeInsets.only(
          top: 56,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextFormField(
                controller: textEditingController,
                onEditingComplete: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                decoration: InputDecoration(
                  suffix: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: textEditingController,
                    builder: (ctx, text, child) {
                      if (text.text.isNotEmpty) {
                        return child!;
                      }
                      return SizedBox.shrink();
                    },
                    child: InkWell(
                      focusNode: FocusNode(),
                      onTap: () {
                        textEditingController.clear();
                        controller.setSearchableText("");
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      child: Icon(
                        Icons.close,
                        size: 2.5.h,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.black54,
                  hintText: "search",
                  hintStyle:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,

                  // style: TextStyle(
                  //   fontSize: 16.sp,
                  //   fontWeight: FontWeight.w500,
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TopSearchWidget()
          ],
        ),
      ),
      bottomWidgetPicker: Positioned(
        bottom: 12,
        right: 8,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            GeoPoint p = await controller.selectAdvancedPositionPicker();

            Navigator.pop(context, p);
          },
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ),
      pickerConfig: CustomPickerLocationConfig(
        initZoom: 19,
      ),
    );
  }
}

class TopSearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget> {
  late PickerMapController controller;
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = Key("streamAddressSug");

  @override
  void initState() {
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async {
    final v = controller.searchableText.value;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(Duration(seconds: 3), (timer) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: 5,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  @override
  void dispose() {
    controller.searchableText.removeListener(onSearchableTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child) {
        return AnimatedContainer(
          duration: Duration(
            milliseconds: 500,
          ),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(
            child: child!,
          ),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    snap.data![index].address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  onTap: () async {
                    /// go to location selected by address
                    controller.goToLocation(
                      snap.data![index].point!,
                    );

                    /// hide suggestion card
                    notifierAutoCompletion.value = false;
                    await reInitStream();
                    FocusScope.of(context).requestFocus(
                      new FocusNode(),
                    );
                  },
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return BigLoadAnimations();
          }
          return SizedBox();
        },
      ),
    );
  }
}
