import 'package:flutter/material.dart';
import '../models/film.dart';
import '../theme/app_theme.dart';

class FilmCard extends StatelessWidget {
  final Film film;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FilmCard({
    super.key,
    required this.film,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final selesai = film.status == FilmStatus.selesai;
    final statusColor = selesai ? AppColors.green : AppColors.blue;
    final statusBg =
    selesai ? const Color(0xFF0E3B22) : const Color(0xFF10364A);
    final syncColor = film.isSynced ? AppColors.green : AppColors.orange;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  film.judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onDelete,
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${film.tahun}  •  ${film.genre}  •  ${film.durasi} mnt',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Text(
            '${film.sutradara}  •  ${film.negara}',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  film.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.circle, size: 10, color: syncColor),
              const SizedBox(width: 6),
              Text(
                film.isSynced ? 'Tersinkron' : 'Belum sinkron',
                style: TextStyle(color: syncColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}