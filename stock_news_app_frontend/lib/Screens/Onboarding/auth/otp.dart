import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          Text("Enter the OTP sent to your Email", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          OtpTextField(
            numberOfFields: 6,
            fillColor: Color.fromARGB(97, 0, 0, 0),
            showFieldAsBox: true,
            borderColor: Colors.transparent,
            disabledBorderColor: Colors.transparent,
            focusedBorderColor: Colors.transparent,
            borderWidth: 1,
            enabledBorderColor: Colors.transparent,
            keyboardType: TextInputType.number,
            filled: true,
            onSubmit: (code){
              // print("22222222222222222222222222222222222222222222222222222222222222222222 otp is ${code}");
            },
            
          ),
          SizedBox(height: 30,),
                        ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A6A6A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white),
                ),
              ),
           
        ],
      ),
    );
  }
}