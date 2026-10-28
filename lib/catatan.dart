/// Padanan Catatan.kt (Entity): satu objek = satu baris (record) di tabel.
class Catatan {
  final int? id; // null saat belum disimpan, diisi otomatis oleh database
  final String judul;
  final String isi;

  const Catatan({this.id, required this.judul, required this.isi});

  // Objek -> Map, untuk ditulis ke database
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
  };

  // Map -> objek, untuk dibaca dari database
  factory Catatan.fromMap(Map<String, Object?> map) => Catatan(
    id: map['id'] as int,
    judul: map['judul'] as String,
    isi: map['isi'] as String,
  );

  // Salinan dengan sebagian field diubah (setara copy() di Kotlin)
  Catatan copyWith({String? judul, String? isi}) =>
      Catatan(id: id, judul: judul ?? this.judul, isi: isi ?? this.isi);
}
