import 'package:flutter/material.dart';
import '../Utils/utils.dart';

class HomeTile extends StatelessWidget {
  final String tileName;
  final IconData iconTile;

  const HomeTile({
    required this.tileName,
    required this.iconTile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff9D9D9D), width: 0.5),
      ),
      child: Column(
        children: [
          Expanded(
            child: Icon(
              iconTile,
              size: 30,
              color: Color(0xff00B523),
            ),
          ),
          Text(
            tileName,
            style: blueText,
          ),
        ],
      ),
    );
  }
}
