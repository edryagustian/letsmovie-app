class FilmStatus {
  static const mauDitonton = 'Mau ditonton';
  static const selesai = 'Selesai';
  static const semua = [mauDitonton, selesai];
}

class Film {
  final String judul; // primary key
  final int tahun;
  final String genre;
  final String sutradara;
  final int durasi; // menit
  final String negara;
  final String status;
  final DateTime? tanggalTonton;
  final String catatan;
  final String poster; // link gambar, opsional
  final bool isSynced;
  final DateTime updatedAt;

  const Film({
    required this.judul,
    required this.tahun,
    required this.genre,
    required this.sutradara,
    required this.durasi,
    required this.negara,
    required this.status,
    this.tanggalTonton,
    this.catatan = '',
    this.poster = '',
    this.isSynced = false,
    required this.updatedAt,
  });
}