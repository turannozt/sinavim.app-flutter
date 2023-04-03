// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sinavim_app/Resources/auth_methods.dart';
import 'package:sinavim_app/Screens/login_screen.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Widgets/text_field_input.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _resetPasswordController =
      TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
    _resetPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //Sign Up
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res =
        await AuthMethods().resetPassword(_resetPasswordController.text);
    // if string returned is sucess, user has been created
    if (res == "success") {
      Fluttertoast.showToast(
        msg: "Mail Adresinize Şifre Sıfırlama Bağlantısı Gönderildi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffd94555),
        textColor: Colors.white,
        fontSize: 14,
      );

      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Alanı Boş Bırakmayınız! ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffd94555),
        textColor: Colors.white,
        fontSize: 14,
      );
      setState(() {
        _isLoading = false;
      });
      // show the error

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: SvgPicture.asset(
                  'assets/images/sinavim.svg',
                  color: const Color(0xffd94555),
                  height: 48,
                ),
              ),
              Center(
                child: Image.asset(
                  fit: BoxFit.contain,
                  'assets/images/Reset password-amico.png',
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Şifre Sıfırla',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      wordSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Şifresini Unuttuğunuz Mail Adresinizi Giriniz.',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18, color: Colors.grey, wordSpacing: 1),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              TextFieldInput(
                hintText: 'Mail Adresinizi Giriniz.',
                textInputType: TextInputType.emailAddress,
                textEditingController: _resetPasswordController,
                icondata: const Icon(CupertinoIcons.mail_solid),
              ),

              const SizedBox(height: 12),

              //Sign Up Button
              InkWell(
                onTap: signUpUser,
                child: Container(
                  height: 52,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Color(0xffd94555),
                  ),
                  child: !_isLoading
                      ? Text(
                          'Gönder',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(height: 12),

              //Açıklamalar Giriş Yap
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Şifreni mi Hatırladın ?',
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        ' Giriş Yap.',
                        style: GoogleFonts.sourceSansPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
