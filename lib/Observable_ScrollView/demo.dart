import 'package:flutter/material.dart';
import 'observable_scroll_view.dart';

class ObservableScrollDemo extends StatefulWidget {
  const ObservableScrollDemo({super.key});

  @override
  State<ObservableScrollDemo> createState() =>
      _ObservableScrollDemoState();
}

class _ObservableScrollDemoState extends State<ObservableScrollDemo> {
  double headerHeight = 220;
  String directionText = "Idle";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Collapsing Header
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: headerHeight,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.deepPurple],
              ),
            ),
            child: Text(
              "Direction: $directionText",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Observable Scroll View
          Expanded(
            child: ObservableScrollView(
              onOffsetChanged: (offset) {
                setState(() {
                  headerHeight =
                      (220 - offset).clamp(120, 220);
                });
              },
              onDirectionChanged: (dir) {
                setState(() {
                  directionText = dir.name.toUpperCase();
                });
              },
              onTopReached: () {
                debugPrint("🔝 Top Reached");
              },
              onBottomReached: () {
                debugPrint("🔽 Bottom Reached");
              },
              children: List.generate(
                40,
                    (index) => ListTile(
                  title: Text("Item ${index + 1}"),
                  leading: const Icon(Icons.list),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
