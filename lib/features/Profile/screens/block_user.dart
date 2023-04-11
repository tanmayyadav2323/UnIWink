// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class BlockListPage extends StatefulWidget {
//   @override
//   _BlockListPageState createState() => _BlockListPageState();
// }

// class _BlockListPageState extends State<BlockListPage> {
//   late Stream<List> _banListStream;

//   @override
//   Future<void> initState() async {
//     super.initState();
//     _banListStream =
//         await StreamChat.of(context).client.queryBannedUsers(filter: {
//       'created_by_id': moderatorUserId,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blocked Users'),
//       ),
//       body: StreamBuilder<List>(
//         stream: _banListStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           final bannedUsers = snapshot.data;
//           if (bannedUsers == null || bannedUsers.isEmpty) {
//             return Center(child: Text('No users have been blocked.'));
//           }
//           return ListView.builder(
//             itemCount: bannedUsers.length,
//             itemBuilder: (context, index) {
//               final bannedUser = bannedUsers[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(bannedUser.user.image),
//                 ),
//                 title: Text(bannedUser.user.name),
//                 subtitle: Text(bannedUser.reason),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () async {
//                     await StreamChat.of(context)
//                         .client
//                         .unbanUser(bannedUser.user.id);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
