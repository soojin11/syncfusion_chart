// import 'dart:io';

// import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';

// String csv = const ListToCsvConverter().convert(yourListOfLists);

// final directory = await getApplicationDocumentsDirectory();
// final pathOfTheFileToWrite = directory.path + "/myCsvFile.csv";
// File file = await File(pathOfTheFileToWrite);
// file.writeAsString(csv);

// import 'package:flutter/material.dart';

// class SaveFile extends StatefulWidget {
//   const SaveFile({Key? key}) : super(key: key);

//   @override
//   _SaveFileState createState() => _SaveFileState();
// }

// class _SaveFileState extends State<SaveFile> {
//   List<List<dynamic>>? numData;

//   @override
//   void initState() {
//     for (int i = 0; i < 5; i++){
      
//     } super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


import 'package:csv/csv.dart';

/// Convert a map list to csv
String? mapListToCsv(List<Map<String, Object?>>? mapList,
    {ListToCsvConverter? converter}) {
  if (mapList == null) {
    return null;
  }
  converter ??= const ListToCsvConverter();
  var data = <List>[];
  var keys = <String>[];
  var keyIndexMap = <String, int>{};

  // Add the key and fix previous records
  int _addKey(String key) {
    var index = keys.length;
    keyIndexMap[key] = index;
    keys.add(key);
    for (var dataRow in data) {
      dataRow.add(null);
    }
    return index;
  }

  for (var map in mapList) {
    // This list might grow if a new key is found
    var dataRow = List<Object?>.filled(keyIndexMap.length, null);
    // Fix missing key
    map.forEach((key, value) {
      var keyIndex = keyIndexMap[key];
      if (keyIndex == null) {
        // New key is found
        // Add it and fix previous data
        keyIndex = _addKey(key);
        // grow our list
        dataRow = List.from(dataRow, growable: true)..add(value);
      } else {
        dataRow[keyIndex] = value;
      }
    });
    data.add(dataRow);
  }
  return converter.convert(<List>[keys, ...data]);
}