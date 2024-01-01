import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AddMemeberSuccessPage extends StatelessWidget {
  const AddMemeberSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Congratulations\n',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              children: [
                TextSpan(
                  text: 'Download ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: 'Givt4Kids ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: 'so your children can\nexperience the joy of giving!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/images/vpc_success.svg',
            width: size.width * 0.8,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    //TODO Redirect to playstore
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/images/givt4kids_logo.svg',
                        height: 32,
                      ),
                      Text(
                        'Download Givt4Kids',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      SizedBox(width: 32),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pushReplacementNamed(Pages.childrenOverview.name);
                },
                child: Text('I will do this later',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
