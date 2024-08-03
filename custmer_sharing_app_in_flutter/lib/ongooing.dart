import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OngoingMeetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Meets'),
        backgroundColor: Colors.purple, // Customize the AppBar color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ongoing_meets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ongoing meets'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMeetRow(
                    data['name'] ?? 'No name',
                    data['details'] ?? 'No details',
                  ),
                  Divider(),
                ],
              );
            }).toList(),
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
            label: 'Handshake',
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

  Widget _buildMeetRow(String name, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.black, // Dark black color
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            details,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6), // Slightly lighter color
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
