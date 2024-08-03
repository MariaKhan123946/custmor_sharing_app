//
// import 'package:flutter/material.dart';
//
// import '../widget/post_widget.dart';
//
// // Assuming PostWidget is defined here or imported correctly
// class PostWidget extends StatelessWidget {
//   final Post post;
//
//   PostWidget({required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             backgroundImage: AssetImage(post.profileImageUrl),
//           ),
//           title: Text(post.name),
//           subtitle: Text(post.location),
//         ),
//         Image.asset(post.postImageUrl),
//         Text(post.startTime),
//         Text(post.endTime),
//         Text(post.postTime),
//       ],
//     );
//   }
// }
