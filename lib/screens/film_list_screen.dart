import 'dart:async';
import 'package:flutter/material.dart';
import '../data/film_repository.dart';
import '../models/film.dart';
import '../theme/app_theme.dart';
import '../widgets/film_card.dart';
import 'film_form_screen.dart';

class FilmListScreen extends StatefulWidget {
  const FilmListScreen({super.key});

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  final _repo = FilmRepository.instance;
  StreamSubscription<List<Film>>? _langganan;
  List<Film> _films = [];
  bool _memuat = true;
  String? _galat;
  String _query = '';
  String _filter = 'Semua';

  @override
  void initState() {
    super.initState();
    _repo.isiDataAwalJikaKosong();
    _langganan = _repo.pantau().listen(
          (data) {
        if (!mounted) return;
        setState(() {
          _films = data;
          _memuat = false;
          _galat = null;
        });
      },
      onError: (e) {
        if (!mounted) return;
        setState(() {
          _memuat = false;
          _galat = 'Gagal memuat data dari Firestore';
        });
      },
    );
  }

  @override
  void dispose() {
    _langganan?.cancel();
    super.dispose();
  }

  List<Film> get _tampil {
    return _films.where((f) {
      final cocokStatus = _filter == 'Semua' || f.status == _filter;
      final cocokJudul = f.judul.toLowerCase().contains(_query.toLowerCase());
      return cocokStatus && cocokJudul;
    }).toList();
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(teks, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _tambah() async {
    final hasil = await Navigator.push<Film>(
      context,
      MaterialPageRoute(builder: (_) => const FilmFormScreen()),
    );
    if (hasil == null || !mounted) return;
    final berhasil = await _repo.tambah(hasil);
    if (!mounted) return;
    _pesan(
      berhasil
          ? 'Film ditambahkan'
          : 'Film "${hasil.judul}" sudah ada di koleksi',
    );
  }

  Future<void> _ubah(Film film) async {
    final hasil = await Navigator.push<Film>(
      context,
      MaterialPageRoute(builder: (_) => FilmFormScreen(film: film)),
    );
    if (hasil == null || !mounted) return;
    await _repo.ubah(hasil);
    if (!mounted) return;
    _pesan('Perubahan disimpan');
  }

  Future<void> _hapus(Film film) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Hapus film?'),
        content: Text('"${film.judul}" akan dihapus dari koleksi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.green),
            ),
          ),
        ],
      ),
    );
    if (yakin != true || !mounted) return;
    await _repo.hapus(film.judul);
    if (!mounted) return;
    _pesan('Film dihapus');
  }

  Widget _stat(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: AppColors.dim, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _isiDaftar(List<Film> daftar) {
    if (_memuat) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.green),
      );
    }
    if (_galat != null) {
      return Center(
        child: Text(_galat!, style: const TextStyle(color: AppColors.muted)),
      );
    }
    if (daftar.isEmpty) {
      return const Center(
        child: Text(
          'Film tidak ditemukan',
          style: TextStyle(color: AppColors.muted),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 88),
      itemCount: daftar.length,
      itemBuilder: (context, i) {
        final film = daftar[i];
        return FilmCard(
          film: film,
          onEdit: () => _ubah(film),
          onDelete: () => _hapus(film),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selesai =
        _films.where((f) => f.status == FilmStatus.selesai).length;
    final mau = _films.length - selesai;
    final daftar = _tampil;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter_outlined, color: AppColors.green),
            SizedBox(width: 8),
            Text(
              'LetsMovie',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: AppColors.green),
                  SizedBox(width: 5),
                  Text(
                    'Online',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Cari judul film...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _stat('Total film', _films.length),
                const SizedBox(width: 10),
                _stat('Selesai', selesai),
                const SizedBox(width: 10),
                _stat('Mau ditonton', mau),
              ],
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
                    selectedColor: AppColors.green,
                    backgroundColor: AppColors.card,
                    side: BorderSide(
                      color: aktif ? AppColors.green : AppColors.border,
                    ),
                    labelStyle: TextStyle(
                      color: aktif ? AppColors.onGreen : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _isiDaftar(daftar)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambah,
        child: const Icon(Icons.add),
      ),
    );
  }
}