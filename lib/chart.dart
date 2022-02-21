import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'app_export.dart';

class Chart extends StatelessWidget {
  final List<SensorValue> _data;

  Chart(this._data);

  static double median(List a) {
    var middle = a.length ~/ 2;
    if (a.length % 2 == 1) {
      return a[middle].value;
    } else {
      return (a[middle - 1].value + a[middle].value) / 2.0;
    }
  }

  static List<SensorValue> removeNoise(List<SensorValue> a) {
    double _median = median(a);
    double highLimit = _median * 1.05;
    double lowLimit = _median * 0.95;
    List<SensorValue> b = a;
    b.removeWhere(
        (element) => element.value >= highLimit || element.value <= lowLimit);
    return b;
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart([
      charts.Series<SensorValue, DateTime>(
        id: 'Values',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (SensorValue values, _) => values.time,
        measureFn: (SensorValue values, _) => values.value,
        data: removeNoise(_data),
      )
    ],
        animate: false,
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(zeroBound: false),
          renderSpec: charts.NoneRenderSpec(),
        ),
        domainAxis: new charts.DateTimeAxisSpec(
            renderSpec: new charts.NoneRenderSpec()));
  }
}
