import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> _get = [];
  var apiKey = 'c33b2540031e4f5bb77414f5414b142a';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.spoonacular.com/recipes/random?apiKey=$apiKey&number=10"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data['recipes'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage(String url) {
    try {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 100,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } catch (e) {
      print(e);
      return const Icon(Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 42, 148, 210),
          title: const Text(
            "Trending Recipes",
            style: TextStyle(
              color: Color.fromARGB(96, 12, 107, 9),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: _get.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                leading: _buildImage(_get[index]['image']),
                title: Text(
                  _get[index]['title'] ?? "No Title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _get[index]['summary'] ?? "No Description",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
