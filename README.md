# 📜 Observable ScrollView (Flutter)

A custom-built Observable ScrollView in Flutter that allows you to listen to scroll events, detect scroll direction, track scroll offset, and react to top / bottom reach events.

This implementation is pure Flutter, lightweight, reusable, and ideal for collapsing headers, coordinator layouts, animations, and infinite scrolling.

---

## ✨ Features

🔍 Observe scroll offset in real-time

🔼 Detect scroll direction (Up / Down / Idle)

🔝 Detect when scroll reaches top

🔽 Detect when scroll reaches bottom

🎯 Fully reusable custom widget

🧩 Works with collapsing headers & animations

🚫 No third-party dependencies

---

## ✨ Preview



https://github.com/user-attachments/assets/830dcd42-a0b9-4555-a8ce-776231a1056c






---


## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  observable_scroll_view:
    path: ../observable_scroll_view
```
from git:
```
dependencies:
  observable_scroll_view:
    git:
      url: https://github.com/yourusername/observable_scroll_view.git

```
Then Run:
```
flutter pub get
```
## 📁 Folder Structure
```
lib/
│
├── observable_scroll/
│   ├── observable_scroll_view.dart
│   └── observable_scroll_demo.dart
│
└── main.dart

  ```
## 🚀 Usage

🧩 Custom ObservableScrollView
```
import 'package:flutter/material.dart';

enum ObservableScrollDirection { up, down, idle }

class ObservableScrollView extends StatefulWidget {
  final List<Widget> children;

  final ValueChanged<double>? onOffsetChanged;
  final ValueChanged<ObservableScrollDirection>? onDirectionChanged;
  final VoidCallback? onTopReached;
  final VoidCallback? onBottomReached;

  final EdgeInsets padding;
  final ScrollPhysics physics;

  const ObservableScrollView({
    super.key,
    required this.children,
    this.onOffsetChanged,
    this.onDirectionChanged,
    this.onTopReached,
    this.onBottomReached,
    this.padding = EdgeInsets.zero,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  State<ObservableScrollView> createState() => _ObservableScrollViewState();
}

class _ObservableScrollViewState extends State<ObservableScrollView> {
  final ScrollController _controller = ScrollController();

  double _lastOffset = 0;
  ObservableScrollDirection _direction =
      ObservableScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = _controller.offset;

    widget.onOffsetChanged?.call(offset);

    if (offset > _lastOffset &&
        _direction != ObservableScrollDirection.down) {
      _direction = ObservableScrollDirection.down;
      widget.onDirectionChanged?.call(_direction);
    } else if (offset < _lastOffset &&
        _direction != ObservableScrollDirection.up) {
      _direction = ObservableScrollDirection.up;
      widget.onDirectionChanged?.call(_direction);
    }

    if (_controller.position.pixels <=
        _controller.position.minScrollExtent) {
      widget.onTopReached?.call();
    }

    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent) {
      widget.onBottomReached?.call();
    }

    _lastOffset = offset;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      padding: widget.padding,
      physics: widget.physics,
      children: widget.children,
    );
  }
}

```
🎬 Demo Screen (Collapsing Header Example)
```
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
  String directionText = "IDLE";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                debugPrint("Top reached");
              },
              onBottomReached: () {
                debugPrint("Bottom reached");
              },
              children: List.generate(
                40,
                (index) => ListTile(
                  leading: const Icon(Icons.list),
                  title: Text("Item ${index + 1}"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

```

## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
