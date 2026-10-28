import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dummy_films.dart';
import '../models/film.dart';

class FilmRepository {
  FilmRepository._();
  static final FilmRepository instance = FilmRepository._();

  final CollectionReference<Map<String, dynamic>> _col =
  FirebaseFirestore.instance.collection('film');

  // nama dokumen = judul huruf kecil, jadi judul kembar otomatis ditolak
  String _id(String judul) => judul.trim().toLowerCase().replaceAll('/', '-');

  Map<String, dynamic> _keMap(Film f) => {
    'judul': f.judul,
    'tahun': f.tahun,
    'genre': f.genre,
    'sutradara': f.sutradara,
    'durasi': f.durasi,
    'negara': f.negara,
    'status': f.status,
    'tanggalTonton': f.tanggalTonton == null
        ? null
        : Timestamp.fromDate(f.tanggalTonton!),
    'catatan': f.catatan,
    'poster': f.poster,
    'updatedAt': Timestamp.fromDate(f.updatedAt),
  };

  Film _dariDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data();
    return Film(
      judul: m['judul'] as String? ?? '',
      tahun: (m['tahun'] as num?)?.toInt() ?? 0,
      genre: m['genre'] as String? ?? '',
      sutradara: m['sutradara'] as String? ?? '',
      durasi: (m['durasi'] as num?)?.toInt() ?? 0,
      negara: m['negara'] as String? ?? '',
      status: m['status'] as String? ?? FilmStatus.mauDitonton,
      tanggalTonton: (m['tanggalTonton'] as Timestamp?)?.toDate(),
      catatan: m['catatan'] as String? ?? '',
      poster: m['poster'] as String? ?? '',
      // sudah tersinkron kalau tidak ada tulisan yang menunggu dikirim ke server
      isSynced: !doc.metadata.hasPendingWrites,
      updatedAt: (m['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // READ: daftar film, otomatis berubah kalau data berubah
  Stream<List<Film>> pantau() {
    return _col
        .orderBy('updatedAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snap) => snap.docs.map(_dariDoc).toList());
  }

  // CREATE (false = judul sudah ada)
  Future<bool> tambah(Film film) async {
    final ref = _col.doc(_id(film.judul));
    var ada = false;
    try {
      final snap = await ref.get(const GetOptions(source: Source.cache));
      ada = snap.exists;
    } catch (_) {}
    if (ada) return false;
    // tidak di-await: saat offline, tulisan disimpan di HP dan dikirim nanti
    unawaited(ref.set(_keMap(film)).catchError((_) {}));
    return true;
  }

  // UPDATE
  Future<void> ubah(Film film) async {
    unawaited(_col.doc(_id(film.judul)).set(_keMap(film)).catchError((_) {}));
  }

  // DELETE
  Future<void> hapus(String judul) async {
    unawaited(_col.doc(_id(judul)).delete().catchError((_) {}));
  }

  // data awal: hanya dimasukkan kalau koleksi masih kosong
  Future<void> isiDataAwalJikaKosong() async {
    try {
      final snap = await _col.limit(1).get();
      if (snap.docs.isNotEmpty || snap.metadata.isFromCache) return;
      final batch = FirebaseFirestore.instance.batch();
      for (final f in buatDummyFilms()) {
        batch.set(_col.doc(_id(f.judul)), _keMap(f));
      }
      unawaited(batch.commit().catchError((_) {}));
    } catch (_) {}
  }
}