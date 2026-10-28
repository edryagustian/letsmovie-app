import 'package:flutter/material.dart';
import '../models/film.dart';
import '../theme/app_theme.dart';

class FilmFormScreen extends StatefulWidget {
  final Film? film; // null = tambah, terisi = edit

  const FilmFormScreen({super.key, this.film});

  @override
  State<FilmFormScreen> createState() => _FilmFormScreenState();
}

class _FilmFormScreenState extends State<FilmFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _tahun;
  late final TextEditingController _durasi;
  late final TextEditingController _genre;
  late final TextEditingController _sutradara;
  late final TextEditingController _negara;
  late final TextEditingController _catatan;
  late final TextEditingController _poster;
  late String _status;
  DateTime? _tanggal;

  bool get _modeEdit => widget.film != null;

  @override
  void initState() {
    super.initState();
    final f = widget.film;
    _judul = TextEditingController(text: f?.judul ?? '');
    _tahun = TextEditingController(text: f != null ? '${f.tahun}' : '');
    _durasi = TextEditingController(text: f != null ? '${f.durasi}' : '');
    _genre = TextEditingController(text: f?.genre ?? '');
    _sutradara = TextEditingController(text: f?.sutradara ?? '');
    _negara = TextEditingController(text: f?.negara ?? '');
    _catatan = TextEditingController(text: f?.catatan ?? '');
    _poster = TextEditingController(text: f?.poster ?? '');
    _status = f?.status ?? FilmStatus.mauDitonton;
    _tanggal = f?.tanggalTonton;
  }

  @override
  void dispose() {
    _judul.dispose();
    _tahun.dispose();
    _durasi.dispose();
    _genre.dispose();
    _sutradara.dispose();
    _negara.dispose();
    _catatan.dispose();
    _poster.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime d) {
    final hari = d.day.toString().padLeft(2, '0');
    final bulan = d.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${d.year}';
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (hasil != null) setState(() => _tanggal = hasil);
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final film = Film(
      judul: _judul.text.trim(),
      tahun: int.parse(_tahun.text.trim()),
      genre: _genre.text.trim(),
      sutradara: _sutradara.text.trim(),
      durasi: int.parse(_durasi.text.trim()),
      negara: _negara.text.trim(),
      status: _status,
      tanggalTonton: _status == FilmStatus.selesai ? _tanggal : null,
      catatan: _catatan.text.trim(),
      poster: _poster.text.trim(),
      isSynced: false,
      updatedAt: DateTime.now(),
    );
    Navigator.pop(context, film);
  }

  Widget _label(String teks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        teks.toUpperCase(),
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        String? hint,
        TextInputType? type,
        String? Function(String?)? validator,
        bool enabled = true,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: type,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  String? _wajib(String? v) {
    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  String? _angka(String? v) {
    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
    final n = int.tryParse(v.trim());
    if (n == null || n <= 0) return 'Angka tidak valid';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _modeEdit ? 'Edit Film' : 'Tambah Film',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                'Judul film *',
                _judul,
                hint: 'Contoh: Parasite',
                validator: _wajib,
                enabled: !_modeEdit,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _field(
                      'Tahun *',
                      _tahun,
                      hint: '2019',
                      type: TextInputType.number,
                      validator: _angka,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      'Durasi (menit) *',
                      _durasi,
                      hint: '132',
                      type: TextInputType.number,
                      validator: _angka,
                    ),
                  ),
                ],
              ),
              _field(
                'Genre *',
                _genre,
                hint: 'Contoh: Drama, Thriller',
                validator: _wajib,
              ),
              _field('Sutradara', _sutradara, hint: 'Contoh: Bong Joon-ho'),
              _field('Negara', _negara, hint: 'Contoh: Korea Selatan'),
              _field(
                'Link poster (opsional)',
                _poster,
                hint: 'https://...jpg',
                type: TextInputType.url,
              ),
              _label('Status'),
              Row(
                children: FilmStatus.semua.map((s) {
                  final aktif = s == _status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: aktif,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _status = s),
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
              const SizedBox(height: 16),
              if (_status == FilmStatus.selesai) ...[
                _label('Tanggal tonton'),
                InkWell(
                  onTap: _pilihTanggal,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tanggal == null
                                ? 'Pilih tanggal'
                                : _formatTanggal(_tanggal!),
                            style: TextStyle(
                              color: _tanggal == null
                                  ? AppColors.dim
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const Icon(Icons.calendar_today_outlined,
                            size: 18, color: AppColors.dim),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _field(
                'Catatan',
                _catatan,
                hint: 'Tulis catatan pribadi...',
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _simpan,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.onGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.muted,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'BATAL',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}