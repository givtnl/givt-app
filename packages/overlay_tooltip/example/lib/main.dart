import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

import 'custom_tooltip.dart';

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
      home: const MySamplePage(),
    );
  }
}

class MySamplePage extends StatefulWidget {
  const MySamplePage({Key? key}) : super(key: key);

  @override
  _MySamplePageState createState() => _MySamplePageState();
}

class _MySamplePageState extends State<MySamplePage> {
  final TooltipController _controller = TooltipController();
  bool done = false;

  @override
  void initState() {
    _controller.onDone(() {
      setState(() {
        done = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipScaffold(
      // overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: _controller,
      startWhen: (initializedWidgetLength) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return initializedWidgetLength == 3 && !done;
      },
      preferredOverlay: GestureDetector(
        onTap: () {
          _controller.dismiss();
          //move the overlay forward or backwards, or dismiss the overlay
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blue.withOpacity(.2),
        ),
      ),
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            OverlayTooltipItem(
              displayIndex: 1,
              tooltip: (controller) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: MTooltip(title: 'Button', controller: controller),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange])),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: OverlayTooltipItem(
          displayIndex: 2,
          tooltip: (controller) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: MTooltip(title: 'Floating button', controller: controller),
          ),
          tooltipVerticalPosition: TooltipVerticalPosition.TOP,
          child: FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: () {},
            child: const Icon(Icons.message),
          ),
        ),
        body: ListView(
          children: [
            ...[
              _sampleWidget(),
              OverlayTooltipItem(
                  displayIndex: 0,
                  tooltip: (controller) => Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: MTooltip(
                            title: 'Text Tile', controller: controller),
                      ),
                  child: _sampleWidget()),
              _sampleWidget(),
            ],
            TextButton(
                onPressed: () {
                  setState(() {
                    done = false;
                  });
                },
                child: const Text('reset Tooltip')),
            TextButton(
                onPressed: () {
                  //_controller.start();
                  OverlayTooltipScaffold.of(context)?.controller.start();
                },
                child: const Text('Start Tooltip manually')),
            TextButton(
                onPressed: () {
                  //_controller.start(1);
                  OverlayTooltipScaffold.of(context)?.controller.start(1);
                },
                child: const Text('Start at second item')),
          ],
        ),
      ),
    );
  }

  Widget _sampleWidget() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(.5),
            ),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lorem Ipsum is simply dummy text of the printing and'
                'industry. Lorem Ipsum has been the industry\'s'
                'standard dummy text ever since the 1500s'),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.bookmark_border),
                Icon(Icons.delete_outline_sharp)
              ],
            )
          ],
        ),
      );
}
