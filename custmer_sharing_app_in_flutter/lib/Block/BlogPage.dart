import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'BlogListPage.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final CollectionReference blogCollection = FirebaseFirestore.instance.collection('blogs');

  Future<void> _uploadBlog() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Content cannot be empty')),
      );
      return;
    }

    try {
      await blogCollection.add({
        'title': _titleController.text,
        'content': _contentController.text,
        'imageUrl': _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
        'timestamp': FieldValue.serverTimestamp(),
        'isFavorite': false,
        'likes': 0,
      });

      _titleController.clear();
      _contentController.clear();
      _imageUrlController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blog posted successfully')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlogListPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post blog: $e')),
      );
      print('Error posting blog: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadBlog,
              child: Text('Post Blog'),
            ),
          ],
        ),
      ),
    );
  }
}
