import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


Widget textcustom({text,size,isBold,}) {
  return Text(text,style: GoogleFonts.poppins(
    fontSize: size,fontWeight:isBold==true? FontWeight.w500:FontWeight.normal),);
}


Widget textcustomCenter({text,size,isBold,}) {
  return Text(text,
   textAlign: TextAlign.center,
   style: GoogleFonts.poppins(
    fontSize: size,fontWeight:isBold==true? FontWeight.w500:FontWeight.normal),);
}
Widget textcustomIcon({text,size,isBold,color,required icon}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon),const SizedBox(width: 4.0,),
      Text(text,style: GoogleFonts.poppins(fontSize: size,fontWeight:isBold==true? FontWeight.w500:FontWeight.normal),),
    ],
  );
}
Widget textcustomColor({text,size,isBold,color}) {
  return Text(text,style: GoogleFonts.poppins(
    color:  color,
    fontSize: size,fontWeight:isBold==true? FontWeight.w500:FontWeight.normal),);
}
Widget textcustomColorBold({text,size,color,lineHeight, }) {
  return Text(text,
  textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false, // Controls the height behavior
        applyHeightToLastDescent: false,
      ),
  textAlign: TextAlign.center,
  style: GoogleFonts.poppins(
    color:  color,
    height: lineHeight ?? 1,
    fontSize: size,fontWeight:FontWeight.w800),);
}



