import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_why/mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme, //버튼 만들어야 돼
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<SpecData> _chartData;
  late List<SpecData> _hiData;
  late List<SpecData> _oneData;
  late ChartSeriesController _chartSeriesController;
  late ChartSeriesController _chartSeriesControllerr;
  late ChartSeriesController _chartSeriesControllerrr;
  late ZoomPanBehavior _zoomPanBehavior;
  //late SfCartesianChart chart;

  @override
  void initState() {
    _chartData = getChartData();
    _hiData = getHiData();
    _oneData = getOneData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    _zoomPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 1,
        selectionRectColor: Colors.grey,
        enableDoubleTapZooming: true,
        enableMouseWheelZooming: true,
        enablePinching: true,
        enablePanning: true);

    super.initState();
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('WR'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
                Get.isDarkMode
                    ? Icons.toggle_off_outlined
                    : Icons.toggle_on_outlined,
                size: 40),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('config'),
              onTap: () {},
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                  onPressed: () {
                    Get.off(() => MyHomePage(title: 'WR'));
                  },
                  child: Text('Reload')),
              OutlinedButton(
                  onPressed: () {},
                  // async {
                  //   await Get.find<CountControllerWithReactive>().csvSaveInit();
                  //   Get.find<CountControllerWithReactive>().bFileSave.value =
                  //       true;
                  // },
                  child: Text('Save File')),
              OutlinedButton(onPressed: () {}, child: Text('Start')),
              OutlinedButton(onPressed: () {}, child: Text('Stop')),
            ],
          ),
          SfCartesianChart(
            legend: Legend(
                isVisible: true,
                toggleSeriesVisibility: true,
                position: LegendPosition.top),
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis:
                NumericAxis(autoScrollingMode: AutoScrollingMode.start),
            title: ChartTitle(text: '왜 안돼'),
            series: <ChartSeries<SpecData, int>>[
              SplineSeries(
                name: 'Num1',
                // trendlines: <Trendline>[
                //   Trendline(
                //       type: TrendlineType.logarithmic, color: Colors.green)
                // ],
                enableTooltip: true,
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: _chartData,
                xValueMapper: (SpecData spec, _) => spec.time,
                yValueMapper: (SpecData spec, _) => spec.num,
              ),
              SplineSeries(
                name: 'Num2',
                // trendlines: <Trendline>[
                //   Trendline(type: TrendlineType.logarithmic, color: Colors.red)
                // ],
                enableTooltip: true,
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesControllerr = controller;
                },
                dataSource: _hiData,
                xValueMapper: (SpecData spec, _) => spec.time,
                yValueMapper: (SpecData spec, _) => spec.num,
              ),
              SplineSeries(
                name: 'Num3',
                // trendlines: <Trendline>[
                //   Trendline(type: TrendlineType.logarithmic, color: Colors.red)
                // ],
                enableTooltip: true,
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesControllerrr = controller;
                },
                dataSource: _oneData,
                xValueMapper: (SpecData spec, _) => spec.time,
                yValueMapper: (SpecData spec, _) => spec.num,
              )
            ],
          ),
        ],
      ),
    ));
  }

  List<SpecData> getChartData() {
    final List<SpecData> _chartData = [
      // SpecData(time: 0, num: 5),
      // SpecData(time: 1, num: 2),
      // SpecData(time: 2, num: 7)
    ];
    return _chartData;
  }

  List<SpecData> getHiData() {
    final List<SpecData> _hiData = [
      // SpecData(time: 0, num: 1),
      // SpecData(time: 1, num: 7),
      // SpecData(time: 2, num: 4)
    ];
    return _hiData;
  }

  List<SpecData> getOneData() {
    final List<SpecData> _oneData = [
      // SpecData(time: 0, num: 1),
      // SpecData(time: 1, num: 7),
      // SpecData(time: 2, num: 4)
    ];
    return _oneData;
  }

  int time = 0;
  int timee = 0;
  int timeee = 0;
  void updateDataSource(Timer timer) {
    _chartData.add(SpecData(time: time++, num: math.Random().nextInt(50)));
    //_chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
      addedDataIndex: _chartData.length - 1,
      //removedDataIndex: 0,
    );
    _hiData.add(SpecData(time: timee++, num: math.Random().nextInt(50)));
    //_chartData.removeAt(0);
    _chartSeriesControllerr.updateDataSource(
      addedDataIndex: _hiData.length - 1,
      //removedDataIndex: 0,
    );
    _oneData.add(SpecData(time: timeee++, num: math.Random().nextInt(50)));
    _chartSeriesControllerrr.updateDataSource(
        addedDataIndex: _oneData.length - 1);
  }
}

class SpecData {
  final int time;
  final int num;
  SpecData({required this.time, required this.num});
}

// //getHiData, getChartData를 받아서 저장해야 하니까,,,,
// class CountControllerWithReactive extends GetxController {
//   static CountControllerWithReactive get to => Get.find();
//   RxString filePath = ''.obs;
//   RxBool bFileSave = false.obs;

//   Future<File> csvSave() async {
//     DateTime current = DateTime.now();
//     final String fileNameDate =
//         '${DateFormat('yyyy-MM-dd HH:mm:ss').format(current)}';
//     print('fileNameDate $fileNameDate');
//     List<dynamic> getHiData = [];
//     List<List<dynamic>> addGetHiData = [];
//     //var filePath;
//     File file = File(filePath.value);
//     getHiData.add(fileNameDate);
//     addGetHiData.add(getHiData);
//     String csv = const ListToCsvConverter().convert(addGetHiData) + '\n';
//     return file.writeAsString(csv, mode: FileMode.append);
//   }

//   Future<File> csvSaveInit() async {
//     DateTime current = DateTime.now();
//     final String fileNameDate =
//         '${DateFormat('yyyy-MM-dd HH:mm:ss').format(current)}';
//     await Directory('datafiles').create();
//     filePath.value = "./datafiles/$fileNameDate.csv";
//     File file = File(filePath.value);

//     String firstRow = "Test";
//     String secondRow = "Hello";
//     String helloTest = firstRow + secondRow;

//     return file.writeAsString(helloTest);
//   }
// }

// class GenerateCSV {
//   static generateCsv(List<List<String>> data, String fileName) async {
//     String csvData = ListToCsvConverter().convert(data);
//     Directory? _appDocDir = await getExternalStorageDirectory();
//     String newPath = "";
//     print(_appDocDir);
//     List<String> paths = _appDocDir!.path.split("/");
//     for (int x = 1; x < paths.length; x++) {
//       String folder = paths[x];
//       if (folder != "Android") {
//         newPath += "/" + folder;
//       } else {
//         break;
//       }
//     }
//     newPath = newPath + "/RPSApp";
//     _appDocDir = Directory(newPath);

//     final Directory _appDocDirFolder = Directory(
//         '${_appDocDir.path}/Covid tracker/');

//     if (await _appDocDirFolder
//         .exists()) { //if folder already exists return path
//       return _appDocDirFolder.path;
//     } else { //if folder not exists create folder and then return its path
//       final Directory _appDocDirNewFolder = await _appDocDirFolder.create(
//           recursive: true);

//       final path = "${_appDocDirNewFolder.path}/$fileName";
//       print(path);
//       final File file = File(path);
//       await file.writeAsString(csvData);
//       print("File created");
//     }
//   }
// }
