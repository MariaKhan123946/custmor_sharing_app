import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'UpdateBlogPage.dart';

class BlogListPage extends StatelessWidget {
  final CollectionReference blogCollection = FirebaseFirestore.instance.collection('blogs');

  Future<void> _deleteBlog(String docId, BuildContext context) async {
    await blogCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Blog deleted successfully')),
    );
  }

  Future<void> _toggleFavorite(String docId, bool isFavorite, int currentLikes) async {
    await blogCollection.doc(docId).update({
      'isFavorite': !isFavorite,
      'likes': !isFavorite ? currentLikes + 1 : currentLikes - 1,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog List'),
      ),
      body: StreamBuilder(
        stream: blogCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data['imageUrl'] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            data['imageUrl'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Container(),
                        SizedBox(height: 10),
                        Text(
                          data['title'] ?? 'No Title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          data['content'] ?? 'No Content',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                data['isFavorite'] == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () => _toggleFavorite(
                                doc.id,
                                data['isFavorite'] ?? false,
                                data['likes'] ?? 0,
                              ),
                            ),
                            Text('${data['likes'] ?? 0} likes'),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateBlogPage(docId: doc.id, data: data),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteBlog(doc.id, context),
                            ),
                          ],
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
    );
  }
}
