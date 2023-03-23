import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    Key? key,
    this.showBackButton = true,
    this.onBackPressed,
  }) : super(key: key);

  final bool showBackButton;
  final void Function(BuildContext)? onBackPressed;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late final messageInputController = StreamMessageInputController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: StreamChannelHeader(
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
                    onMessageSwiped:
                        (CurrentPlatform.isAndroid || CurrentPlatform.isIos)
                            ? reply
                            : null,
                    threadBuilder: (context, parent) {
                      return ThreadPage(
                        parent: parent!,
                      );
                    },
                    messageBuilder:
                        (context, details, messages, defaultWidget) {
                      return defaultWidget.copyWith(
                        onReplyTap: reply,
                      );
                    },
                    key: widget.key,
                  ),
                ),
                StreamMessageInput(
                  onQuotedMessageCleared:
                      messageInputController.clearQuotedMessage,
                  focusNode: focusNode,
                  messageInputController: messageInputController,
                ),
              ],
            ),
          ),
        ),
      );

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
