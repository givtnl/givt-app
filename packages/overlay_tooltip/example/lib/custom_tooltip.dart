import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class MTooltip extends StatelessWidget {
  final TooltipController controller;
  final String title;

  const MTooltip({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentDisplayIndex = controller.nextPlayIndex + 1;
    final totalLength = controller.playWidgetLength;
    final hasNextItem = currentDisplayIndex < totalLength;
    final hasPreviousItem = currentDisplayIndex != 1;
    final canPause = currentDisplayIndex < totalLength;

    return Container(
      width: size.width * .7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                WidgetSpan(
                  child: Opacity(
                    opacity: totalLength == 1 ? 0 : 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '$currentDisplayIndex OF $totalLength',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                )
              ])),
              InkWell(
                onTap: () {
                  controller.dismiss();
                },
                child: Icon(Icons.cancel_outlined,
                    color: Colors.black.withOpacity(.6), size: 18),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[100],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity: hasPreviousItem ? 1 : 0,
                child: TextButton(
                  onPressed: () {
                    controller.previous();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Prev',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: canPause ? 1 : 0,
                child: TextButton(
                  onPressed: () {
                    controller.pause();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Pause',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.next();
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    hasNextItem ? 'Next' : 'Got It',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
