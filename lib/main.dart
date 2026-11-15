import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(const SanadApp());

const sanadBlue = Color(0xFF2563EB);
const sanadNavy = Color(0xFF14213D);
const sanadBg = Color(0xFFF5F7FB);

class SanadApp extends StatelessWidget {
  const SanadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سند | SANAD AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: sanadBg,
        colorScheme: ColorScheme.fromSeed(seedColor: sanadBlue),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: sanadBg,
          foregroundColor: sanadNavy,
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  final pages = const [HomePage(), AssistantPage(), VisionPage(), ResourcesPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(child: IndexedStack(index: index, children: pages)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat), label: 'المساعد'),
            NavigationDestination(icon: Icon(Icons.camera_alt_outlined), selectedIcon: Icon(Icons.camera_alt), label: 'الكاميرا'),
            NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder), label: 'الموارد'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: sanadBlue, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.accessibility_new, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('سند', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: sanadNavy)),
            Text('مساعدك الذكي لحياة أسهل', style: TextStyle(color: Colors.black54)),
          ])),
          IconButton(onPressed: () {}, tooltip: 'الإشعارات', icon: const Icon(Icons.notifications_none)),
        ]),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF6046D8)]),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('أهلاً بك 👋', style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 8),
            const Text('أنا سند، مساعدك الذكي.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('اسألني، أو استخدم الكاميرا لوصف ما حولك.', style: TextStyle(color: Colors.white, height: 1.5)),
            const SizedBox(height: 18),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: sanadBlue),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StandaloneAssistantPage())),
              icon: const Icon(Icons.mic),
              label: const Text('تحدث مع سند'),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        const SectionTitle('خدمات سند'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.22,
          children: const [
            ServiceTile(icon: Icons.mic_none, title: 'المساعد الصوتي', subtitle: 'تحدث واسأل'),
            ServiceTile(icon: Icons.camera_alt_outlined, title: 'الرؤية الذكية', subtitle: 'افهم ما حولك'),
            ServiceTile(icon: Icons.menu_book_outlined, title: 'مكتبة الموارد', subtitle: 'مواد وأدوات مساعدة'),
            ServiceTile(icon: Icons.accessibility_new, title: 'إمكانية الوصول', subtitle: 'خصص تجربتك'),
          ],
        ),
        const SizedBox(height: 22),
        Card(child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFFF1D6), child: Icon(Icons.info_outline, color: Color(0xFF9A6700))),
          title: const Text('نسخة تجريبية أولى', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('بعض وظائف الذكاء الاصطناعي تحتاج ربط خادم ومفتاح API قبل الاستخدام الفعلي.'),
        )),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: sanadNavy));
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const ServiceTile({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: sanadBlue, size: 29),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
    ),
  );
}

class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});
  @override
  Widget build(BuildContext context) => const AssistantChat();
}

class StandaloneAssistantPage extends StatelessWidget {
  const StandaloneAssistantPage({super.key});
  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(appBar: AppBar(title: Text('المساعد الذكي')), body: SafeArea(child: AssistantChat())),
  );
}

class AssistantChat extends StatefulWidget {
  const AssistantChat({super.key});
  @override
  State<AssistantChat> createState() => _AssistantChatState();
}

class _AssistantChatState extends State<AssistantChat> {
  final controller = TextEditingController();
  final speech = stt.SpeechToText();
  final tts = FlutterTts();
  final List<ChatMessage> messages = [
    ChatMessage('أهلاً! أنا سند. كيف أقدر أساعدك النهارده؟', false),
  ];
  bool listening = false;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    tts.setLanguage('ar-EG');
    tts.setSpeechRate(0.45);
  }

  Future<void> startListening() async {
    final available = await speech.initialize(
      onStatus: (status) { if (status == 'done' || status == 'notListening') setState(() => listening = false); },
      onError: (_) => setState(() => listening = false),
    );
    if (!available) {
      _show('تعذر تشغيل التعرف على الصوت. تأكد من صلاحية الميكروفون.');
      return;
    }
    setState(() => listening = true);
    await speech.listen(
      localeId: 'ar_EG',
      onResult: (result) {
        setState(() => controller.text = result.recognizedWords);
        if (result.finalResult && controller.text.trim().isNotEmpty) send();
      },
    );
  }

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty || busy) return;
    setState(() {
      messages.add(ChatMessage(text, true));
      controller.clear();
      busy = true;
    });
    // TODO: Replace local demo response with a secure backend AI endpoint.
    await Future.delayed(const Duration(milliseconds: 500));
    final answer = 'وصلني سؤالك: "$text". أنا حالياً في النسخة التجريبية. بعد ربط خدمة الذكاء الاصطناعي بالخادم سأقدر أقدم لك إجابة مخصصة.';
    setState(() {
      messages.add(ChatMessage(answer, false));
      busy = false;
    });
    await tts.speak(answer);
  }

  void _show(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  void dispose() {
    controller.dispose();
    speech.stop();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Expanded(child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (busy ? 1 : 0),
      itemBuilder: (context, i) {
        if (busy && i == messages.length) return const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.all(12), child: Text('سند يكتب…')));
        final m = messages[i];
        return Align(
          alignment: m.fromUser ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 310),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: m.fromUser ? sanadBlue : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(m.text, style: TextStyle(color: m.fromUser ? Colors.white : sanadNavy, height: 1.5)),
          ),
        );
      },
    )),
    SafeArea(top: false, child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(children: [
        IconButton.filledTonal(
          onPressed: listening ? () async { await speech.stop(); setState(() => listening = false); } : startListening,
          icon: Icon(listening ? Icons.stop : Icons.mic),
          tooltip: listening ? 'إيقاف الاستماع' : 'تحدث',
        ),
        const SizedBox(width: 8),
        Expanded(child: TextField(
          controller: controller,
          minLines: 1, maxLines: 4,
          decoration: InputDecoration(
            hintText: 'اكتب رسالتك لسند…',
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          ),
          onSubmitted: (_) => send(),
        )),
        const SizedBox(width: 8),
        IconButton.filled(onPressed: send, icon: const Icon(Icons.send), tooltip: 'إرسال'),
      ]),
    )),
  ]);
}

class ChatMessage {
  final String text;
  final bool fromUser;
  ChatMessage(this.text, this.fromUser);
}

class VisionPage extends StatefulWidget {
  const VisionPage({super.key});
  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  final picker = ImagePicker();
  XFile? photo;
  bool analyzing = false;

  Future<void> takePhoto() async {
    final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image == null) return;
    setState(() { photo = image; analyzing = true; });
    // TODO: Upload the image to a secure backend vision model after explicit consent.
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => analyzing = false);
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('الكاميرا الذكية', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: sanadNavy)),
    const SizedBox(height: 8),
    const Text('التقط صورة واسأل سند عن الأشياء أو النصوص الموجودة أمامك.', style: TextStyle(color: Colors.black54, height: 1.5)),
    const SizedBox(height: 20),
    Container(
      height: 300,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: photo == null
        ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.camera_alt_outlined, size: 64, color: sanadBlue),
            SizedBox(height: 12), Text('صورتك ستظهر هنا'),
          ])
        : Image.file(File(photo!.path), fit: BoxFit.cover),
    ),
    const SizedBox(height: 16),
    FilledButton.icon(onPressed: takePhoto, icon: const Icon(Icons.camera_alt), label: const Text('افتح الكاميرا والتقط صورة'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54))),
    if (analyzing) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
    if (photo != null && !analyzing) const Card(child: Padding(
      padding: EdgeInsets.all(16),
      child: Text('تم التقاط الصورة بنجاح. تحليل الصورة بالذكاء الاصطناعي سيتم تفعيله بعد ربط خدمة الرؤية بالخادم.', style: TextStyle(height: 1.5)),
    )),
    const SizedBox(height: 12),
    const Text('تنبيه: لا تعتمد على وصف الكاميرا وحده في التنقل أو المواقف التي تتطلب قراراً فورياً.', style: TextStyle(color: Colors.black54, fontSize: 12)),
  ]);
}

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});
  final items = const [
    ('كتب صوتية', 'مواد يمكن الاستماع إليها', Icons.headphones),
    ('ملفات تعليمية', 'أدلة وملفات بصيغة PDF', Icons.picture_as_pdf),
    ('لوحات التواصل', 'رموز وجمل للتواصل اليومي', Icons.chat),
    ('لغة الإشارة', 'مواد تعليمية مرئية', Icons.sign_language),
    ('أدوات مساعدة', 'تطبيقات وتقنيات مساندة', Icons.extension),
  ];

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('مكتبة الموارد', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: sanadNavy)),
    const SizedBox(height: 8),
    const Text('موارد مساعدة منظمة حسب احتياجاتك.', style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 16),
    ...items.map((item) => Card(child: ListTile(
      leading: CircleAvatar(backgroundColor: const Color(0xFFEAF1FF), child: Icon(item.$3, color: sanadBlue)),
      title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(item.$2),
      trailing: const Icon(Icons.chevron_left),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم إضافة ملفات موثوقة قابلة للتحميل في المرحلة التالية.'))),
    ))),
  ]);
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool largeText = false;
  bool voiceFeedback = true;
  String need = 'لم أحدد بعد';

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('إعدادات إمكانية الوصول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: sanadNavy)),
    const SizedBox(height: 16),
    Card(child: Column(children: [
      ListTile(title: const Text('الاحتياج الأساسي'), subtitle: Text(need), leading: const Icon(Icons.accessibility_new)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: DropdownButtonFormField<String>(
        value: need,
        decoration: const InputDecoration(labelText: 'اختر ما يناسبك'),
        items: const ['لم أحدد بعد', 'إعاقة بصرية', 'إعاقة سمعية', 'إعاقة حركية', 'صعوبات تعلم', 'صعوبات تواصل', 'احتياجات متعددة']
          .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (v) => setState(() => need = v ?? need),
      )),
      SwitchListTile(title: const Text('تكبير النصوص'), value: largeText, onChanged: (v) => setState(() => largeText = v)),
      SwitchListTile(title: const Text('التغذية الراجعة الصوتية'), value: voiceFeedback, onChanged: (v) => setState(() => voiceFeedback = v)),
    ])),
    const SizedBox(height: 12),
    const Card(child: ListTile(
      leading: Icon(Icons.privacy_tip_outlined, color: sanadBlue),
      title: Text('الخصوصية والأمان'),
      subtitle: Text('سنطلب إذن الكاميرا والميكروفون عند الحاجة فقط. لا تضع بيانات حساسة في النسخة التجريبية.'),
    )),
    const Card(child: ListTile(
      leading: Icon(Icons.info_outline, color: sanadBlue),
      title: Text('حول سند'),
      subtitle: Text('SANAD AI – نسخة MVP أولية'),
    )),
  ]);
}
