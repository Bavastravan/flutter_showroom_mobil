import 'package:flutter/material.dart'; 
void main() { 
runApp(const HelloFlutterApp()); 
} 
class HelloFlutterApp extends StatelessWidget { 
const HelloFlutterApp({super.key}); 
@override 
Widget build(BuildContext context) { 
return MaterialApp( 
title: 'Hello Flutter App', 
theme: ThemeData( 
primarySwatch: Colors.blue, 
useMaterial3: true, 
), 
home: const HomePage(), 
debugShowCheckedModeBanner: false, 
); 
} 
} 
class HomePage extends StatefulWidget { 
const HomePage({super.key}); 
@override 
State<HomePage> createState() => _HomePageState(); 
} 
 
class _HomePageState extends State<HomePage> { 
  int counter = 0; 
 
  void incrementCounter() { 
    setState(() { 
      counter++; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Demo Flutter App'), 
        centerTitle: true, 
      ), 
      body: Center( 
        child: Padding( 
          padding: const EdgeInsets.all(16.0), 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              const Text( 
                'Selamat datang di Hello Flutter!', 
                style: TextStyle( 
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                ), 
                textAlign: TextAlign.center, 
              ), 
              const SizedBox(height: 20), 
              const Text( 
                'Tekan tombol di bawah untuk menambah angka:', 
                style: TextStyle(fontSize: 16), 
                textAlign: TextAlign.center, 
              ), 
              const SizedBox(height: 30), 
              Text( 
                '$counter', 
                style: const TextStyle( 
                  fontSize: 50, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blue, 
                ), 
              ), 
              const SizedBox(height: 30), 
              ElevatedButton.icon( 
                onPressed: incrementCounter, 
                icon: const Icon(Icons.add), 
                label: const Text('Tambah Angka'), 
                style: ElevatedButton.styleFrom( 
                  padding: const EdgeInsets.symmetric(horizontal: 24, 
vertical: 12), 
                  textStyle: const TextStyle(fontSize: 18), 
                ), 
              ), 
], 
), 
), 
), 
); 
} 
}