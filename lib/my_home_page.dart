import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<Color> colors = const [
  Colors.purple,
  Colors.indigo,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.red,
  Colors.black,
  Colors.brown,
  Colors.greenAccent,
  Colors.grey,
  Colors.redAccent
];

int iconIndex = 0;

final colorStateProvider = StateProvider((ref) => colors[0]); // 2
final sizeStateProvider = StateProvider((ref) => 100.0);
final iconSelectProvider = StateProvider((ref) => Icons.headset);

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconColor = ref.watch(colorStateProvider); // 3
    final _sliderValue = ref.watch(sizeStateProvider); // 3
    final iconSelect = ref.watch(iconSelectProvider); // 3

    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod Hive Example'),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box('iconBox').listenable(),     // iii
        builder: (context, box, widget) {
          return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconSelector(box.get('iconIndex') ?? 0) ?? iconSelect,   // v
              color: colors[box.get('color') ?? 0] ?? iconColor,
              size:  box.get('slider') ?? _sliderValue,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              // margin: EdgeInsets.only(left: 400, right: 400), 
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    // GestureDetector is also do same as InkWell
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: colors[index]),
                    ),
                    onTap: () {
                      box.put('color', index);                       // iv
                      ref.read(colorStateProvider.state).state =
                          colors[index];    // 4
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Slider(
              activeColor: Colors.indigoAccent,
              value: box.get('slider') ?? _sliderValue,
              min: 100.0,
              max: 200.0,
              divisions: 100,
              label: _sliderValue.toString(),
              onChanged: (newRating) {
                box.put('slider', newRating);                       // iv
                ref.read(sizeStateProvider.state).state = newRating; // 4
              },
            ),
            
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.headset, color: Colors.black,),
                      onPressed: () {
                        iconIndex = 0;
                        box.put('iconIndex', iconIndex);                                     // iv
                        ref.read(iconSelectProvider.state).state = iconSelector(iconIndex);  // 4
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                       child: Icon(Icons.favorite, color: Colors.black,),
                      onPressed: () {
                        iconIndex = 1;
                        box.put('iconIndex', iconIndex);                                     // iv
                        ref.read(iconSelectProvider.state).state = iconSelector(iconIndex);  // 4
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                       child: Icon(Icons.call, color: Colors.black,),
                      onPressed: () {
                        iconIndex = 2;
                        box.put('iconIndex', iconIndex);                                     // iv
                        ref.read(iconSelectProvider.state).state = iconSelector(iconIndex);  // 4
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                       child: Icon(Icons.cake, color: Colors.black,),
                      onPressed: () {
                        iconIndex = 3;
                       box.put('iconIndex', iconIndex);                                       // iv
                        ref.read(iconSelectProvider.state).state = iconSelector(iconIndex);  // 4
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                       child: Icon(Icons.fort, color: Colors.black,),
                      onPressed: () {
                        iconIndex = 4;
                        box.put('iconIndex', iconIndex);                                     // iv
                        ref.read(iconSelectProvider.state).state = iconSelector(iconIndex);  // 4
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

        },
      ),
    );
  }
  
  IconData iconSelector(int i) {
    switch(i){
      case 0: return Icons.headset;
      break;
      case 1: return Icons.favorite;
      break;
      case 2: return Icons.call;
      break;
      case 3: return Icons.cake;
      break;
      case 4: return Icons.fort;
      break;
      default: return Icons.headset;
    }
  }
}