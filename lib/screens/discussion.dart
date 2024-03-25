import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController commentController = TextEditingController();

  List<Map<String, dynamic>> comments = [
    {
      'name': 'Gautam',
      'profileImage': 'images/cricket.jpg', // Store image path as a string
      'comment': 'Talk about adrenaline rush! kabaddi players on fire',
      'dateTime': '26th feb 2024',
    },
    {
      'name': 'Aiden',
      'profileImage': 'images/l2.jpg', // Store image path as a string
      'comment': 'Kabaddi action at its finest',
      'dateTime': '26th feb 2024',
    },
    {
      'name': 'Julien Martin',
      'profileImage': 'images/l3.jpg', // Store image path as a string
      'comment': 'Fantastic match.',
      'dateTime': '26th feb 2024',
    },
    {
      'name': 'Naga',
      'profileImage': 'images/tt.jpg', // Store image path as a string
      'comment': 'super match and very entertaining.',
      'dateTime': '26th feb 2024',
    },
    {
      'name': 'anandan',
      'profileImage': 'images/l2.jpg', // Store image path as a string
      'comment': 'Best pkl season ever.',
      'dateTime': '26th feb 2024',
    },
    // Add more comments as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f2ef),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            color: Colors.black,
          )
        ],
        title: const Text(
          " Comments",
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),

        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(comments[index]['profileImage']),
                      radius: 20,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(

                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comments[index]['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(comments[index]['comment'], style: const TextStyle(fontSize: 13),),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          comments[index]['dateTime'],
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: Colors.black26.withOpacity(0.1)
              ),


              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Write a comment...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Handle sending comment
                      if (commentController.text.isNotEmpty) {
                        DateTime now = DateTime.now();
                        String formattedDate = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}';
                        setState(() {
                          comments.insert(
                            0,
                            {
                              'name': 'You',
                              'profileImage': 'https://example.com/your_profile.jpg',
                              'comment': commentController.text,
                              'dateTime': formattedDate,
                            },
                          );
                        });
                        // Clear the text field after sending the comment
                        commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}