import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardsPage extends StatelessWidget {
  const BoardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Boards'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('message_boards').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No boards found. Start creating one!'),
            );
          }

          final boardItems = snapshot.data!.docs;

          return ListView.separated(
            itemCount: boardItems.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final boardData = boardItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: boardData.id,
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.message),
                  title: Text(boardData['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
