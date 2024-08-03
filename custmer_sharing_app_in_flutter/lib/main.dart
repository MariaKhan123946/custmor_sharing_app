
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/splash_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class Post {
  final String id;
  final String profileImageUrl;
  final String name;
  final String location;
  final String startTime;
  final String endTime;
  final String postTime;
  final String postImageUrl;
  Post({
    required this.id,
    required this.profileImageUrl,
    required this.name,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.postTime,
    required this.postImageUrl,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:SplashPage(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  int _newPostsCount = 0;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts when the widget is initialized
  }

  void _fetchPosts() {
    FirebaseFirestore.instance.collection('posts').snapshots().listen((snapshot) {
      setState(() {
        _isLoading = false; // Set loading to false once data is received
      });
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          setState(() {
            _newPostsCount++; // Increment new posts count
          });
        }
      }
    }, onError: (error) {
      setState(() {
        _isLoading = false; // Set loading to false on error
      });
      print('Error fetching posts: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('images/img.png', width: 100), // Replace with the actual path
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: Colors.purple),
                if (_newPostsCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_newPostsCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _newPostsCount = 0; // Clear notifications on tap
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<PostWidget> postWidgets = snapshot.data!.docs.map((DocumentSnapshot doc) {
            var data = doc.data() as Map<String, dynamic>;
            return PostWidget(
              post: Post(
                id: doc.id,
                profileImageUrl: data['profileImageUrl'],
                name: data['name'],
                location: data['location'],
                startTime: data['startTime'],
                endTime: data['endTime'],
                postTime: data['postTime'],
                postImageUrl: data['postImageUrl'],
              ),
            );
          }).toList();

          return ListView(
            children: postWidgets,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('images/img_5.png'),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Handshake',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostScreen()));
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});

  void addComment(String postId, String commentText) {
    // Add comment logic as before
  }

  void initiateMeeting(String postId) {
    // Implement meeting initiation logic if needed
  }

  void _navigateToChatScreen(BuildContext context, String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(postId: postId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(post.profileImageUrl),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${post.name} ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                  'is at ${post.location} from ${post.startTime} until ${post.endTime}',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          subtitle: Text(post.postTime),
        ),
        Image.network(
          post.postImageUrl,
          height: 200,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.purple),
                label: Text('Chat', style: TextStyle(color: Colors.purple)),
                onPressed: () {
                  _navigateToChatScreen(context, post.id);
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.send, color: Colors.purple),
                label: Text('Meet', style: TextStyle(color: Colors.purple)),
                onPressed: () {
                  initiateMeeting(post.id);
                },
              ),
            ],
          ),
        ),
        Divider(),

      ],
    );
  }
}

class NewPostScreen extends StatelessWidget {
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _profileImageUrlController = TextEditingController(); // New controller for profile image URL
  final TextEditingController _nameController = TextEditingController(); // New controller for name
  final TextEditingController _locationController = TextEditingController(); // New controller for location
  final TextEditingController _startTimeController = TextEditingController(); // New controller for start time
  final TextEditingController _endTimeController = TextEditingController(); // New controller for end time
  final TextEditingController _postTimeController = TextEditingController(); // New controller for post time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _profileImageUrlController,
                decoration: InputDecoration(labelText: 'Profile Image URL'), // New field for profile image URL
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'), // New field for name
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'), // New field for location
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: 'Start Time'), // New field for start time
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: 'End Time'), // New field for end time
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _postTimeController,
                decoration: InputDecoration(labelText: 'Post Time'), // New field for post time
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _captionController,
                decoration: InputDecoration(labelText: 'Caption'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement logic to add new post to Firestore
                  FirebaseFirestore.instance.collection('posts').add({
                    'profileImageUrl': _profileImageUrlController.text.trim(), // Use user-provided profile image URL
                    'name': _nameController.text.trim(), // Use user-provided name
                    'location': _locationController.text.trim(), // Use user-provided location
                    'startTime': _startTimeController.text.trim(), // Use user-provided start time
                    'endTime': _endTimeController.text.trim(), // Use user-provided end time
                    'postTime': _postTimeController.text.trim(), // Use user-provided post time
                    'postImageUrl': _imageUrlController.text.trim(), // Use user-provided URL
                    'caption': _captionController.text.trim(), // Use user-provided caption
                  }).then((value) {
                    Navigator.pop(context); // Return to previous screen after adding post
                  }).catchError((error) => print("Failed to add post: $error"));
                },
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String postId;

  ChatScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Center(
        child: Text('Chat functionality for post: $postId'),
      ),
    );
  }
}
