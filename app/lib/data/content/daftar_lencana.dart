import '../models/badge.dart';

// Empat lencana pertama mengikuti wireframe halaman progres di doktek.
const daftarLencana = <Lencana>[
  Lencana(id: 'pemula', nama: 'Pemula', ikon: '⭐', syarat: 'Selesaikan lesson pertamamu'),
  Lencana(id: 'rajin', nama: 'Rajin', ikon: '🔥', syarat: 'Belajar 3 hari berturut-turut'),
  Lencana(id: 'cepat', nama: 'Cepat', ikon: '⚡', syarat: 'Selesaikan satu lesson dalam 2 menit'),
  Lencana(id: 'juara', nama: 'Juara', ikon: '🏆', syarat: 'Kuasai satu pulau lewat mastery test'),
  Lencana(id: 'teliti', nama: 'Teliti', ikon: '🎯', syarat: 'Jawab semua soal lesson dengan benar'),
  Lencana(id: 'tekun', nama: 'Tekun', ikon: '🌙', syarat: 'Belajar 7 hari berturut-turut'),
  Lencana(id: 'penjelajah', nama: 'Penjelajah', ikon: '🧭', syarat: 'Kuasai 3 pulau'),
  Lencana(id: 'bintang', nama: 'Bintang Terang', ikon: '🌟', syarat: 'Capai level 5'),
];

Lencana lencanaById(String id) => daftarLencana.firstWhere((l) => l.id == id);
