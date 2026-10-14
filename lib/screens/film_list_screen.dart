import 'package:flutter/material.dart';
import '../models/dummy_films.dart';
import '../models/film.dart';
import '../theme/app_theme.dart';
import '../widgets/film_card.dart';

class FilmListScreen extends StatefulWidget {
  const FilmListScreen({super.key});

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  final List<Film> _films = buatDummyFilms();
  String _query = '';
  String _filter = 'Semua';

  List<Film> get _tampil {
    return _films.where((f) {
      final cocokStatus = _filter == 'Semua' || f.status == _filter;
      final cocokJudul = f.judul.toLowerCase().contains(_query.toLowerCase());
      return cocokStatus && cocokJudul;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selesai =
        _films.where((f) => f.status == FilmStatus.selesai).length;
    final mau = _films.length - selesai;
    final daftar = _tampil;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LetsMovie',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0E3B22),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 10, color: AppColors.green),
                  SizedBox(width: 6),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Cari judul film...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Semua', ...FilmStatus.semua].map((s) {
                final aktif = s == _filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s),
                    selected: aktif,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _filter = s),
                    selectedColor: AppColors.slate,
                    backgroundColor: AppColors.card,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: TextStyle(
                      color: aktif ? Colors.white : AppColors.muted,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'TOTAL ${_films.length} FILM   •   SELESAI $selesai   •   MAU DITONTON $mau',
                style: const TextStyle(color: AppColors.dim, fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: daftar.isEmpty
                ? const Center(
              child: Text(
                'Film tidak ditemukan',
                style: TextStyle(color: AppColors.muted),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 88),
              itemCount: daftar.length,
              itemBuilder: (context, i) {
                final film = daftar[i];
                return FilmCard(
                  film: film,
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}