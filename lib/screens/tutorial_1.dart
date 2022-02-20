import 'dart:async';

import '../app_export.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({Key? key}) : super(key: key);

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
  bool handPositionZero = true;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        handPositionZero = !handPositionZero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(children: [
            SvgPicture.asset('assets/phone.svg'),
            AnimatedSlide(
              child: SvgPicture.asset('assets/hand.svg'),
              offset: handPositionZero ? Offset(0, 0) : Offset(0, -0.3),
              duration: Duration(seconds: 1),
              onEnd: () => {
                setState(() {
                  //handPositionZero = true;
                })
              },
            ),
          ]),
          Text(
            "Přiložte prst na zadní kameru tak, aby zakrýval fotoaparát i světelnou diodu. Až budete mít prst na správném místě, stiskněte tlačítko “Začít měřit”",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          CommonButton(name: 'Začít měřit', page: '/measurement'),
        ],
      ),
    ));
  }
}
