import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var counter = useState(0);
    final counter2 = useState(0);
    var counter3 = useState(0);
    useEffect(() {
      counter.value = counter2.value;
    }, [counter3.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // NotUseHooksSample(),
            UseHooksSample(),
            Text(("カウンター↓")),
            Text(
              counter.value.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(counter2.value.toString()),
            ElevatedButton(
                onPressed: () {
                  counter3.value++;
                },
                child: const Text("統一ボタン"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
          counter2.value = counter.value * 2;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NotUseHooksSample extends HookWidget {
  Map? jsonMap;

  // Base API request to get response
  static const _authority = "returnyoutubedislikeapi.com";
  static const _path = "/votes";
  static const Map<String, String> _headers = {
    "Accept": "text/html",
    "Pragma": "no-cache",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
  };

  Future getDislikeInfo() async {
    var _query = {
      "videoId": "y9KxdY0J5y0"
      // "url": data!.text!
    };
    Uri uri = Uri.https(_authority, _path, _query);
    print(uri);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == HttpStatus.ok) {
      // If server returns an OK response, parse the JSON.
      jsonMap = jsonDecode(response.body);
      print(jsonMap!["id"]);
      return jsonMap;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDislikeInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data["likes"]);
          final likes = snapshot.data["likes"];
          final dislikes = snapshot.data["dislikes"];
          final rating = double.parse(jsonMap!["rating"].toStringAsFixed(2));
          return Column(
            children: [
              const Text("ユーチューブの評価"),
              Text('$likes'),
              Text('$dislikes'),
              Text('$rating'),
            ],
          );
        } else {
          return const Text("nasu");
        }
      },
    );
  }
}

class UseHooksSample extends HookWidget {
  Map? jsonMap;

  // Base API request to get response
  static const _authority = "returnyoutubedislikeapi.com";
  static const _path = "/votes";
  static const Map<String, String> _headers = {
    "Accept": "text/html",
    "Pragma": "no-cache",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
  };

  UseHooksSample({super.key});

  Future getDislikeInfo() async {
    var _query = {
      "videoId": "y9KxdY0J5y0"
      // "url": data!.text!
    };
    Uri uri = Uri.https(_authority, _path, _query);
    print(uri);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == HttpStatus.ok) {
      // If server returns an OK response, parse the JSON.
      jsonMap = jsonDecode(response.body);
      print(jsonMap!["id"]);
      return jsonMap;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dislikeInfo = useMemoized(getDislikeInfo);
    final snapshot = useFuture(dislikeInfo);

    if (snapshot.hasData) {
      // print(snapshot.data["likes"]);
      final likes = snapshot.data!["likes"];
      final dislikes = snapshot.data!["dislikes"];
      final rating = double.parse(snapshot.data!["rating"].toStringAsFixed(2));
      return Column(
        children: [
          const Text("ユーチューブの評価"),
          Text('$likes'),
          Text('$dislikes'),
          Text('$rating'),
        ],
      );
    } else {
      return const Text("nasu");
    }
  }
}

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends HookWidget {
//   const MyHomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final counter = useState(0);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Demo Home Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               counter.value.toString(),
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           counter.value++;
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
