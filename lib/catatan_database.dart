import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'catatan.dart';

/// Padanan CatatanDatabase.kt + CatatanDao.kt:
/// membuat database dan berisi perintah baca/tambah/ubah/hapus.
class CatatanDatabase {
  Database? _db;

  Future<Database> get _database async => _db ??= await _buka();

  Future<Database> _buka() async {
    final path = join(await getDatabasesPath(), 'catatan-kuliah.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE catatan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          judul TEXT NOT NULL,
          isi TEXT NOT NULL
        )
      '''),
    );
  }

  // SELECT * FROM catatan ORDER BY id DESC
  Future<List<Catatan>> semua() async {
    final db = await _database;
    final rows = await db.query('catatan', orderBy: 'id DESC');
    return rows.map(Catatan.fromMap).toList();
  }

  Future<void> tambah(Catatan item) async {
    final db = await _database;
    await db.insert('catatan', item.toMap());
  }

  Future<void> ubah(Catatan item) async {
    final db = await _database;
    await db.update(
      'catatan',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> hapus(Catatan item) async {
    final db = await _database;
    await db.delete('catatan', where: 'id = ?', whereArgs: [item.id]);
  }
}
