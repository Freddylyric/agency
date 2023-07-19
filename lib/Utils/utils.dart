
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// const mainHeading = TextStyle(
//     fontFamily: 'Poppins',
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//     height: 24 / 16,
//     letterSpacing: 1,
//     color: Color(0xff302D2C),
// );

final mainHeading = GoogleFonts.inter(
  fontSize: 21,
  fontWeight: FontWeight.w700,
  height: 25 / 16,
  letterSpacing: 1,
  color: Color(0xffFFFFFF),
);

final subHeading = GoogleFonts.inter(

  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 18 / 12,
  letterSpacing: 1,
  color: Color(0xffffffff),

);
final bodyTextWhite = GoogleFonts.inter(
  fontSize: 11,
  fontWeight: FontWeight.w400,
  height: 13 / 12,
  letterSpacing: 1,
  color: Color(0xffFFFFFF),
);

final bodyTextBlack = GoogleFonts.inter(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 15 / 12,
  letterSpacing: 1,
  color: Color(0xff9D9D9D),
);

final bodyTextBlackBigger = GoogleFonts.inter(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  height: 15 / 12,
  letterSpacing: 1,
  color: Color(0xff333333),
);

final blueText = GoogleFonts.inter(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 18 / 12,
  letterSpacing: 1,
  color: Color(0xff1075FF),
);

final whiteText = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 18 / 12,
  letterSpacing: 1,
  color: Colors.white,
);








const String appLogo = "assets/images/drLogo.png";
const String password = "assets/images/password.png";

class ButtonStyleConstants {

  static const double buttonHeight = 50.0;
  static const double buttonWidth = double.infinity;
  static const double smallButtonHeight = 38.0;
  static const double smallButtonWidth = 100.0;
  static const double borderRadius = 8.0;
  static const EdgeInsetsGeometry buttonPadding =
  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0);
  static const Color primaryColor = Color(0xff00C307);
  static const Color secondaryColor = Color(0xffE9EBF0);
  static const Color blueColor = Color(0xff1075FF);

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    minimumSize: const Size(buttonWidth, buttonHeight),
  );

  static final ButtonStyle blackButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    minimumSize: const Size(buttonWidth, buttonHeight),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    minimumSize: const Size(buttonWidth, buttonHeight),
  );
  static final ButtonStyle smallButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: blueColor,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),

    minimumSize: const Size(smallButtonWidth, smallButtonHeight),

  );
}

// class TextFormFieldTheme {
//   TextFormFieldTheme._();
//
//   static InputDecorationTheme
//
// }

