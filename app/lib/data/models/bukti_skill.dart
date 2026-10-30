enum StatusBukti { indikasiLatihan, indikasiSiap, buktiAwal }

/// Bukti hanya berlaku pada sampel butir yang dicatat, bukan seluruh fase.
class BuktiSkill {
  const BuktiSkill({
    required this.topikId,
    required this.skillId,
    required this.status,
    required this.benar,
    required this.total,
    required this.bantuan,
    required this.sumberSesi,
    required this.waktu,
    required this.versiKebijakan,
    required this.versiButir,
  });
  final String topikId, skillId, sumberSesi, versiKebijakan;
  final StatusBukti status;
  final int benar, total, bantuan;
  final DateTime waktu;
  final List<String> versiButir;
  bool get siap => status != StatusBukti.indikasiLatihan;
  String get label => switch (status) {
    StatusBukti.indikasiLatihan => 'Perlu latihan',
    StatusBukti.indikasiSiap => 'Siap lanjut',
    StatusBukti.buktiAwal => 'Bukti awal',
  };

  Map<String, dynamic> toJson() => {
    'topikId': topikId,
    'skillId': skillId,
    'status': status.name,
    'benar': benar,
    'total': total,
    'bantuan': bantuan,
    'sumberSesi': sumberSesi,
    'waktu': waktu.toIso8601String(),
    'versiKebijakan': versiKebijakan,
    'versiButir': versiButir,
  };

  factory BuktiSkill.fromJson(Map<String, dynamic> json) {
    final total = json['total'] as int;
    final benar = json['benar'] as int;
    final bantuan = json['bantuan'] as int;
    final status = StatusBukti.values.byName(json['status'] as String);
    if (total < 1 || benar < 0 || benar > total || bantuan < 0) {
      throw const FormatException('Jumlah bukti tidak sah.');
    }
    if (status == StatusBukti.buktiAwal &&
            (total != 5 || benar != 5 || bantuan != 0) ||
        status == StatusBukti.indikasiSiap &&
            (benar != total || bantuan != 0)) {
      throw const FormatException('Status bukti tidak sesuai respons.');
    }
    return BuktiSkill(
      topikId: json['topikId'] as String,
      skillId: json['skillId'] as String,
      status: status,
      benar: benar,
      total: total,
      bantuan: bantuan,
      sumberSesi: json['sumberSesi'] as String,
      waktu: DateTime.parse(json['waktu'] as String),
      versiKebijakan: json['versiKebijakan'] as String,
      versiButir: List<String>.from(json['versiButir'] as List),
    );
  }
}

class AksesMateri {
  const AksesMateri({
    required this.topikId,
    required this.terbuka,
    required this.alasan,
    this.tersedia = true,
  });
  final String topikId, alasan;
  final bool terbuka, tersedia;
  Map<String, dynamic> toJson() => {
    'topikId': topikId,
    'terbuka': terbuka,
    'alasan': alasan,
    'tersedia': tersedia,
  };
  factory AksesMateri.fromJson(Map<String, dynamic> json) => AksesMateri(
    topikId: json['topikId'] as String,
    terbuka: json['terbuka'] as bool,
    alasan: json['alasan'] as String,
    tersedia: json['tersedia'] as bool? ?? true,
  );
}
