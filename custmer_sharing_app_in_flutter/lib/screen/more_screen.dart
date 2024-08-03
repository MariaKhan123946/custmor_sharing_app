import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custmer_sharing_app_in_flutter/Block/BlogPage.dart';
import 'package:custmer_sharing_app_in_flutter/home_page.dart';
import 'package:custmer_sharing_app_in_flutter/pages/share_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Block/zab_connect_page.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuItem(
                imagePath: 'images/img_21.png',
                label: 'Connect',
                onTap: () => _handleConnect(context),
              ),
              SizedBox(height: 16),
              _buildMenuItem(
                imagePath: 'images/img_24.png',
                label: 'Share Pages',
                onTap: () => _handleSharePages(context),
              ),
              SizedBox(height: 16),
              _buildMenuItem(
                imagePath: 'images/img_23.png',
                label: 'Blogs',
                onTap: () => _handleBlogs(context),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.handshake), label: 'Handshake'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 1:
            // Handle navigation for 'Handshake' or other indices if needed
              break;
          // Add cases for other indices as needed
          }
        },
      ),
    );
  }

  Widget _buildMenuItem({required String imagePath, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 50, color: Colors.deepPurple),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _handleConnect(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ZabConnectPage()), // Navigate to ZabConnectPage
    );
  }

  void _handleSharePages(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShareContentApp()), // Navigate to ShareContentApp
    );
  }

  void _handleBlogs(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPage()), // Navigate to Home page for Blogs
    );
  }
}
