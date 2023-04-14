import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/Profile/screens/profile_screen.dart';
import 'package:buddy_go/features/chat/screens/channel_page.dart';
import 'package:buddy_go/widgets/members_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      filter: Filter.and([
        Filter.in_('members', [SessionHelper.id]),
        Filter.notExists('channel_type'),
      ]),
      sort: const [SortOption('last_message_at')],
      limit: 20,
    );
    super.initState();
  }

  bool buddies = true;

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  // Icon(Icons.arrow_back_ios),

                  // Text(
                  //   "Your Pairs",
                  //   style: GoogleFonts.poppins(
                  //       fontSize: 16.sp, fontWeight: FontWeight.w400),
                  // ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 3.h,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Messages ",
                        style: GoogleFonts.poppins(
                            fontSize: 20.sp, color: Colors.white),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 3.h,
                      )
                    ],
                  ),
                  const MembersRow(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 4.h),
                    height: 4.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 1),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              gradient: buddies == false
                                  ? LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.4)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null,
                            ),
                            child: InkWell(
                              onTap: () {
                                buddies = true;
                                _listController = StreamChannelListController(
                                  client: StreamChat.of(context).client,
                                  filter: Filter.and([
                                    Filter.in_('members', [SessionHelper.id]),
                                    Filter.notExists('channel_type'),
                                  ]),
                                  sort: const [SortOption('last_message_at')],
                                  limit: 20,
                                );
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: buddies
                                      ? Color(0xffB70450)
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Buddies",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 1),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              gradient: buddies == true
                                  ? LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.4)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null,
                            ),
                            child: InkWell(
                              onTap: () {
                                buddies = false;
                                _listController = StreamChannelListController(
                                  client: StreamChat.of(context).client,
                                  filter: Filter.and([
                                    Filter.in_('members', [SessionHelper.id]),
                                    Filter.notExists('channel_type'),
                                    Filter.exists('${SessionHelper.id}_fav'),
                                    Filter.equal('${SessionHelper.id}_fav', "1")
                                  ]),
                                  sort: const [SortOption('last_message_at')],
                                  limit: 20,
                                );
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: buddies == false
                                      ? Color(0xffB70450)
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Favorites",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamChannelListView(
              shrinkWrap: true,
              controller: _listController,
              itemBuilder: _channelTileBuilder,
              onChannelTap: (channel) {
                return;
              },
              emptyBuilder: (context) {
                return Expanded(
                  child: Center(
                    child: Text(
                      buddies ? "No Chats Yet" : "Mark your favorites now",
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _channelTileBuilder(BuildContext context, List<Channel> channels,
      int index, StreamChannelListTile defaultChannelTile) {
    final channel = channels[index];
    var lastMessage = null; 
    final member = channels[index]
        .state!
        .members
        .firstWhere((m) => m.userId != SessionHelper.id)
        .user;
    if (channel.state?.messages != null) {
      lastMessage = channel.state?.messages.reversed
          .firstWhere((message) => !message.isDeleted, orElse: () {
        return Message(text: "Send a message now");
      });
    }
    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;
    final theme = StreamChatTheme.of(context);

    String favorite =
        channels[index].extraData['${SessionHelper.id}_fav'] == null
            ? "0"
            : (channels[index].extraData['${SessionHelper.id}_fav'].toString());

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: ChannelPage(
                name: channels[index].extraData['${member.id}_name'].toString(),
              ),
            ),
          ),
        );
      },
      tileColor: channel.state!.unreadCount > 0
          ? Color(0xffB70450).withOpacity(0.4)
          : Colors.transparent,
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen(id: member.id)),
          );
        },
        child: Stack(
          children: [
            CircleAvatar(
              radius: 4.5.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  member!.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0.5.h,
              right: 2.5.w,
              child: CircleAvatar(
                backgroundColor: Color(0xff0D0E34),
                radius: 0.75.h,
                child: CircleAvatar(
                  radius: 0.50.h,
                  backgroundColor:
                      member.online ? Color(0xff00AE31) : Color(0xffAE0000),
                ),
              ),
            )
          ],
        ),
      ),
      title: Text(channels[index].extraData['${member.id}_name'].toString()),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SizedBox(
        width: 25.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: favorite == "0"
                  ? Icon(Icons.favorite_outline)
                  : Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
              onTap: () async {
                if (favorite == "0") {
                  favorite = "1";
                } else {
                  favorite = "0";
                }
                await channel
                    .updatePartial(set: {'${SessionHelper.id}_fav': favorite});
                setState(() {});
              },
            ),
            Spacer(),
            channel.lastMessageAt != null
                ? Text(
                    getTime(channel.lastMessageAt!),
                    style: GoogleFonts.poppins(
                        fontSize: 7.sp, fontWeight: FontWeight.w300),
                  )
                : SizedBox.shrink(),
            Spacer()
          ],
        ),
      ),
    );
  }

  getTime(DateTime dateTime) {
    String timeAgo = timeago.format(dateTime, allowFromNow: true);
    return timeAgo;
  }
}
