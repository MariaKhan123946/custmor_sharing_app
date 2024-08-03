import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateBlogPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  UpdateBlogPage({required this.docId, required this.data});

  @override
  _UpdateBlogPageState createState() => _UpdateBlogPageState();
}

class _UpdateBlogPageState extends State<UpdateBlogPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  final CollectionReference blogCollection = FirebaseFirestore.instance.collection('blogs');

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['title']);
    _contentController = TextEditingController(text: widget.data['content']);
    _imageUrlController = TextEditingController(text: widget.data['imageUrl']);
  }

  Future<void> _updateBlog() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Content cannot be empty')),
      );
      return;
    }

    await blogCollection.doc(widget.docId).update({
      'title': _titleController.text,
      'content': _contentController.text,
      'imageUrl': _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Blog updated successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Blog'),
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
              onPressed: _updateBlog,
              child: Text('Update Blog'),
            ),
          ],
        ),
      ),
    );
  }
}
