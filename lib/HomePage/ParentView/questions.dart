import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'ما هو التوحد؟',
      'answer':
          'التوحد هو اضطراب طيفي يؤثر على القدرة على التواصل والتفاعل الاجتماعي والسلوك.',
    },
    {
      'question': 'ما هي أسباب التوحد؟',
      'answer':
          'لا يزال السبب الدقيق للتوحد غير معروف، ولكن يعتقد الخبراء أنه يمكن أن يكون بسبب عوامل وراثية وبيئية.',
    },
    {
      'question': 'ما هي العلامات الأولى للتوحد؟',
      'answer':
          'العلامات الأولى للتوحد تشمل عدم الاهتمام بالأشخاص والأشياء، وعدم الرد على الاسم، وعدم النظر في العينين، وعدم الاستجابة للتعبيرات الوجهية.',
    },
    {
      'question': 'كيف يمكن تشخيص التوحد؟',
      'answer':
          'يتم تشخيص التوحد عن طريق تقييم سلوك الطفل وتقييم النمط العام للتفاعل الاجتماعي والاتصال.',
    },
    {
      'question': 'هل يمكن علاج التوحد؟',
      'answer':
          'لا يوجد علاج للتوحد، ولكن يمكن تحسين الأعراض وتحسين جودة الحياة من خلال العلاج السلوكي والتعليمي والدوائي.',
    },
    {
      'question': 'هل يمكن الوقاية من التوحد؟',
      'answer':
          'لا يوجد طريقة مؤكدة للوقاية من التوحد، ولكن يمكن تقليل خطر الإصابة بالتوحد من خلال تجنب بعض العوامل البيئية المحتملة.',
    },
  ];

  FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'الأسئلة الشائعة',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
      backgroundColor: Colors.green,
      body: Theme(
        data: ThemeData(
          textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.white),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var faq in faqs)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 80,
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            faq['answer']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
