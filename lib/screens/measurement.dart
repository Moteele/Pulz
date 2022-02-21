import 'dart:async';
import '../app_export.dart';
import 'dart:developer' as dev;

class MeasurementPage extends StatefulWidget {
  MeasurementPage({Key? key}) : super(key: key);

  @override
  _MeasurementPageState createState() => _MeasurementPageState();
  static void handleTimeout() {
    return;
  }
}

class _MeasurementPageState extends State<MeasurementPage>
    with TickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  List<SensorValue> _data = <SensorValue>[];
  List<SensorValue> _dataX = <SensorValue>[]; // array to store the values
  late DateTime _measureTime;
  late CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  late AnimationController _animationController;
  double _completedness = 0;
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 1; // window length to display - 6 seconds
  late CameraImage _image; // store the last camera image
  double _avg = 0; // store the average value during calculation
  int _actValue = 0; // store the actual value during calculation
  late DateTime _now; // store the now Datetime
  late Timer _timer;
  Measurement currentMeasurement = Measurement();
  // timer for image processing

  @override
  void initState() {
    super.initState();
    Get.put(currentMeasurement);
    currentMeasurement.time = DateTime.now();

    _clearData();
    _initController().then((value) {
      Wakelock.enable();
      setState(() {
        _toggled = true;
      });
      _initTimer();
      _updateBPM();
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addListener(() {
        setState(() {
          _completedness = _animationController.value;
        });
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    Wakelock.disable();
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              height: 200,
              width: 200,
              child: _toggled ? CameraPreview(_controller) : Container()),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text("$_bpm"),
              Container(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                    value: _completedness,
                    strokeWidth: 30.0,
                    color: Colors.greenAccent),
              ),
            ],
          ),
          Clock(),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("Začít znovu"),
          )
        ],
      ),
    ));
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++) {
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
    }
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller.setFlashMode(FlashMode.torch);
      });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint("$Exception");
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image);
      } else {
        timer.cancel();
      }
    });
  }

  _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
          currentMeasurement.bpm = this._bpm;
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    _actValue =
        image.planes.first.bytes.reduce((value, element) => value + element);
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, 255 - _avg));
      currentMeasurement.data.add(SensorValue(_now, 255 - _avg));

      // dev.log(_actValue.toString());
    });
  }
}

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  static const _limit = Duration(seconds: 20);
  Duration seconds = Duration();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => {
              setState(() {
                if (seconds == _limit) {
                  timer?.cancel();
                  Get.changeTheme(seedTheme);
                  Get.toNamed("/finished");
                } else {
                  seconds += const Duration(seconds: 1);
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Zaznamenáváme puls\nZbývá ${(_limit - seconds).inSeconds} s",
      textAlign: TextAlign.center,
    );
  }

  void addTime() {
    setState(() {
      if (seconds == _limit) {
        Get.changeTheme(darkTheme);

        Get.toNamed("/finished");
      } else {
        seconds += const Duration(seconds: 1);
      }
    });
  }
}
