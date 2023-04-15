import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  ChannelPage(
      {Key? key,
      this.showBackButton = true,
      this.onBackPressed,
      this.joined = true,
      required this.onTap,
      this.isAdmin = false,
      this.name = ''})
      : super(key: key);

  final bool showBackButton;
  final bool joined;
  final bool isAdmin;
  final Function() onTap;
  final String name;
  final void Function(BuildContext)? onBackPressed;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late final messageInputController = StreamMessageInputController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.showBackButton == false
          ? null
          : StreamChannelHeader(
              showTypingIndicator: true,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Text(
                widget.name,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              onBackPressed: widget.onBackPressed != null
                  ? () {
                      widget.onBackPressed!(context);
                    }
                  : null,
              showBackButton: widget.showBackButton,
            ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              dateDividerBuilder: (date) {
                return CutsomDateWidget(date);
              },
              onMessageSwiped:
                  (CurrentPlatform.isAndroid || CurrentPlatform.isIos)
                      ? reply
                      : null,
              threadBuilder: (context, parent) {
                return ThreadPage(
                  parent: parent!,
                );
              },
              messageBuilder: (context, details, messages, defaultWidget) {
                return defaultWidget.copyWith(
                  showUsername: false,
                  showPinHighlight: false,
                  showPinButton: false,
                  onReplyTap: reply,
                  customActions: [
                    if (widget.isAdmin &&
                        details.message.user!.id != SessionHelper.id)
                      StreamMessageAction(
                        leading: Icon(Icons.block),
                        title: Text("Block"),
                        onTap: (_) {
                          widget.onTap();
                        },
                      )
                  ],
                  textBuilder: (p0, p1) => Text("hey"),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3.w),
                  borderRadiusGeometry: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                );
              },
              key: widget.key,
            ),
          ),
          if (widget.joined)
            StreamMessageInput(
              onQuotedMessageCleared: messageInputController.clearQuotedMessage,
              focusNode: focusNode,
              messageInputController: messageInputController,
            ),
        ],
      ),
    );
  }

  void reply(Message message) {
    messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageInputController.dispose();
    super.dispose();
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({
    super.key,
    required this.parent,
  });

  final Message parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(
        parent: parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            messageInputController: StreamMessageInputController(
              message: Message(parentId: parent.id),
            ),
          ),
        ],
      ),
    );
  }
}

class CutsomDateWidget extends StatelessWidget {
  final DateTime date;

  CutsomDateWidget(this.date);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isYesterday = date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    final formatter = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Text(
        isToday
            ? 'Today, ${formatter.format(date)}'
            : isYesterday
                ? 'Yesterday, ${formatter.format(date)}'
                : formatter.format(date),
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xff55578F),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
