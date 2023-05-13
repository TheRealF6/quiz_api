import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

class JenisPinjaman {
String id;
String nama;
JenisPinjaman({required this.id, required this.nama});
}

class DetilJenisPinjaman {
String id;
String detail;

DetilJenisPinjaman({required this.id, required this.detail});
}

class MyApp extends StatefulWidget {
@override
_MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
final List<JenisPinjaman> jenisPinjaman = [
JenisPinjaman(id: "0", nama: 'Pilih jenis pinjaman'),
JenisPinjaman(id: "1", nama: 'Pilihan 1'),
JenisPinjaman(id: "2", nama: 'Pilihan 2'),
JenisPinjaman(id: "3", nama: 'Pilihan 3'),
];

List<DetilJenisPinjaman> detilJenisPinjaman = [];

String selectedJenisPinjaman = '0';

Future<List<DetilJenisPinjaman>> fetchDetilJenisPinjaman(String id) async {
String url = 'http://127.0.0.1:8000/detil_jenis_pinjaman/$id';
final response = await http.get(Uri.parse(url));
if (response.statusCode == 200) {
  List<dynamic> data = jsonDecode(response.body);
  return data.map((item) => DetilJenisPinjaman(id: item['id'], detail: item['detail'])).toList();
} else {
  throw Exception('Failed to load detil jenis pinjaman');
}
}

void fetchJenisPinjaman(String id) async {
String url = 'http://178.128.17.76:8000/jenis_pinjaman/$id';
final response = await http.get(Uri.parse(url));
if (response.statusCode == 200) {
  List<dynamic> data = jsonDecode(response.body);
  setState(() {
    detilJenisPinjaman = data.map((item) => DetilJenisPinjaman(id: item['id'], detail: item['detail'])).toList();
  });
} else {
  throw Exception('Failed to load jenis pinjaman');
}
}

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'My App P2P',
home: Scaffold(
appBar: AppBar(
title: const Text('My App P2P'),
),
body: Column(
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: Text(
'2105997, Muhammad Fakhri Fadhlurrahman; 2103703, Fauziyyah Zayyan Nur, Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang',
style: TextStyle(fontSize: 16),
),
),
const SizedBox(height: 16.0),
DropdownButton<String>(
value: selectedJenisPinjaman,
onChanged: (String? newValue) {
setState(() {
selectedJenisPinjaman = newValue!;
});
if (newValue != null) {
fetchJenisPinjaman(newValue);
}
},
items: jenisPinjaman.map((JenisPinjaman jenis) {
return DropdownMenuItem<String>(
value: jenis.id,
child: Text(
jenis.nama,
style: TextStyle(
color: jenis.id == "0" ? Colors.grey : Colors.black,
),
),
);
}).toList(),
),
Expanded(
child: ListView.builder(
itemCount: detilJenisPinjaman.length,
itemBuilder: (context, index) {
return GestureDetector(
onTap: () {
fetchDetilJenisPinjaman(detilJenisPinjaman[index].id);
},
child: Container(
decoration: BoxDecoration(border: Border.all()),
padding: const EdgeInsets.all(14),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
detilJenisPinjaman[index].id,
),
Text(
detilJenisPinjaman[index].detail,
),
],
),
),
);
},
),
),
],
),
),
);
}
}

void main() {
runApp(MyApp());
}