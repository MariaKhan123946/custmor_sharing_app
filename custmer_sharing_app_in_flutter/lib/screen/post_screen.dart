// import 'package:customer_sharing/main.dart';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'new_post.dart';
//  // Import your Post class here
//  // Adjust path based on your project structure
//
// class PostsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Posts'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('posts').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           List<PostWidget> postWidgets = snapshot.data!.docs.map((doc) {
//             var data = doc.data() as Map<String, dynamic>;
//             return PostWidget(
//               post: Post(
//                 id: doc.id,
//                 profileImageUrl: data['profileImageUrl'],
//                 name: data['name'],
//                 location: data['location'],
//                 startTime: data['startTime'],
//                 endTime: data['endTime'],
//                 postTime: data['postTime'],
//                 postImageUrl: data['postImageUrl'],
//               ),
//             );
//           }).toList();
//
//           return ListView(
//             children: postWidgets,
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostScreen()));
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
