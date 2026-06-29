import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HkAppBar(showBackArrow: true,),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              HkImages.paymentSuccess,
              width: 203,
              height: 161,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Payment Success!",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 9,
            ),
            Text(
              "Your item will be shipped soon!",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(318, 50),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Checkout'),
            )
          ],
        ),
      ),
    );
  }
}
