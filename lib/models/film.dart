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
    this.isSynced = false,
    required this.updatedAt,
  });

  Film copyWith({
    int? tahun,
    String? genre,
    String? sutradara,
    int? durasi,
    String? negara,
    String? status,
    DateTime? tanggalTonton,
    String? catatan,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return Film(
      judul: judul,
      tahun: tahun ?? this.tahun,
      genre: genre ?? this.genre,
      sutradara: sutradara ?? this.sutradara,
      durasi: durasi ?? this.durasi,
      negara: negara ?? this.negara,
      status: status ?? this.status,
      tanggalTonton: tanggalTonton ?? this.tanggalTonton,
      catatan: catatan ?? this.catatan,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}