import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  late ChartSeriesController _chartSeriesController;
  late ChartSeriesController _chartSeriesControllerr;
  late ZoomPanBehavior _zoomPanBehavior;
  //late SfCartesianChart chart;

  @override
  void initState() {
    _chartData = getChartData();
    _hiData = getHiData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 1,
        selectionRectColor: Colors.grey,
        enableDoubleTapZooming: true,
        enablePinching: true,
        enablePanning: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis:
                NumericAxis(autoScrollingMode: AutoScrollingMode.start),
            title: ChartTitle(text: '왜 안돼'),
            series: <ChartSeries<SpecData, int>>[
              SplineSeries(
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: _chartData,
                xValueMapper: (SpecData spec, _) => spec.time,
                yValueMapper: (SpecData spec, _) => spec.num,
              ),
              SplineSeries(
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesControllerr = controller;
                },
                dataSource: _hiData,
                xValueMapper: (SpecData spec, _) => spec.time,
                yValueMapper: (SpecData spec, _) => spec.num,
              )
            ],
          ),
          TextButton(onPressed: () {}, child: Text('Save File'))
          //Container(width: 100,height: 30, color: Colors.amber, child: TextButton(child: ,))
        ],
      ),
    ));
  }

  List<SpecData> getChartData() {
    final List<SpecData> _chartData = [
      SpecData(time: 0, num: 5),
      SpecData(time: 1, num: 2),
      SpecData(time: 2, num: 7)
    ];
    return _chartData;
  }

  List<SpecData> getHiData() {
    final List<SpecData> _hiData = [
      SpecData(time: 0, num: 1),
      SpecData(time: 1, num: 7),
      SpecData(time: 2, num: 4)
    ];
    return _hiData;
  }

  int time = 3;
  void updateDataSource(Timer timer) {
    _chartData.add(SpecData(time: time++, num: math.Random().nextInt(50)));
    _chartSeriesController.updateDataSource(
      addedDataIndex: _chartData.length - 1,
    );
    _hiData.add(SpecData(time: time++, num: math.Random().nextInt(50)));
    _chartSeriesControllerr.updateDataSource(
      addedDataIndex: _chartData.length - 1,
    );
  }
}

class SpecData {
  final int time;
  final int num;
  SpecData({required this.time, required this.num});
}
