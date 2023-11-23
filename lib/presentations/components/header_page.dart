import 'package:flutter/material.dart';

class WaveClip extends StatelessWidget {
  const WaveClip({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Stack(
      children: <Widget>[
        //stack overlaps widgets
        Opacity(
          //semi red clippath with more height and with 0.5 opacity
          opacity: 0.5,
          child: ClipPath(
            clipper: WaveClipper(), //set our custom wave clipper
            child: Container(
              //color: Colors.lightBlue,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF76FF03),
                    Color(0xFFC5E1A5),
                  ],
                ),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/virus.png"),
                // ),
              ),
              height: 150,
            ),
          ),
        ),

        ClipPath(
          //upper clippath with less height
          clipper: WaveClipper(), //set our custom wave clipper.
          child: Container(
              padding: const EdgeInsets.only(bottom: 50),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF7CB342),
                  ],
                ),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/virus.png"),
                // ),
              ),
              //color: Colors.yellow,
              height: 130,
              alignment: Alignment.center,
              child: const Text(
                "",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              )),
        ),
      ],
    ));
  }
}

//Costom CLipper class with Path
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
