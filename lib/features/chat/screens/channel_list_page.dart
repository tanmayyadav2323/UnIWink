import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/chat/screens/channel_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatefulWidget {
  static const routename = 'channel-list-page';

  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late StreamChannelListController _listController;

  @override
  void initState() {
    _listController = StreamChannelListController(
      client: StreamChat.of(context).client,
      filter: Filter.in_(
        'members',
        [StreamChat.of(context).currentUser!.id],
      ),
      sort: const [SortOption('last_message_at')],
      limit: 20,
    );
    super.initState();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        itemBuilder: (context, channels, index, defaultChannelTile) {
          if (channels.isNotEmpty) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Tanmay"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StreamChannel(
                      key: ValueKey(channels[index].cid),
                      channel: channels[index],
                      child: const ChannelPage(),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
        onChannelTap: (channel) {},
      ),
    );
  }

  Widget _channelTileBuilder(BuildContext context, List<Channel> channels,
      int index, StreamChannelListTile defaultChannelTile) {
    try {
      final channel = channels[index];
      final lastMessage = channel.state?.messages.reversed.firstWhere(
        (message) => message.isDeleted,
      );

      final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
      final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;

      final theme = StreamChatTheme.of(context);

      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamChannel(
                channel: channel,
                child: const ChannelPage(),
              ),
            ),
          );
        },
        leading: StreamChannelAvatar(
          channel: channel,
        ),
        title: StreamChannelName(
          channel: channel,
          textStyle: theme.channelPreviewTheme.titleStyle!.copyWith(
            color: theme.colorTheme.textHighEmphasis.withOpacity(opacity),
          ),
        ),
        subtitle: Text(subtitle),
        trailing: channel.state!.unreadCount > 0
            ? CircleAvatar(
                radius: 10,
                child: Text(channel.state!.unreadCount.toString()),
              )
            : const SizedBox(),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return const SizedBox();
  }
}
