import 'dart:io';

import 'package:flutter/material.dart';

class TermsOfUseDialog extends StatelessWidget {
  const TermsOfUseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localName = Platform.localeName;
    /// todo add country
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et lectus euismod, vestibulum odio vel, bibendum diam. Fusce euismod augue in eros maximus, a accumsan enim accumsan. Morbi tristique enim in velit tincidunt consequat. Sed et sapien euismod, pharetra odio vel, pharetra urna. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec suscipit erat vel condimentum rhoncus. Morbi quis arcu vel lacus consequat suscipit eu nec felis. Nunc porttitor, erat vel dapibus aliquet, diam dui lobortis lorem, eget pulvinar diam enim eget metus. Donec laoreet sagittis porta. Duis convallis, risus vel vestibulum interdum, augue urna bibendum massa, vel ultrices lectus sapien sit amet massa. Nullam vitae nisl vel ante semper lacinia. Fusce euismod, risus sit amet vestibulum ultrices, orci tellus lacinia lacus, vel pellentesque velit sapien quis velit. Maecenas commodo sapien quis enim dignissim, id mattis metus lacinia. Nam aliquam in massa nec tincidunt. Mauris eget varius est, eget iaculis mi.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
