enum TipeLesson {
  kenalan('Kenalan'),
  latihan('Latihan');

  const TipeLesson(this.label);
  final String label;
}

/// Entitas Lesson. Lesson kenalan diawali penjelasan maskot, lesson latihan
/// langsung ke soal.
class Lesson {
  const Lesson({
    required this.id,
    required this.topikId,
    required this.judul,
    required this.tipe,
    this.penjelasan = const [],
    this.contoh,
  });

  final String id;
  final String topikId;
  final String judul;
  final TipeLesson tipe;
  final List<String> penjelasan;

  /// Contoh kalimat matematika yang ditampilkan besar di kartu penjelasan.
  final String? contoh;
}
