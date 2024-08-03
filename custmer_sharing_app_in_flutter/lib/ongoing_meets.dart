import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OngoingMeetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Meets'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('meets').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ongoing meets found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var meet = snapshot.data!.docs[index];
              return ListTile(
                title: Text(
                  meet['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'is meeting ${meet['meetingWith']} at ${meet['location']}',
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Ongoing Meets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            label: 'Ongoing Meets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'More',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        onTap: (index) {
          // Handle navigation logic here
        },
      ),
    );
  }
}
