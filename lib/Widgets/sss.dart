import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Step {
  Step(this.title, this.body, [this.isExpanded = false]);
  String title;
  String body;
  bool isExpanded;
}

List<Step> getSteps() {
  return [
    Step('SINAVIM nedir?',
        '•	Sınavım öğrenci dostu bir uygulama olup öğrencilerin ders çalışmasını kolaylaştırmak ve öğrencilere ders çalışırken ihtiyaç duydukları ortamı sağlamak amacıyla yapılmış bir uygulamadır. Temel amacı öğrencilere sınava hazırlanırken destek olmak, onların motivasyonunu korumaktır.'),
    Step('SINAVIM uygulaması ücretli midir?',
        '•	Sınavımın genel kullanımı ücretsizdir ancak bazı premium (ücretli) özellikleri (özel ders, koçluk vb.) bulunmaktadır.'),
    Step('SINAVIMDA ne tür gönderiler paylaşabilirim?',
        '•	Sınavım uygulamasında dersle alakalı her tür gönderiyi paylaşabilirsiniz. Sizleri ders çalışırken motive eden şeyleri (istediğiniz üniversitenin resmi, olmak istediğiniz meslekle ilgili resimler vb.) paylaşabilirsiniz.'),
    Step('Şifremi nasıl güncellerim?',
        '•	Profilinizde ayarlar kısmından ŞİFRE GÜNCELLE seçeneğini kullanarak şifrenizi güncelleyebilirsiniz.'),
    Step('Profil fotoğrafımı nasıl güncellerim?',
        '•	Profilinizde ayarlar kısmını kullanarak yeni bir fotoğraf seçebilir sonrasında fotoğraf altında bulunan ok tuşuna basarak güncelleyebilirsiniz.'),
    Step(
        'E-posta adresimi yazdım ama kabul etmiyor giriş yapamıyorum ne yapmalıyım?',
        '•	E-post adresinizi yanlış yazmadığınıza emin olun•	Sahte e-posta adresi yazmayın doğrulama yapamazsınız. (Uygulama ve kullanıcı güvenliği sağlamak amacıyla yapılmış bir düzendir.)•	Mailinizi ve Spam kutusunu kontrol edin. (Mail spam olarak algılanmış olabilir.)•	Eğer mail gelmediyse tekrardan mail gönder ifadesini kullanıp bir kez daha deneyin.•	Eğer hâlâ sorun yaşıyorsanız sorun bildir yerinden SINAVIM yapımcısı ile iletişime geçebilirsiniz.'),
    Step(
        'SINAVIM kurallarına aykırı bir gönderi gördüm nasıl şikâyet edebilirim?',
        '•	Gönderinin sağ altında bulunan stop komutunu kullanarak gönderiyi şikâyet edebilirsiniz. Şikâyet ettiğiniz gönderi SINAVIM yapımcısı ve modları tarafından dikkate alınıp değerlendirilecektir.'),
    Step('SINAVIM yöneticisi ile nasıl iletişime geçebilirim?',
        '•	SINAVIM modlarına yöneticiye iletilmesini istediğiniz durumu iletebilirsiniz. Modlar durumu SINAVIM yöneticisine iletecektir.'),
  ];
}

class SSS extends StatefulWidget {
  const SSS({Key? key}) : super(key: key);
  @override
  State<SSS> createState() => _SSSState();
}

class _SSSState extends State<SSS> {
  final List<Step> _steps = getSteps();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Sıkça Sorulan Sorular',
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: SingleChildScrollView(
          child: Container(
            child: _renderSteps(),
          ),
        ),
      ),
    );
  }

  Widget _renderSteps() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _steps[index].isExpanded = !isExpanded;
        });
      },
      children: _steps.map<ExpansionPanel>((Step step) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              title: Text(
                step.title,
                style: GoogleFonts.openSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          },
          body: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: const Icon(Icons.info_outline),
            title: Text(
              step.body,
              style: GoogleFonts.openSans(
                  fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
          ),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }
}
