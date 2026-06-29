import 'package:flutter/cupertino.dart';
import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class HkPrimaryHeaderContainer extends StatelessWidget {
  const HkPrimaryHeaderContainer({
    super.key,
    required this.child,
    this.height = 272,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return HkCurvedEdgesWidget(
      child: Container(
        height: height,
        color: const Color(0XFF0857A0),
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            // Background Decorative Circles
            Positioned(top: -150, right: -250, child: HkCircularContainer(backgroundColor: HkColors.textWhite.withOpacity(0.1))),
            Positioned(top: 100, right: -300, child: HkCircularContainer(backgroundColor: HkColors.textWhite.withOpacity(0.1))),

            // 🔥 FIX: Positioned widget ka use karke child ko explicit sizes provide ki hain
            Positioned.fill(
              child: SizedBox(
                height: height,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
