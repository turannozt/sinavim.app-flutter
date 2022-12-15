import 'package:flutter/material.dart';
import 'package:sinavim_app/Screens/onboard/build_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onTap;
  const OnboardingPage({super.key, required this.onTap});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          onPageChanged: ((index) {
            setState(() => isLastPage = index == 2);
          }),
          controller: controller,
          children: [
            BuildPage(
              urlImage: 'assets/images/Accept request-amico.png',
              title: 'Kolay Erişim !',
              subtitle:
                  '•Anlaşılabilir ve kullanıcı dostu bir uygulamadır.\n \n •Uygulama kullanıcıya kolaylık sağlayabilecek şekilde tasarlanmıştır.',
            ),
            BuildPage(
              urlImage: 'assets/images/Dictionary-bro.png',
              title: 'Verimlilik ve Motivasyon',
              subtitle:
                  '•Bu sayfada dersle ilgili paylaşım yapıp motive olabilirsiniz. \n \n •Çalışma arkadaşı edinebilir ve çalışmanızı daha verimli hale getirebilirsiniz. \n \n •Bilgi içerikli gönderileri kaydedebilir daha sonra tekrar bakabilirsiniz. \n \n •İstediğiniz kullanıcıyı takip edebilirsiniz. \n \n •İhtiyaç duyduğunuz konularda diğer kullanıcı arkadaşlardan yardım alabilirsiniz.',
            ),
            BuildPage(
              urlImage: 'assets/images/Seminar-bro.png',
              title: 'Mentör Sayfası',
              subtitle:
                  '•Bu sayfada ders, meslek, felsefe, psikoloji vb. her türlü konuda bilgi edinebilirsiniz.\n \n •Yapamadığınız soruları mentörlerimize iletebilir onlardan yardım alabilirsiniz. \n \n •Tecrübeli üniversite öğrencileri ve uzman öğretmenler tarafından siz geliştirecek ders çalışma metotları öğrenebilirsiniz.\n \n •Hazırlanmakta olduğunuz alan konusunda mentörlerimizden bilgi, özel ders hatta koçluk alabilirsiniz.',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: widget.onTap,
              child: Container(
                height: 64,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Başla',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: const Text(
                      'Atla',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.teal.shade700,
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    ),
                    child: const Icon(Icons.keyboard_double_arrow_right),
                  ),
                ],
              ),
            ),
    );
  }
}
