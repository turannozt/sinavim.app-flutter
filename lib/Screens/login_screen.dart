// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sinavim_app/Resources/auth_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/reset_password_screen.dart';
import 'package:sinavim_app/Screens/signup_screen.dart';
import 'package:sinavim_app/Screens/verify_email_screen.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Widgets/sss.dart';
import 'package:sinavim_app/Widgets/text_field_input.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

//Login User
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
        token: await token());
    if (res == 'success') {
      Fluttertoast.showToast(
        msg: "Başarılı Bir Şekilde Giriş Yaptınız",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffd94555),
        textColor: Colors.white,
        fontSize: 14,
      );
      pushNotificationsSpecificDevice(
        token: await token(),
        title: 'Sınavım Destek Ekibi',
        body:
            "Başarılı Bir Şekilde Giriş Yaptınız. Unutma ! Hedefin Başarıysa SINAVIM Yanında :) ",
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const VerifyEmailPage(),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: "E Mail Veya Şifre Hatalı",
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
    }
  }

  Future<bool> pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  goster() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Bilgilendirme !',
          style: GoogleFonts.sourceSansPro(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Dilerseniz Misafir Hesabı İle Uygulamaya Giriş Yapıp İnceleyebilirsiniz. Kayıt Olmak İçin "Kayıt Ol" Butonuna Tıklayınız!',
          style: GoogleFonts.sourceSansPro(fontSize: 16),
        ),
      ),
    );
    _passwordController.text = "misafir123";
    _emailController.text = "misafir.kullanici384@gmail.com";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.warning),
                          onPressed: goster,
                          label: Text(
                            'Bilgilendirme',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Sıkça Sorulan Sorular',
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        IconButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SSS(),
                                  ),
                                ),
                            icon: const Icon(Icons.info))
                      ],
                    ),
                    //Flexible(flex: 1, child: Container()),
                    const SizedBox(height: 15),
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
                        'assets/images/Thesis-pana.png',
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Giriş Yap',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            wordSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Lütfen Giriş Bilgilerinizi Doldurunuz',
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 16, color: Colors.grey, wordSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFieldInput(
                      hintText: 'Mail Adresinizi Giriniz.',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      icondata: const Icon(CupertinoIcons.mail_solid),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      hintText: 'Şifrenizi Giriniz',
                      textInputType: TextInputType.visiblePassword,
                      textEditingController: _passwordController,
                      isPass: true,
                      icondata: const Icon(Icons.password_sharp),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Şifremi Unuttum',
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: loginUser,
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
                                'Giriş Yap',
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
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Hesabınız Yok mu ?',
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              ' Kayıt Ol.',
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.info),
                        onPressed: goster,
                        label: Text(
                          'Misafir Hesabını Getir.',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
