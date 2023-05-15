import 'package:flutter/material.dart';

/// Widget building a custom green faded wave
class BackgroundWaveClipper extends CustomClipper<Path> {
  final double p0coeff;
  final double controlPointCoeff;
  final double endPointCoeff;

  BackgroundWaveClipper({
    required this.p0coeff,
    required this.controlPointCoeff,
    required this.endPointCoeff,
});

  @override
  Path getClip(Size size) {
    var path = Path();

    final p0 = size.height * p0coeff; //0.25 pour register, 0.75 pour login
    path.lineTo(0.0, p0);

    final controlPoint = Offset(size.width * controlPointCoeff, size.height); //0.6 pour register, 0.4 pour login
    final endPoint = Offset(size.width, size.height * endPointCoeff); //0.75 pour register, 0.5 pour login
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper  oldClipper) =>
      oldClipper != this;
}

class Wave extends StatelessWidget{
  double? positionTop;
  double? positionBottom;
  double? positionLeft;
  double? positionRight;
  double? positionTopText;
  double? positionRightText;
  double? positionLeftText;
  final String label;
  final double height;
  final double p0coeff;
  final double controlPointCoeff;
  final double endPointCoeff;

  Wave(this.p0coeff, this.controlPointCoeff, this.endPointCoeff,{
    super.key,
    this.positionTop,
    this.positionBottom,
    this.positionLeft,
    this.positionRight,
    this.positionTopText,
    this.positionRightText,
    this.positionLeftText,
    required this.height,
    required this.label
  });

  @override
  Widget build( context) {
    return Positioned(
      top: positionTop, //0 register/login
      bottom: positionBottom,//null register/login
      left: positionLeft,//0 register/login
      right: positionRight,//0 register/login
      child: ClipPath(
        clipper: BackgroundWaveClipper(p0coeff: p0coeff, controlPointCoeff: controlPointCoeff,endPointCoeff: endPointCoeff),
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: height, //150 register/ 200 login
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF166C38), Color(0xFFA4D875)],
                    ))),
            Positioned(
                top: positionTopText, //40 register/70 login
                left: positionLeftText, //null register/30 login
                right: positionRightText, //30 register/null login
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white)))
          ],
        ),
      ),
    );
  }

}

