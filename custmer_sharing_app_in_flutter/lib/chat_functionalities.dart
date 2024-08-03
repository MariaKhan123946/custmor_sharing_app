// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // Chat functionality
// void startChat(String userId, String friendId) {
//   FirebaseFirestore.instance.collection('chats').add({
//     'users': [userId, friendId],
//     'started_at': Timestamp.now(),
//   });
// }
//
// // Meet functionality
// void scheduleMeet(String userId, String friendId) {
//   FirebaseFirestore.instance.collection('meets').add({
//     'users': [userId, friendId],
//     'scheduled_at': Timestamp.now(),
//   });
// }
//
// // In PostWidget
// TextButton.icon(
// icon: Icon(Icons.chat_bubble_outline, color: Colors.purple),
// label: Text('Chat', style: TextStyle(color: Colors.purple)),
// onPressed: () {
// startChat(currentUser.id, friendId); // Add currentUser and friendId accordingly
// },
// ),
// TextButton.icon(
// icon: Icon(Icons.send, color: Colors.purple),
// label: Text('Meet', style: TextStyle(color: Colors.purple)),
// onPressed: () {
// scheduleMeet(currentUser.id, friendId); // Add currentUser and friendId accordingly
// },
// ),
