// import 'dart:io';

// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   //초기화 전에 변수 만들어주기
//   static final _dbName = 'myDatabase.db';
//   static final _dbVersion = 1;
//   static final _tableName = 'myTable';
//   //table에 들어갈 column 설정
//   static final columnName = 'name';
//   static final columnId = '_id';

//   //싱글톤 패턴으로 만들어 인스턴스 1개만 생성, lifecycle 1개
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   //initailized Database, add a function, 초기화 전에 변수 생성
//   static Database? _database;

//   //처음엔 다 null이니까
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     } else {
//       _database = await _initiateDatabase();
//     }
//     return _database!;
//   }

//   //database가 null일때
//   _initiateDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     //파일 이름(_dbName)이랑 directory를 join 해주는거
//     String path = join(directory.path, _dbName);
//     //open, 어떤 버전을 사용하는건지 쫓아가려고 계속 써줌(우린 어차피 버전 1개)
//     ////onCreate: database가 생성되면 뭘 할지, 보통 테이블을 넣지, onCreate는 Database랑 int return함
//     return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
//   }

//   Future _onCreate(Database db, int version) {
//     //query 생성, table 이름, row, colum 설정해주는 것
//     db.execute(''' 
//       CREATE TABLE $_tableName($columnId INTEGER PRIMARY KEY,
//       $columnName TEXT NOT NULL)
//       ''');
//       return _onCreate(db, version);
//   }

//   //query table 에 내가 추가할 것 Map type으로
//   //{"_id":12, "name":"Saheb"} 이런 형태로 Map이니까
//   Future<int> insert(Map<String, dynamic> row) async {
//     //instance에서 database를 가져올 때까지 기다려라
//     Database db = await instance.database;
//     return await db.insert(_tableName, row);
//   }

//   //list type의 Map type의 string, dynamic type을 return
//   Future<List<Map<String, dynamic>>> queryAll() async {
//     Database db = await instance.database;
//     return await db.query(_tableName);
//   }

//   //어떤 id를 업데이트 할지 알아야하니까 Map, row에 전달
//   //update하면 row가 바뀌니까 where 사용 columnId에 Id parsing, name은 바꿀필요 없자나
//   //where에 지정할 조건 값들이 많을 때 조건 값을 물음표로 대체, ?에 들어갈 값은 whereArgs: []에 지정
//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row[columnId];
//     return await db
//         .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
//   }

//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
//   }
// }
