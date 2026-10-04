/// Kejadian yang membuat maskot muncul (FR-009).
enum JenisTrigger {
  sambutan,
  streakTerancam,
  lamaTidakAktif,
  lessonSelesai,
  lessonGagal,
  masteryLulus,
  masteryGagal,
  badgeBaru,
  levelNaik,
}

/// Ekspresi maskot. Tiap ekspresi punya gambar sendiri di NumiMascot.
enum EkspresiMaskot { senang, berpikir, semangat, sedih, mengantuk, bangga }

/// Entitas CompanionMessage.
class CompanionMessage {
  const CompanionMessage({
    required this.id,
    required this.trigger,
    required this.isi,
    required this.ekspresi,
    required this.waktuKirim,
    this.dibaca = false,
  });

  final String id;
  final JenisTrigger trigger;
  final String isi;
  final EkspresiMaskot ekspresi;
  final DateTime waktuKirim;
  final bool dibaca;

  CompanionMessage tandaiDibaca() => CompanionMessage(
        id: id,
        trigger: trigger,
        isi: isi,
        ekspresi: ekspresi,
        waktuKirim: waktuKirim,
        dibaca: true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'trigger': trigger.name,
        'isi': isi,
        'ekspresi': ekspresi.name,
        'waktuKirim': waktuKirim.toIso8601String(),
        'dibaca': dibaca,
      };

  factory CompanionMessage.fromJson(Map<String, dynamic> json) => CompanionMessage(
        id: json['id'] as String,
        trigger: JenisTrigger.values.byName(json['trigger'] as String),
        isi: json['isi'] as String,
        ekspresi: EkspresiMaskot.values.byName(json['ekspresi'] as String),
        waktuKirim: DateTime.parse(json['waktuKirim'] as String),
        dibaca: json['dibaca'] as bool? ?? false,
      );
}
