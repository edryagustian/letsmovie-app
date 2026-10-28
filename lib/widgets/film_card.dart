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

  Widget _placeholder() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF26303B), Color(0xFF12171C)],
        ),
      ),
      child: Text(
        film.judul.isNotEmpty ? film.judul[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.green,
        ),
      ),
    );
  }

  Widget _poster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 64,
        height: 92,
        child: film.poster.isEmpty
            ? _placeholder()
            : Image.network(
          film.poster,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
          loadingBuilder: (context, child, progress) =>
          progress == null ? child : _placeholder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selesai = film.status == FilmStatus.selesai;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _poster(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        film.judul,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onEdit,
                      child: const Icon(Icons.edit_outlined,
                          size: 20, color: AppColors.muted),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete_outline,
                          size: 20, color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${film.tahun}  •  ${film.durasi} mnt',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                Text(
                  film.genre,
                  style: const TextStyle(color: AppColors.dim, fontSize: 13),
                ),
                Text(
                  '${film.sutradara}  •  ${film.negara}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.dim, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: selesai ? AppColors.greenSoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selesai ? Colors.transparent : AppColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selesai ? Icons.check_circle : Icons.schedule,
                            size: 14,
                            color: selesai ? AppColors.green : AppColors.muted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            film.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                              selesai ? AppColors.green : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      film.isSynced
                          ? Icons.cloud_done_outlined
                          : Icons.cloud_off_outlined,
                      size: 18,
                      color: film.isSynced ? AppColors.green : AppColors.dim,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}