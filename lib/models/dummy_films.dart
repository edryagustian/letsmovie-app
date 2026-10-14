import 'film.dart';

List<Film> buatDummyFilms() {
  final now = DateTime.now();
  return [
    Film(
      judul: 'Parasite',
      tahun: 2019,
      genre: 'Drama, Thriller',
      sutradara: 'Bong Joon-ho',
      durasi: 132,
      negara: 'Korea Selatan',
      status: FilmStatus.selesai,
      tanggalTonton: DateTime(2026, 9, 12),
      catatan: 'Plot twist-nya gila.',
      isSynced: true,
      updatedAt: now,
    ),
    Film(
      judul: 'Inception',
      tahun: 2010,
      genre: 'Sci-Fi, Aksi',
      sutradara: 'Christopher Nolan',
      durasi: 148,
      negara: 'Amerika Serikat',
      status: FilmStatus.mauDitonton,
      isSynced: false,
      updatedAt: now,
    ),
    Film(
      judul: 'Your Name',
      tahun: 2016,
      genre: 'Animasi, Romance',
      sutradara: 'Makoto Shinkai',
      durasi: 106,
      negara: 'Jepang',
      status: FilmStatus.mauDitonton,
      isSynced: true,
      updatedAt: now,
    ),
    Film(
      judul: 'Train to Busan',
      tahun: 2016,
      genre: 'Horor, Aksi',
      sutradara: 'Yeon Sang-ho',
      durasi: 118,
      negara: 'Korea Selatan',
      status: FilmStatus.selesai,
      tanggalTonton: DateTime(2026, 8, 3),
      isSynced: true,
      updatedAt: now,
    ),
  ];
}