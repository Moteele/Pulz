import 'package:pulz/app_export.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: 'Změřte si ',
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                            text: 'puls',
                            style: TextStyle(color: Color(0xff0fccab))),
                        TextSpan(text: '\nkdekoliv a kdykoliv!')
                      ]),
                ),
                const Icon(Icons.favorite, size: 100, color: Color(0xff0fccab)),
                CommonButton(name: 'Začít', page: '/tutorial_1'),
              ]),
        ),
      ),
    );
  }
}
