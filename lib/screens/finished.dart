import '../app_export.dart';

class Finished extends StatelessWidget {
  final Measurement measurement = Get.find();
  Finished({Key? key}) : super(key: key);

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
          Symptoms(),
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
  List _selectedSymptoms = [];
  final Map<String, dynamic> _symptoms = {
    "responseCode": "1",
    "responseText": "Příznaky",
    "responseBody": [
      {"category_id": "1", "category_name": "Žádné"},
      {"category_id": "2", "category_name": "Rychlý srdeční tep"},
      {"category_id": "3", "category_name": "Nepravidelný srdeční rytmus"},
      {"category_id": "4", "category_name": "Únava"},
      {"category_id": "5", "category_name": "Dušnost"},
      {"category_id": "6", "category_name": "Tlak nebo bolest na hrudi"},
      {"category_id": "ý", "category_name": "Studený pot"},
    ],
    "responseTotalResult": 6
  };
  void _onCategorySelected(bool? selected, category_id) {
    if (selected == true) {
      setState(() {
        _selectedSymptoms.add(category_id);
      });
    } else {
      setState(() {
        _selectedSymptoms.remove(category_id);
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
            itemCount: _symptoms['responseTotalResult'],
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _selectedSymptoms
                    .contains(_symptoms['responseBody'][index]['category_id']),
                onChanged: (bool? selected) {
                  _onCategorySelected(selected,
                      _symptoms['responseBody'][index]['category_id']);
                },
                title: Text(
                  _symptoms['responseBody'][index]['category_name'],
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              );
            }),
      ],
    );
  }
}
