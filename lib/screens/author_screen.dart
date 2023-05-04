import 'package:flutter/material.dart';

class AuthorScreen extends StatelessWidget {
  static const routeNAame = '/author-screen';
  const AuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text("Author", style: Theme.of(context).textTheme.displayLarge,),
              const SizedBox(height: 40,),
              Image.asset('assets/images/photo.jpeg'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Guli Ergasheva Ismailovna',
                style: TextStyle(
                  fontFamily: 'OpenSans-Bold',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
             const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children:  [
                    Text(
                      'O\'zbekiston Davlat Jahon Tillari Universiteti professori, Filologiya fanlar doktori',
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'O\'zDJTU qoshidagi xalqaro reyting ishchi guruhi rahbari.'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Nazariy va amaliy lingvistika ilmiy - tadqiqot instituti direktori.',
                        textAlign: TextAlign.justify,),
                        Text('O\'zbekiston Milliy Universitetida bajarilgan 2012 - 2013 yillarda bajarilgan YoA 1-06 raqamli "Professional tarjimonlarni tayyorlashda sifat nazoratini tashkillashtirishga kompetent yondashuv" nomli amaliy grant loyiha ishtirokchisi. 2017-yilda Erasmus+ Xalqaro loyihasi ishtirokchisi sifatida 3 oy Buyuk Britaniyada malaka oshirib, doktorlik dissertatsiyasini Metropoliten universitetida muhokamadan o\'tqazgan.2019-yilda Amerika amaliy assotsiatsiyasi a\'zosi sifatida AQSHning Atlanta shahrida malaka oshirib qaytgan.2020-yil Belgiya konsulligining 72 soatli "Xalqaro grantlarda g\'olib bo\'lish" nomli loyiha ishtirokchisi. Ushbu loyihada Erasmus+ va Gorizont 2020 ga taqdim etgan ariza namunasi (application form) e\'tirof etilgan va sertifikatini qo\'lga kiritgan.Loyiha rahbarining 2000-yildan tadqiqot faoliyati Gender tadqiqotlari bilan bevosita bog\'liq ekanligi, 20 yildan ortiq ayollar ijtimoiy muhofazasida tilning o\'rni va potensialini namoyon etishda sidqidildan faoliyat olib borishini mazkur olima ayollar uchun joriy etilgan dasturga to\'liq mos kelishini tasdiqlaydi. Uning 70dan ortiq ilmiy maqolalarini va monografiyasi gender aspekti muammosiga bag\'ishlangan. 2022-yilda Amarika amaliy assotsiatsiyasi tomonidan Pitsburg shAhrida o\'tkazilgan konferensiyada fonologiya strendida ma\'ruza bilan ishtirok etgan.' ,textAlign: TextAlign.justify,)
                  ],
                ),
              ),
             ],
          ),
        ),
      ),
    );
  }
}
