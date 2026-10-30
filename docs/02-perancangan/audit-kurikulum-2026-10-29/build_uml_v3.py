from pathlib import Path
import json, re

ROOT=Path(__file__).resolve().parent
DEST=ROOT.parent/'uml'/'target-v3-2026-10-29'
(DEST/'src').mkdir(parents=True,exist_ok=True)
(DEST/'png').mkdir(exist_ok=True)
(DEST/'svg').mkdir(exist_ok=True)
style='''skinparam monochrome true
skinparam defaultFontName Arial
skinparam defaultFontSize 16
skinparam shadowing false
skinparam backgroundColor white
skinparam roundCorner 0
skinparam defaultFontColor black
skinparam ArrowColor black
skinparam ArrowFontColor black
skinparam PackageBorderColor black
skinparam PackageBackgroundColor white
skinparam NoteBackgroundColor white
skinparam NoteBorderColor black
skinparam ClassBackgroundColor white
skinparam ClassHeaderBackgroundColor white
skinparam ClassBorderColor black
skinparam StateBackgroundColor white
skinparam StateBorderColor black
skinparam ActivityBackgroundColor white
skinparam ActivityBorderColor black
skinparam ActivityDiamondBackgroundColor white
skinparam ActivityDiamondBorderColor black
skinparam ParticipantBackgroundColor white
skinparam ParticipantBorderColor black
skinparam UsecaseBackgroundColor white
skinparam UsecaseBorderColor black
skinparam ActorBorderColor black
skinparam ActorBackgroundColor white
skinparam EntityBackgroundColor white
skinparam EntityBorderColor black
skinparam ComponentBackgroundColor white
skinparam ComponentBorderColor black
skinparam DatabaseBackgroundColor white
skinparam DatabaseBorderColor black
skinparam SequenceGroupBackgroundColor white
skinparam SequenceGroupBodyBackgroundColor white
skinparam SequenceLifeLineBorderColor black
'''
(DEST/'src'/'_target-style.iuml').write_text(style,encoding='utf-8')
diagrams={
'ucd-002-aktor-target':('UCD-002 Aktor dan tujuan pengguna target v3',r'''
left to right direction
actor Siswa as Anak
actor "Orang tua / wali" as Wali
rectangle "Numi pada perangkat keluarga" {
 usecase "UC-008\nMengisi dan mengubah profil" as Profil
 usecase "UC-001\nMengikuti pemetaan awal" as Diag
 usecase "UC-002 / UC-009\nMelihat peta dan rekomendasi" as Peta
 usecase "UC-003 / UC-004\nBerlatih dan memahami feedback" as Latihan
 usecase "UC-005\nMemeriksa kemampuan mandiri" as Mastery
 usecase "UC-011\nMelanjutkan sesi tersimpan" as Resume
 usecase "UC-012\nMengatur bantuan belajar" as Bantuan
 usecase "UC-013\nMelihat katalog dan cakupan materi" as Katalog
 usecase "UC-006\nMelihat progres dan bukti belajar" as Laporan
}
Anak -- Profil
Anak -- Diag
Anak -- Peta
Anak -- Latihan
Anak -- Mastery
Anak -- Resume
Anak -- Bantuan
Anak -- Katalog
Anak -- Laporan
Wali -- Profil
Wali -- Bantuan
Wali -- Katalog
Wali -- Laporan
note bottom of Laporan
 Wali menggunakan bagian pendamping pada perangkat yang sama.
 Belum ada akun wali atau portal guru terpisah.
end note
note bottom of Mastery
 Guru memvalidasi materi di luar aplikasi.
 Maskot, scheduler internal, controller, dan repository bukan aktor eksternal.
 XP dan checkpoint merupakan perilaku internal yang ditelusuri melalui FR.
end note
'''),
'act-006-alur-belajar-target':('ACT-006 Alur belajar target untuk usia 6-12 tahun',r'''
start
if (Profil sudah ada?) then (belum)
 :Siswa/wali mengisi nama panggilan;
 :Pilih usia 6-12 tahun;
 :Validasi rentang usia dan simpan profil;
endif
:Pilih dukungan tampilan awal;
if (Ada checkpoint?) then (ya)
 :Tawarkan Lanjutkan atau Mulai sesi baru;
else (tidak)
 :Pilih materi aktif dari katalog;
 :Pemetaan awal pada skill yang relevan;
 :Simpan respons pertama per butir;
 :Tandai skill yang belum diuji;
endif
:Peta menampilkan bukti skill dan akses secara terpisah;
:Tawarkan latihan sesuai kebutuhan dan prasyarat;
:Lesson dengan bantuan dan feedback langsung;
:Simpan checkpoint setelah setiap respons;
if (Siap pemeriksaan mandiri?) then (ya)
 :Mastery dengan butir baru tanpa feedback jawaban;
 :Simpan respons dan posisi setiap butir;
 :Nilai setelah blok selesai;
 :Tampilkan bukti awal dan pembahasan;
 :Jadwalkan pemeriksaan ulang sesuai kebijakan pilot;
endif
:Tampilkan progres bertanggal untuk siswa dan wali;
stop
'''),
'seq-007-diagnostic-target':('SEQ-007 Diagnostic berbasis bukti per skill',r'''
autonumber
actor Siswa
participant "Layar pemetaan" as UI
participant "Rencana asesmen" as Plan
participant "Layanan bukti skill" as Bukti
database "Repository lokal" as Repo
Siswa -> UI : pilih materi aktif
UI -> Plan : susun jangkar(skill, versiCP, usia)
note right of Plan
 Usia membantu titik awal dan bahasa.
 Blok awal maksimum 12 butir pada cakupan MVP.
 Tidak mengukur seluruh CP dari satu blok singkat.
end note
loop setiap butir dalam blok
 UI -> Siswa : pertanyaan tanpa kunci jawaban
 Siswa -> UI : respons pertama
 UI -> Repo : simpan respons dan checkpoint
 alt penyimpanan berhasil
  Repo --> UI : konfirmasi tersimpan
 else penyimpanan gagal
  Repo --> UI : gagal simpan
  UI -> Siswa : coba lagi; belum menjanjikan resume
 end
end
UI -> Bukti : rangkum bukti skill yang benar-benar diuji
Bukti --> UI : indikasi awal, jumlah butir, waktu
UI -> Repo : simpan ringkasan
UI -> Siswa : peta dan saran pemeriksaan lanjutan
note over Bukti
 Skill belum diuji tetap Belum diuji.
 Akses materi tidak menetapkan tingkat kemampuan.
end note
'''),
'seq-008-mastery-target':('SEQ-008 Mastery dengan pembahasan setelah blok',r'''
autonumber
actor Siswa
participant "Layar mastery" as UI
participant "Kebijakan asesmen" as Policy
database "Repository lokal" as Repo
UI -> Policy : siapkan 5 butir baru untuk skill sasaran
Policy --> UI : versi butir, urutan tetap, versi kebijakan
loop 5 respons pertama
 UI -> Siswa : tampilkan butir
 Siswa -> UI : pilih dan kirim jawaban
 UI -> Repo : simpan respons + checkpoint secara atomik
 Repo --> UI : berhasil atau gagal simpan
 UI -> Siswa : konfirmasi kiriman tanpa kunci jawaban
end
UI -> Policy : nilai blok respons pertama
alt memenuhi gerbang pilot 5/5
 Policy --> UI : bukti awal tercapai, waktu, kebijakan
else belum memenuhi
 Policy --> UI : rekomendasi skill untuk latihan
end
UI -> Repo : simpan hasil terikat skill dan versi
UI -> Siswa : hasil + pembahasan setelah blok
note over Policy
 Gerbang pilot belum tervalidasi.
 Uji ulang 3-7 hari memakai butir sepadan baru.
 Kelulusan satu skill tidak menguasakan seluruh fase.
end note
'''),
'seq-009-checkpoint-target':('SEQ-009 Simpan respons dan lanjutkan sesi',r'''
autonumber
actor Siswa
participant "Layar sesi" as UI
participant "Controller target" as Ctrl
database "Repository lokal" as Repo
Siswa -> UI : kirim jawaban
UI -> Ctrl : catat(responseId, responsPertama)
Ctrl -> Repo : transaksi respons + nextIndex + versi sesi
alt gagal
 Repo --> Ctrl : error
 Ctrl --> UI : belum tersimpan
 UI -> Siswa : coba lagi dengan responseId sama
else berhasil
 Repo --> Ctrl : committed
 Ctrl --> UI : tersimpan
 UI -> Siswa : lanjut butir berikutnya
end
... aplikasi ditutup dan dibuka kembali ...
UI -> Repo : muat checkpoint
Repo --> UI : itemIds, urutan, nextIndex, bantuan, versi
UI -> Siswa : tawarkan melanjutkan sesi
note over Ctrl,Repo
 Pengiriman ulang harus idempoten.
 Resume tidak membangkitkan ulang butir tes.
 Ini target; repository saat ini belum menyimpan per respons.
end note
'''),
'stm-005-bukti-dan-akses':('STM-005 Bukti kemampuan terpisah dari akses materi',r'''
state "Bukti per skill" as Bukti {
 [*] --> BelumDiuji
 BelumDiuji --> IndikasiLatihan : respons mengindikasikan kesulitan
 BelumDiuji --> IndikasiSiap : bukti penyaringan awal
 IndikasiLatihan --> IndikasiSiap : latihan dan pemeriksaan baru
 IndikasiSiap --> TercapaiAwal : mastery blok memenuhi kebijakan pilot
 TercapaiAwal --> PerluPeriksaUlang : waktu pemeriksaan ulang tiba
 PerluPeriksaUlang --> Terkonfirmasi : bukti ulang memenuhi kebijakan
 PerluPeriksaUlang --> IndikasiLatihan : bukti baru menunjukkan kebutuhan bantuan
 Terkonfirmasi --> PerluPeriksaUlang : bukti perlu diperbarui
}
state "Akses materi" as Akses {
 [*] --> BelumTersedia : konten/validasi belum siap
 BelumTersedia --> Tersedia : konten disetujui dan dirilis
 state Tersedia {
  [*] --> Terkunci
  Terkunci --> Terbuka : prasyarat relevan terpenuhi
 }
}
note bottom of Akses
 Tidak ada transisi Terkunci -> Dikuasai.
 Usia tidak langsung menetapkan bukti kemampuan.
end note
'''),
'stm-006-sesi-tersimpan':('STM-006 Siklus sesi dan kegagalan simpan',r'''
[*] --> Disiapkan
Disiapkan --> Menjawab : item dan versi sudah ditetapkan
Menjawab --> Menyimpan : kirim respons pertama
Menyimpan --> GagalSimpan : repository gagal
GagalSimpan --> Menyimpan : coba lagi dengan responseId sama
Menyimpan --> Menjawab : tersimpan; masih ada butir
Menyimpan --> Selesai : tersimpan; blok selesai
Menjawab --> Ditunda : keluar dari sesi
Ditunda --> Menjawab : lanjut dari checkpoint terakhir
Selesai --> Ditinjau : tampilkan hasil dan pembahasan
Ditinjau --> [*]
note right of Menyimpan
 Sinyal tersimpan hanya setelah commit.
 Penghentian paksa diuji pada setiap batas tulis.
end note
'''),
'cls-004-model-target':('CLS-004 Model target untuk usia cakupan dan bukti',r'''
hide empty methods
class ProfilSiswa {
 id: String
 namaPanggilan: String
 usia: int // 6-12 tahun
 preferensiBantuan: Set
}
class VersiKurikulum { id; nomorCP; tanggalBerlaku }
class Subketerampilan { id; elemen; faseCP; tujuan; prasyarat }
class KetersediaanMateri { status; alasan; versiKonten }
class PrasyaratSkill { skillId; prasyaratId; kriteriaBukti }
class TemplateSoal { id; versi; skillId; representasi; satuan; miskonsepsi }
class ValidasiMateri { validator; waktu; status; catatan }
class SesiAsesmen { id; jenis; policyVersion; itemIds; nextIndex; selesai }
class ResponsPertama { responseId; itemId; jawaban; waktu; bantuan; benar }
class Checkpoint { sessionId; nextIndex; committedAt; schemaVersion }
class BuktiSkill { skillId; statusBukti; jumlahButir; waktu; sumber; retestAt }
class AksesMateri { skillId; statusAkses; alasan }
class KebijakanAsesmen { versi; ukuranBlok; gerbangPilot; jedaUlang }
ProfilSiswa "1" -- "0..*" SesiAsesmen
ProfilSiswa "1" -- "0..*" BuktiSkill
ProfilSiswa "1" -- "0..*" AksesMateri
VersiKurikulum "1" -- "1..*" Subketerampilan
Subketerampilan "1" -- "1" KetersediaanMateri
Subketerampilan "1" -- "0..*" TemplateSoal
Subketerampilan "1" -- "0..*" PrasyaratSkill
TemplateSoal "1" -- "0..*" ValidasiMateri
SesiAsesmen "1" *-- "0..*" ResponsPertama
SesiAsesmen "1" *-- "1" Checkpoint
SesiAsesmen "*" --> "1" KebijakanAsesmen
BuktiSkill "*" --> "1" Subketerampilan
AksesMateri "*" --> "1" Subketerampilan
note bottom of ProfilSiswa
 Nama kelas pada diagram ini adalah rancangan target.
 Belum identik dengan kelas Dart yang diimplementasikan.
end note
'''),
'cmp-002-batas-validasi':('CMP-002 Batas aplikasi dan validasi materi',r'''
top to bottom direction
actor Guru
rectangle "Proses di luar aplikasi" {
 artifact "Peta CP dan ATP sekolah" as CP
 artifact "Template butir dan rubrik" as T
 artifact "Catatan validasi guru" as V
 Guru --> T : periksa konsep dan instruksi
 CP --> T
 T --> V
}
rectangle "Aplikasi Numi target" {
 component "Katalog konten terversi" as K
 component "Layar siswa dan wali" as UI
 component "Layanan bukti dan asesmen" as B
 database "Penyimpanan lokal" as R
 K --> B
 UI --> B
 B --> R
}
V ..> K : gerbang rilis konten
note bottom of V
 Diagram ini tidak menambahkan login guru atau CMS.
 Fitur portal guru/admin memerlukan ruang lingkup dan FR tersendiri.
end note
'''),
'erd-002-data-target':('ERD-002 Rancangan data target bukan migrasi aktif',r'''
hide circle
hide methods
entity ProfilSiswa { * siswaId : string
 --
 usia : int 6-12
 preferensiBantuan : json }
entity Skill { * skillId : string
 --
 versiCP : string
 elemen : string
 fase : string
 prasyaratSkill : json
 ketersediaan : enum }
entity BuktiSkill { * siswaId : FK
 * skillId : FK
 --
 statusBukti : enum
 jumlahButir : int
 dicatatPada : datetime
 policyVersion : string }
entity AksesMateri { * siswaId : FK
 * skillId : FK
 --
 statusAkses : enum
 alasan : string }
entity Sesi { * sessionId : string
 --
 siswaId : FK
 itemIdsDanVersi : json
 policyVersion : string }
entity Respons { * responseId : string
 --
 sessionId : FK
 itemId : string
 ordinal : int
 responsPertama : json
 bantuan : json
 waktu : datetime }
entity Checkpoint { * sessionId : FK
 --
 nextIndex : int
 committedAt : datetime
 schemaVersion : int }
ProfilSiswa ||--o{ Sesi
ProfilSiswa ||--o{ BuktiSkill
ProfilSiswa ||--o{ AksesMateri
Skill ||--o{ BuktiSkill
Skill ||--o{ AksesMateri
Sesi ||--o{ Respons
Sesi ||--|| Checkpoint
note bottom of Respons
 Unik(sessionId, itemId, ordinal) untuk respons pertama.
 Respons dan checkpoint ditulis atomik dan idempoten.
end note
''')}
for name,(title,body)in diagrams.items():
 body=re.sub(r'((?:class|entity) [^\n{]+)\{([^{}\n]+)\}',lambda m:m[1]+'{\n'+m[2].replace(';','\n')+'\n}',body)
 body=re.sub(r'\{[ \t]+(?=\*)','{\n',body)
 body=re.sub(r'([^\n{}]+) }',r'\1\n}',body)
 (DEST/'src'/f'{name}.puml').write_text('@startuml '+name+'\n!include _target-style.iuml\ntitle '+title+'\n'+body+'\n@enduml\n',encoding='utf-8')
(ROOT/'uml-v3-manifest.json').write_text(json.dumps([{'id':name.split('-')[0].upper()+'-'+name.split('-')[1],'name':title,'source':str(DEST/'src'/f'{name}.puml'),'png':str(DEST/'png'/f'{name}.png')} for name,(title,_)in diagrams.items()],ensure_ascii=False,indent=2),encoding='utf-8')
print('Menulis',len(diagrams),'diagram target pada',DEST)
