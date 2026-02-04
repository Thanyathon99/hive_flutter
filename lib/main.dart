import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/hive_note_provider.dart';
import 'screens/hive_notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HiveNotesProvider()..initialize(),
      child: MaterialApp(
        title: 'Hive Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.dark,
          ),
        ),
        home: const HiveNotesScreen(),
      ),
    );
  }
}
