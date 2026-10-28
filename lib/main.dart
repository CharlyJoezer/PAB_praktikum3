import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'catatan_database.dart';
import 'catatan_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      // Database -> Repository -> ViewModel, lalu muat data yang sudah tersimpan
      create: (_) =>
          CatatanViewModel(CatatanRepository(CatatanDatabase()))..muat(),
      child: const AplikasiCatatan(),
    ),
  );
}

class AplikasiCatatan extends StatelessWidget {
  const AplikasiCatatan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LayarCatatan(),
    );
  }
}

class LayarCatatan extends StatefulWidget {
  const LayarCatatan({super.key});

  @override
  State<LayarCatatan> createState() => _LayarCatatanState();
}

class _LayarCatatanState extends State<LayarCatatan> {
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();

  bool get _valid =>
      _judulCtrl.text.trim().isNotEmpty && _isiCtrl.text.trim().isNotEmpty;

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  void _tambah(CatatanViewModel vm) {
    vm.tambah(_judulCtrl.text.trim(), _isiCtrl.text.trim());
    _judulCtrl.clear();
    _isiCtrl.clear();
    setState(() {}); // perbarui status tombol Tambah
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatatanViewModel>();
    final daftar = vm.data;

    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Kuliah')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _judulCtrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _isiCtrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Isi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _valid ? () => _tambah(vm) : null,
              child: const Text('Tambah Catatan'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: daftar.isEmpty
                  ? const Center(child: Text('Belum ada catatan.'))
                  : ListView.builder(
                      itemCount: daftar.length,
                      itemBuilder: (context, index) {
                        final c = daftar[index];
                        return Padding(
                          key: ValueKey(c.id),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.judul,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(c.isi),
                              Row(
                                children: [
                                  ElevatedButton(
                                    // Ubah: tambahkan "(revisi)" pada judul
                                    onPressed: () => vm.ubah(
                                      c.copyWith(judul: '${c.judul} (revisi)'),
                                    ),
                                    child: const Text('Ubah'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => vm.hapus(c),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
