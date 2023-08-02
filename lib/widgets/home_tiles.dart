import 'package:flutter/material.dart';
import '../Utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTile extends StatelessWidget {
  final List<dynamic> pendingTransactions;
  final String tileName;
  final IconData iconTile;

  const HomeTile({
    required this.tileName,
    required this.iconTile,
    required this.pendingTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff9D9D9D), width: 0.5),
      ),
      child: Stack(
        alignment: Alignment.center, // Center the icon and title within the Stack
        children: [
          if (tileName == "Approvals")
          Align(

            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                pendingTransactions.length.toString(),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the icon and title vertically
            children: [
              Icon(
                iconTile,
                size: 30,
                color: Color(0xff00B523),
              ),
              SizedBox(height: 5), // Add some spacing between the icon and title
              Text(
                tileName,
                style: blueText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

