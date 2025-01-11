import 'package:flutter/material.dart';

class PromptDialogBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String buttonText;
  final Function onPressed;

  const PromptDialogBox({
    required this.icon,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 75,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onPressed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}