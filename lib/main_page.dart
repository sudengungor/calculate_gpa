import 'package:calculate_gpa/ders.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final _formKey = GlobalKey<FormState>();

  final _dersAdiController = TextEditingController();
  final List<Ders> _tumDersler = [];

  @override
  void dispose() {
    _dersAdiController.dispose();
    super.dispose();
  }

  String? _secilenHarfNotu;
  int? _secilenKredi;

  ColorScheme get temaRenkleri => Theme.of(context).colorScheme;

  final List<String> _harfler = [
    'AA',
    'BA',
    'BB',
    'CB',
    'CC',
    'DC',
    'DD',
    'FD',
    'FF',
  ];
  final List<int> _krediler = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Calculate GPA",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: temaRenkleri.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: ortHesaplanacakDersBilgiGir()),
                SizedBox(width: 20),
                ortalamaGoster(),
              ],
            ),
            Divider(
              color: temaRenkleri.secondary,
              thickness: 4,
              radius: BorderRadius.circular(500),
            ),
            Expanded(child: secilenDersiGoster()),
          ],
        ),
      ),
    );
  }

  Widget ortHesaplanacakDersBilgiGir() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _dersAdiController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Calculus", 
                labelText: "Ders Adi Girin" 
              ),
              validator: (value) {
                if(value == null || value.trim().isEmpty){
                  return "Ders adi boş olamaz";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),                   
                    ),
                    validator: (value) {
                      if (value == null){
                        return "Lütfen harf notu seçiniz";
                      }
                      return null;
                    },
                    hint: Text('AA'),
                    value: _secilenHarfNotu,
                    items: _harfler.map((String harf) {
                      return DropdownMenuItem<String>(
                        value: harf,
                        child: Text(harf),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _secilenHarfNotu = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      if(value == null){
                        return "Lütfen kredi seçiziniz";
                      }
                      return null;
                    },
                    value: _secilenKredi,
                    items: _krediler.map((int kredi) {
                      return DropdownMenuItem<int>(
                        value: kredi,
                        child: Text("$kredi"),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _secilenKredi = newValue;
                      });
                    },
                    hint: Text('5'),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: temaRenkleri.primary,
                  ),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _tumDersler.insert(
                        0,
                        Ders(
                          ad: _dersAdiController.text,
                          harfNotu: _secilenHarfNotu!,
                          kredi: _secilenKredi!,
                        ),
                      );
                      // Ekleme bittikten sonra formu temizliyoruz
                      _dersAdiController.clear();
                      _secilenHarfNotu = _harfler[0];
                      _secilenKredi = _krediler[0];
        
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ortalamaGoster() {
    return Center(
      child: Column(
        children: [
          Text(
            "${_tumDersler.length} Ders Girildi",
            style: TextStyle(color: temaRenkleri.primary, fontSize: 15),
          ),
          Text(
            _ortalamaHesapla().toStringAsFixed(2),
            style: TextStyle(color: temaRenkleri.primary, fontSize: 45, fontWeight: FontWeight.bold),
          ),
          Text("Ortalama", style: TextStyle(color: temaRenkleri.primary, fontSize: 15)),
        ],
      ),
    );
  }

  Widget secilenDersiGoster() {
    return ListView.builder(
      itemCount: _tumDersler.length,
      itemBuilder: (BuildContext context, int index) {
        Ders oAnkiDers = _tumDersler[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              _tumDersler.removeAt(index);
            });
          },
          child: ListTile(
            leading: Icon(Icons.class_, color: temaRenkleri.tertiary),
            title: Text(oAnkiDers.ad),
            subtitle: Text(oAnkiDers.harfNotu),
            trailing: Icon(Icons.menu, color: temaRenkleri.secondary),
          ),
        );
      },
    );
  }

  double _ortalamaHesapla() {
    if (_tumDersler.isEmpty) {
      return 0.0;
    }
    double toplamPuan = 0;
    int toplamKredi = 0;

    for (var ders in _tumDersler) {
      toplamKredi += ders.kredi;
      toplamPuan += ders.kredi * _harfNotuPuanaCevir(ders.harfNotu);
    }
    return toplamPuan / toplamKredi;
  }

  double _harfNotuPuanaCevir(String harfNotu) {
    switch (harfNotu) {
      case 'AA':
        return 4.0;
      case 'BA':
        return 3.5;
      case 'BB':
        return 3.0;
      case 'CB':
        return 2.5;
      case 'CC':
        return 2.0;
      case 'DC':
        return 1.5;
      case 'DD':
        return 1.0;
      case 'FD':
        return 0.5;
      case 'FF':
      default:
        return 0.0;
    }
  }
}
