import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ZabConnectPage extends StatefulWidget {
  @override
  _ZabConnectPageState createState() => _ZabConnectPageState();
}

class _ZabConnectPageState extends State<ZabConnectPage> {
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference _connectionsCollection = FirebaseFirestore.instance.collection('connections');

  Future<void> _addConnection(String userId) async {
    String currentUserId = 'currentUserId'; // Replace with actual user ID

    final existingConnection = await _connectionsCollection
        .where('userIds', arrayContains: currentUserId)
        .where('userIds', arrayContains: userId)
        .get();
    if (existingConnection.docs.isEmpty) {
      await _connectionsCollection.add({
        'userIds': [currentUserId, userId],
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection already exists')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zab Connect'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Users',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {}); // Trigger rebuild to apply search filter
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild the widget to update search results
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersCollection
                    .where('name', isGreaterThanOrEqualTo: _searchController.text.trim())
                    .where('name', isLessThanOrEqualTo: _searchController.text.trim() + '\uf8ff')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found.'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      String userId = doc.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: data['imageUrl'] != null
                                      ? NetworkImage(data['imageUrl'])
                                      : AssetImage('images/ec27b19c2e3d902762f80cf817c3350a.jpg',) as ImageProvider,
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    data['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _addConnection(userId),
                                  child: Text('Connect'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
