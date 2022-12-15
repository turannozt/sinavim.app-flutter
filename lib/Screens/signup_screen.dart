// ignore_for_file: use_build_context_synchronously
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sinavim_app/Resources/auth_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/login_screen.dart';
import 'package:sinavim_app/Screens/verify_email_screen.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Widgets/feedback_card.dart';
import 'package:sinavim_app/Widgets/text_field_input.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
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
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: "Hedefin Nedir ?",
      token: await token(),
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      Fluttertoast.showToast(
        msg: "Başarılı Bir Şekilde Hesabınız Oluştu.",
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
        body: "Aramıza Hoş Geldin ${_usernameController.text}  :)",
      );
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const VerifyEmailPage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Alanları Boş Bırakmayınız !",
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackPage(),
                          ),
                        ),
                        icon: const Icon(Icons.feedback_sharp),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      "E-Posta Doğrulaması Hakkında"),
                                  content: Text(
                                    "•Sahte e-posta adresi yazmayın doğrulama yapamazsınız. (Uygulama ve kullanıcı güvenliği sağlamak amacıyla yapılmış bir düzendir.) \n •Doğrulama maili gelmedi mi ? Mailinizi ve Spam kutusunu kontrol edin. (Mail spam olarak algılanmış olabilir.) \n •Eğer mail gelmediyse tekrardan mail gönder ifadesini kullanıp bir kez daha deneyin. \n •Eğer hâlâ sorun yaşıyorsanız sorun bildir yerinden SINAVIM yapımcısı ile iletişime geçebilirsiniz.",
                                    style: GoogleFonts.openSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      wordSpacing: 1,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Text("Tamam"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.warning))
                    ],
                  ),

                  Center(
                    child: SvgPicture.asset(
                      'assets/images/sinavim.svg',
                      color: const Color(0xffd94555),
                      height: 55,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/Sign up-amico.png',
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'Kayıt Ol',
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Lütfen Kayıt Bilgilerinizi Doldurunuz',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 16, color: Colors.grey, wordSpacing: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    hintText: 'Kullanıcı Adınızı Giriniz.',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                    icondata: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    hintText: 'Mail Adresinizi Giriniz.',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    icondata: const Icon(CupertinoIcons.mail_solid),
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    hintText: 'Şifrenizi Giriniz.',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    icondata: const Icon(Icons.password_outlined),
                    isPass: true,
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
                          ? const Text(
                              'Kayıt Ol',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            )
                          : const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  //Açıklamalar Giriş Yap
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Hesabınız Var mı ?',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
