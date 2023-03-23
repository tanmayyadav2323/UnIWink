import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/chat/screens/channel_page.dart';
import 'package:buddy_go/widgets/members_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Chat Page",
              style: GoogleFonts.poppins(
                  fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
            MembersRow(),
            StreamChannelListView(
              shrinkWrap: true,
              controller: _listController,
              itemBuilder: (context, channels, index, defaultChannelTile) {
                final member = channels[index]
                    .state!
                    .members
                    .firstWhere((m) => m.userId != SessionHelper.id)
                    .user;
                if (channels.isNotEmpty) {
                  return ListTile(
                    tileColor: Colors.black,
                    leading: CircleAvatar(
                      radius: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          member!.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}
