import '../app_export.dart';

class Questions1 extends StatelessWidget {
  final Measurement measurement = Get.find();
  Questions1({Key? key}) : super(key: key);

  initState() {
    Get.changeTheme(darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Doplňující informace',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            "Díky více informacím lépe porozumíme vašim výsledkům.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const Symptoms(),
          CommonActionButton(
            name: "Uložit",
            page: "/dashboard",
          )
        ],
      ),
    );
  }
}

class Symptoms extends StatefulWidget {
  const Symptoms({Key? key}) : super(key: key);

  @override
  _SymptomsState createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  final Set<int> _selectedSymptoms = {};

  void _onCategorySelected(bool? selected, categoryId) {
    if (selected == true) {
      setState(() {
        categoryId == 1
            ? _selectedSymptoms.clear()
            : _selectedSymptoms.remove(1);
        _selectedSymptoms.add(categoryId);
      });
    } else {
      setState(() {
        _selectedSymptoms.remove(categoryId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            "Příznaky",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: Measurement.symptoms['responseTotalResult'],
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _selectedSymptoms.contains(
                    Measurement.symptoms['responseBody'][index]['category_id']),
                onChanged: (bool? selected) {
                  _onCategorySelected(
                      selected,
                      Measurement.symptoms['responseBody'][index]
                          ['category_id']);
                },
                title: Text(
                  Measurement.symptoms['responseBody'][index]['category_name'],
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              );
            }),
      ],
    );
  }
}
