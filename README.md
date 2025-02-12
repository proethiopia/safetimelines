# skiptimeline

A Flutter package for creating beautiful and customizable timelines.

## Installation

Add `skiptimeline` to your `pubspec.yaml` file:

```yaml
dependencies:
  skiptimeline: ^0.0.1
```

Then run `flutter pub get` to install the package.

## Usage

Import the package:

```dart
import 'package:skiptimeline/skiptimeline.dart';
```

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:skiptimeline/skiptimeline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SkipTimeline Example'),
        ),
        body: SkipTimeline(
          events: [
            SkipTimelineEvent(
              title: 'Event 1',
              description: 'Description for event 1',
              date: DateTime.now(),
            ),
            SkipTimelineEvent(
              title: 'Event 2',
              description: 'Description for event 2',
              date: DateTime.now().add(Duration(days: 1)),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Customization

You can customize the appearance of the timeline by providing custom widgets for the events and the timeline itself.

```dart
SkipTimeline(
  events: [
    SkipTimelineEvent(
      title: 'Event 1',
      description: 'Description for event 1',
      date: DateTime.now(),
      customWidget: MyCustomWidget(),
    ),
    SkipTimelineEvent(
      title: 'Event 2',
      description: 'Description for event 2',
      date: DateTime.now().add(Duration(days: 1)),
      customWidget: MyCustomWidget(),
    ),
  ],
  customTimeline: MyCustomTimeline(),
);
```
````

