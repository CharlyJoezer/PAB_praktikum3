import 'package:flutter/foundation.dart';

import 'catatan.dart';
import 'catatan_database.dart';

/// Perantara antara ViewModel dan database. UI tidak memanggil database langsung.
class CatatanRepository {
  final CatatanDatabase _db;
  CatatanRepository(this._db);

  Future<List<Catatan>> semua() => _db.semua();
  Future<void> tambah(String j, String i) =>
      _db.tambah(Catatan(judul: j, isi: i));
  Future<void> ubah(Catatan c) => _db.ubah(c);
  Future<void> hapus(Catatan c) => _db.hapus(c);
}

/// Pengelola state dan aksi untuk layar catatan.
class CatatanViewModel extends ChangeNotifier {
  final CatatanRepository _repo;
  CatatanViewModel(this._repo);

  List<Catatan> _data = [];
  List<Catatan> get data => _data;

  // Baca ulang semua catatan dari database lalu beri tahu UI
  Future<void> muat() async {
    _data = await _repo.semua();
    notifyListeners();
  }

  Future<void> tambah(String j, String i) async {
    await _repo.tambah(j, i);
    await muat();
  }

  Future<void> ubah(Catatan c) async {
    await _repo.ubah(c);
    await muat();
  }

  Future<void> hapus(Catatan c) async {
    await _repo.hapus(c);
    await muat();
  }
}
