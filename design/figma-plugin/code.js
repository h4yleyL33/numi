"use strict";
(() => {
  var __defProp = Object.defineProperty;
  var __defProps = Object.defineProperties;
  var __getOwnPropDescs = Object.getOwnPropertyDescriptors;
  var __getOwnPropSymbols = Object.getOwnPropertySymbols;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __propIsEnum = Object.prototype.propertyIsEnumerable;
  var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __spreadValues = (a, b) => {
    for (var prop in b || (b = {}))
      if (__hasOwnProp.call(b, prop))
        __defNormalProp(a, prop, b[prop]);
    if (__getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(b)) {
        if (__propIsEnum.call(b, prop))
          __defNormalProp(a, prop, b[prop]);
      }
    return a;
  };
  var __spreadProps = (a, b) => __defProps(a, __getOwnPropDescs(b));

  // ../barang/barang.json
  var barang_default = {
    _catatan: "Daftar barang esensial yang perlu dikenal anak SD. Dipakai plugin Figma (page per tema) dan nanti oleh generator soal (soal hitung benda, pecahan, soal cerita). kelas: 'kecil' = wajib dikenal kelas 1-3, 'besar' = dikenalkan di kelas 4-6. pakai = contoh pemakaian di soal.",
    tema: [
      {
        id: "stationery",
        nama: "Alat Tulis",
        warna: "#4FC3F7",
        barang: [
          { id: "pensil", nama: "Pensil", en: "Pencil", kelas: "kecil", pakai: "hitung benda, panjang" },
          { id: "penghapus", nama: "Penghapus", en: "Eraser", kelas: "kecil", pakai: "hitung benda" },
          { id: "rautan", nama: "Rautan", en: "Sharpener", kelas: "kecil", pakai: "hitung benda" },
          { id: "pulpen", nama: "Pulpen", en: "Pen", kelas: "kecil", pakai: "hitung benda" },
          { id: "buku-tulis", nama: "Buku tulis", en: "Notebook", kelas: "kecil", pakai: "harga, soal cerita" },
          { id: "penggaris", nama: "Penggaris", en: "Ruler", kelas: "kecil", pakai: "panjang, nilai tempat" },
          { id: "krayon", nama: "Krayon", en: "Crayon", kelas: "kecil", pakai: "hitung, kelompok warna" },
          { id: "spidol", nama: "Spidol", en: "Marker", kelas: "kecil", pakai: "hitung benda" },
          { id: "gunting", nama: "Gunting", en: "Scissors", kelas: "kecil", pakai: "pecahan (memotong)" },
          { id: "lem", nama: "Lem", en: "Glue", kelas: "kecil", pakai: "hitung benda" },
          { id: "tas", nama: "Tas sekolah", en: "School bag", kelas: "kecil", pakai: "wadah kelompok" },
          { id: "kotak-pensil", nama: "Kotak pensil", en: "Pencil case", kelas: "kecil", pakai: "wadah kelompok, perkalian" },
          { id: "kertas", nama: "Kertas", en: "Paper", kelas: "kecil", pakai: "pecahan (melipat)" },
          { id: "jangka", nama: "Jangka", en: "Compass", kelas: "besar", pakai: "soal cerita" },
          { id: "busur", nama: "Busur derajat", en: "Protractor", kelas: "besar", pakai: "soal cerita" },
          { id: "kalkulator", nama: "Kalkulator", en: "Calculator", kelas: "besar", pakai: "soal cerita uang" }
        ]
      },
      {
        id: "makanan",
        nama: "Makanan dan Minuman",
        warna: "#FF8A3D",
        barang: [
          { id: "nasi", nama: "Nasi", en: "Rice", kelas: "kecil", pakai: "porsi, pecahan" },
          { id: "roti", nama: "Roti", en: "Bread", kelas: "kecil", pakai: "pecahan (dipotong)" },
          { id: "telur", nama: "Telur", en: "Egg", kelas: "kecil", pakai: "hitung, lusin" },
          { id: "susu", nama: "Susu", en: "Milk", kelas: "kecil", pakai: "liter, pecahan" },
          { id: "air", nama: "Air minum", en: "Water", kelas: "kecil", pakai: "liter" },
          { id: "kue", nama: "Kue", en: "Cake", kelas: "kecil", pakai: "pecahan setengah, seperempat" },
          { id: "donat", nama: "Donat", en: "Doughnut", kelas: "kecil", pakai: "hitung, pembagian" },
          { id: "permen", nama: "Permen", en: "Candy", kelas: "kecil", pakai: "hitung, pembagian rata" },
          { id: "biskuit", nama: "Biskuit", en: "Biscuit", kelas: "kecil", pakai: "hitung, perkalian (per bungkus)" },
          { id: "pisang-goreng", nama: "Pisang goreng", en: "Fried banana", kelas: "kecil", pakai: "harga jajan" },
          { id: "bakso", nama: "Bakso", en: "Meatball soup", kelas: "kecil", pakai: "hitung butir, harga" },
          { id: "sate", nama: "Sate", en: "Satay", kelas: "kecil", pakai: "tusuk berisi kelompok (perkalian)" },
          { id: "tempe", nama: "Tempe", en: "Tempeh", kelas: "kecil", pakai: "pecahan (dipotong)" },
          { id: "tahu", nama: "Tahu", en: "Tofu", kelas: "kecil", pakai: "hitung" },
          { id: "es-krim", nama: "Es krim", en: "Ice cream", kelas: "kecil", pakai: "harga jajan" },
          { id: "pizza", nama: "Pizza", en: "Pizza", kelas: "besar", pakai: "pecahan senilai" },
          { id: "martabak", nama: "Martabak", en: "Martabak", kelas: "besar", pakai: "pecahan, potongan" },
          { id: "teh", nama: "Teh", en: "Tea", kelas: "kecil", pakai: "gelas, liter" }
        ]
      },
      {
        id: "hewan",
        nama: "Hewan Peliharaan dan Ternak",
        warna: "#2EBD8E",
        barang: [
          { id: "kucing", nama: "Kucing", en: "Cat", kelas: "kecil", pakai: "hitung, kaki (perkalian 4)" },
          { id: "anjing", nama: "Anjing", en: "Dog", kelas: "kecil", pakai: "hitung, kaki" },
          { id: "ikan-hias", nama: "Ikan hias", en: "Goldfish", kelas: "kecil", pakai: "hitung dalam akuarium" },
          { id: "burung", nama: "Burung", en: "Bird", kelas: "kecil", pakai: "hitung, kaki (perkalian 2)" },
          { id: "kelinci", nama: "Kelinci", en: "Rabbit", kelas: "kecil", pakai: "hitung" },
          { id: "hamster", nama: "Hamster", en: "Hamster", kelas: "kecil", pakai: "hitung" },
          { id: "ayam", nama: "Ayam", en: "Chicken", kelas: "kecil", pakai: "telur per hari (perkalian)" },
          { id: "bebek", nama: "Bebek", en: "Duck", kelas: "kecil", pakai: "hitung, berbaris" },
          { id: "sapi", nama: "Sapi", en: "Cow", kelas: "kecil", pakai: "liter susu" },
          { id: "kambing", nama: "Kambing", en: "Goat", kelas: "kecil", pakai: "hitung, kaki" },
          { id: "domba", nama: "Domba", en: "Sheep", kelas: "kecil", pakai: "hitung" },
          { id: "kuda", nama: "Kuda", en: "Horse", kelas: "kecil", pakai: "hitung" },
          { id: "kerbau", nama: "Kerbau", en: "Water buffalo", kelas: "kecil", pakai: "hitung di sawah" },
          { id: "kura-kura", nama: "Kura-kura", en: "Turtle", kelas: "kecil", pakai: "hitung" },
          { id: "kupu-kupu", nama: "Kupu-kupu", en: "Butterfly", kelas: "kecil", pakai: "perkalian (Pulau Kupu-kupu)" },
          { id: "semut", nama: "Semut", en: "Ant", kelas: "kecil", pakai: "berbaris, kelipatan" },
          { id: "lebah", nama: "Lebah", en: "Bee", kelas: "kecil", pakai: "hitung" },
          { id: "kunang-kunang", nama: "Kunang-kunang", en: "Firefly", kelas: "kecil", pakai: "maskot Numi" }
        ]
      },
      {
        id: "buah-sayur",
        nama: "Buah dan Sayur",
        warna: "#6CC47A",
        barang: [
          { id: "apel", nama: "Apel", en: "Apple", kelas: "kecil", pakai: "hitung benda" },
          { id: "pisang", nama: "Pisang", en: "Banana", kelas: "kecil", pakai: "sisir (kelompok)" },
          { id: "jeruk", nama: "Jeruk", en: "Orange", kelas: "kecil", pakai: "hitung, pecahan (juring)" },
          { id: "mangga", nama: "Mangga", en: "Mango", kelas: "kecil", pakai: "hitung, harga per kg" },
          { id: "semangka", nama: "Semangka", en: "Watermelon", kelas: "kecil", pakai: "pecahan (Pulau Semangka)" },
          { id: "anggur", nama: "Anggur", en: "Grapes", kelas: "kecil", pakai: "hitung butir" },
          { id: "stroberi", nama: "Stroberi", en: "Strawberry", kelas: "kecil", pakai: "hitung" },
          { id: "pepaya", nama: "Pepaya", en: "Papaya", kelas: "kecil", pakai: "pecahan" },
          { id: "nanas", nama: "Nanas", en: "Pineapple", kelas: "kecil", pakai: "pecahan" },
          { id: "kelapa", nama: "Kelapa", en: "Coconut", kelas: "kecil", pakai: "nilai tempat (Pulau Kelapa)" },
          { id: "rambutan", nama: "Rambutan", en: "Rambutan", kelas: "kecil", pakai: "hitung, ikat" },
          { id: "durian", nama: "Durian", en: "Durian", kelas: "besar", pakai: "harga, soal cerita" },
          { id: "salak", nama: "Salak", en: "Snake fruit", kelas: "kecil", pakai: "hitung" },
          { id: "wortel", nama: "Wortel", en: "Carrot", kelas: "kecil", pakai: "hitung" },
          { id: "tomat", nama: "Tomat", en: "Tomato", kelas: "kecil", pakai: "hitung" },
          { id: "jagung", nama: "Jagung", en: "Corn", kelas: "kecil", pakai: "hitung" },
          { id: "kangkung", nama: "Kangkung", en: "Water spinach", kelas: "kecil", pakai: "ikat, harga" },
          { id: "bayam", nama: "Bayam", en: "Spinach", kelas: "kecil", pakai: "ikat" },
          { id: "kentang", nama: "Kentang", en: "Potato", kelas: "kecil", pakai: "berat (kg)" },
          { id: "cabai", nama: "Cabai", en: "Chili", kelas: "kecil", pakai: "hitung" },
          { id: "terong", nama: "Terong", en: "Eggplant", kelas: "kecil", pakai: "hitung" },
          { id: "timun", nama: "Timun", en: "Cucumber", kelas: "kecil", pakai: "pecahan (diiris)" }
        ]
      },
      {
        id: "planet",
        nama: "Tata Surya",
        warna: "#7C5CFF",
        barang: [
          { id: "matahari", nama: "Matahari", en: "Sun", kelas: "kecil", pakai: "urutan" },
          { id: "merkurius", nama: "Merkurius", en: "Mercury", kelas: "besar", pakai: "urutan ke-1" },
          { id: "venus", nama: "Venus", en: "Venus", kelas: "besar", pakai: "urutan ke-2" },
          { id: "bumi", nama: "Bumi", en: "Earth", kelas: "kecil", pakai: "urutan ke-3" },
          { id: "mars", nama: "Mars", en: "Mars", kelas: "besar", pakai: "urutan ke-4" },
          { id: "jupiter", nama: "Jupiter", en: "Jupiter", kelas: "besar", pakai: "terbesar, membandingkan" },
          { id: "saturnus", nama: "Saturnus", en: "Saturn", kelas: "besar", pakai: "urutan ke-6" },
          { id: "uranus", nama: "Uranus", en: "Uranus", kelas: "besar", pakai: "urutan ke-7" },
          { id: "neptunus", nama: "Neptunus", en: "Neptune", kelas: "besar", pakai: "urutan ke-8" },
          { id: "bulan", nama: "Bulan", en: "Moon", kelas: "kecil", pakai: "fase bulan (pecahan)" },
          { id: "bintang", nama: "Bintang", en: "Star", kelas: "kecil", pakai: "hitung, XP" },
          { id: "komet", nama: "Komet", en: "Comet", kelas: "besar", pakai: "KPK (muncul berkala)" },
          { id: "roket", nama: "Roket", en: "Rocket", kelas: "kecil", pakai: "hitung mundur" },
          { id: "astronot", nama: "Astronot", en: "Astronaut", kelas: "kecil", pakai: "tokoh soal cerita" }
        ]
      },
      {
        id: "sekitar-rumah",
        nama: "Barang di Sekitar Rumah",
        warna: "#F4A340",
        barang: [
          { id: "kursi", nama: "Kursi", en: "Chair", kelas: "kecil", pakai: "hitung, kaki (perkalian 4)" },
          { id: "meja", nama: "Meja", en: "Table", kelas: "kecil", pakai: "hitung" },
          { id: "lemari", nama: "Lemari", en: "Wardrobe", kelas: "kecil", pakai: "rak (kelompok)" },
          { id: "kasur", nama: "Kasur", en: "Bed", kelas: "kecil", pakai: "hitung" },
          { id: "bantal", nama: "Bantal", en: "Pillow", kelas: "kecil", pakai: "hitung, pasangan" },
          { id: "jam-dinding", nama: "Jam dinding", en: "Wall clock", kelas: "kecil", pakai: "waktu, pecahan (setengah jam)" },
          { id: "lampu", nama: "Lampu", en: "Lamp", kelas: "kecil", pakai: "KPK (berkedip)" },
          { id: "televisi", nama: "Televisi", en: "Television", kelas: "kecil", pakai: "harga" },
          { id: "kipas", nama: "Kipas angin", en: "Fan", kelas: "kecil", pakai: "hitung baling-baling" },
          { id: "piring", nama: "Piring", en: "Plate", kelas: "kecil", pakai: "wadah pembagian rata" },
          { id: "gelas", nama: "Gelas", en: "Glass", kelas: "kecil", pakai: "liter, pecahan isi" },
          { id: "sendok", nama: "Sendok", en: "Spoon", kelas: "kecil", pakai: "hitung, pasangan dengan garpu" },
          { id: "garpu", nama: "Garpu", en: "Fork", kelas: "kecil", pakai: "hitung" },
          { id: "panci", nama: "Panci", en: "Pot", kelas: "kecil", pakai: "wadah" },
          { id: "kulkas", nama: "Kulkas", en: "Refrigerator", kelas: "kecil", pakai: "rak (kelompok)" },
          { id: "sapu", nama: "Sapu", en: "Broom", kelas: "kecil", pakai: "hitung" },
          { id: "ember", nama: "Ember", en: "Bucket", kelas: "kecil", pakai: "liter" },
          { id: "sepatu", nama: "Sepatu", en: "Shoes", kelas: "kecil", pakai: "pasangan (kelipatan 2)" },
          { id: "kaos-kaki", nama: "Kaos kaki", en: "Socks", kelas: "kecil", pakai: "pasangan" },
          { id: "pintu", nama: "Pintu", en: "Door", kelas: "kecil", pakai: "hitung" },
          { id: "jendela", nama: "Jendela", en: "Window", kelas: "kecil", pakai: "kotak (perkalian baris \xD7 kolom)" },
          { id: "sepeda", nama: "Sepeda", en: "Bicycle", kelas: "kecil", pakai: "roda (perkalian 2)" },
          { id: "mobil", nama: "Mobil", en: "Car", kelas: "kecil", pakai: "roda (perkalian 4)" },
          { id: "uang-koin", nama: "Uang koin", en: "Coin", kelas: "kecil", pakai: "nilai uang" },
          { id: "uang-kertas", nama: "Uang kertas", en: "Banknote", kelas: "besar", pakai: "kembalian (T10)" },
          { id: "celengan", nama: "Celengan", en: "Piggy bank", kelas: "kecil", pakai: "menabung, penjumlahan" }
        ]
      },
      {
        id: "wildlife",
        nama: "Hewan Liar",
        warna: "#243B8F",
        barang: [
          { id: "gajah", nama: "Gajah", en: "Elephant", kelas: "kecil", pakai: "membandingkan besar" },
          { id: "harimau", nama: "Harimau", en: "Tiger", kelas: "kecil", pakai: "hitung" },
          { id: "singa", nama: "Singa", en: "Lion", kelas: "kecil", pakai: "hitung" },
          { id: "jerapah", nama: "Jerapah", en: "Giraffe", kelas: "kecil", pakai: "membandingkan tinggi" },
          { id: "zebra", nama: "Zebra", en: "Zebra", kelas: "kecil", pakai: "pola belang" },
          { id: "monyet", nama: "Monyet", en: "Monkey", kelas: "kecil", pakai: "pembagian pisang" },
          { id: "orangutan", nama: "Orangutan", en: "Orangutan", kelas: "kecil", pakai: "hewan asli Indonesia" },
          { id: "komodo", nama: "Komodo", en: "Komodo dragon", kelas: "kecil", pakai: "hewan asli Indonesia" },
          { id: "badak", nama: "Badak", en: "Rhinoceros", kelas: "kecil", pakai: "hitung cula" },
          { id: "beruang", nama: "Beruang", en: "Bear", kelas: "kecil", pakai: "hitung" },
          { id: "rusa", nama: "Rusa", en: "Deer", kelas: "kecil", pakai: "hitung" },
          { id: "buaya", nama: "Buaya", en: "Crocodile", kelas: "kecil", pakai: "simbol < dan > (membandingkan)" },
          { id: "ular", nama: "Ular", en: "Snake", kelas: "kecil", pakai: "panjang" },
          { id: "katak", nama: "Katak", en: "Frog", kelas: "kecil", pakai: "lompat garis bilangan" },
          { id: "burung-hantu", nama: "Burung hantu", en: "Owl", kelas: "kecil", pakai: "tokoh malam" },
          { id: "elang", nama: "Elang", en: "Eagle", kelas: "kecil", pakai: "hitung" },
          { id: "paus", nama: "Paus", en: "Whale", kelas: "kecil", pakai: "membandingkan besar, laut" },
          { id: "lumba-lumba", nama: "Lumba-lumba", en: "Dolphin", kelas: "kecil", pakai: "tokoh laut" },
          { id: "penyu", nama: "Penyu", en: "Sea turtle", kelas: "kecil", pakai: "telur (hitung)" },
          { id: "gurita", nama: "Gurita", en: "Octopus", kelas: "kecil", pakai: "lengan (perkalian 8)" },
          { id: "kepiting", nama: "Kepiting", en: "Crab", kelas: "kecil", pakai: "kaki (perkalian)" },
          { id: "bintang-laut", nama: "Bintang laut", en: "Starfish", kelas: "kecil", pakai: "lengan (perkalian 5)" }
        ]
      }
    ]
  };

  // ../maskot/numi-senang.svg
  var numi_senang_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M135 151.9 A15.1 10.8 0 0 1 105 151.9" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n</svg>\n';

  // ../wajah/wajah-senang.svg
  var wajah_senang_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M67.7 69 A7.8 5.5 0 0 1 52.3 69" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n</svg>\n';

  // ../maskot/numi-berpikir.svg
  var numi_berpikir_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="127.2" cy="151.7" r="5" fill="#2A2350"/>\n</svg>\n';

  // ../wajah/wajah-berpikir.svg
  var wajah_berpikir_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="63.7" cy="68.9" r="2.6" fill="#2A2350"/>\n</svg>\n';

  // ../maskot/numi-semangat.svg
  var numi_semangat_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<path d="M81.1 97.7 A11.5 6.5 0 0 1 104.2 97.7" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M135.8 97.7 A11.5 6.5 0 0 1 158.9 97.7" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M102.7 147.4 Q120 177.6 137.3 147.4 Z" fill="#2A2350"/>\n<circle cx="120" cy="159.6" r="5" fill="#FF7A85"/>\n</svg>\n';

  // ../wajah/wajah-semangat.svg
  var wajah_semangat_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<path d="M40 41.1 A5.9 3.3 0 0 1 51.9 41.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M68.1 41.1 A5.9 3.3 0 0 1 80 41.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M51.1 66.7 Q60 82.2 68.9 66.7 Z" fill="#2A2350"/>\n<circle cx="60" cy="73" r="2.6" fill="#FF7A85"/>\n</svg>\n';

  // ../maskot/numi-sedih.svg
  var numi_sedih_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<path d="M105 94.8 L83.1 109.2" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M135 94.8 L156.9 109.2" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M107.3 157.2 A13 8.6 0 0 1 132.7 157.2" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n</svg>\n';

  // ../wajah/wajah-sedih.svg
  var wajah_sedih_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<path d="M52.3 39.6 L41 47.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M67.7 39.6 L79 47.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M53.5 71.7 A6.7 4.4 0 0 1 66.5 71.7" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n</svg>\n';

  // ../maskot/numi-mengantuk.svg
  var numi_mengantuk_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.2025"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="0.45"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.405"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.1575"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.1575"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<path d="M81.8 123.6 A10.8 6.5 0 0 0 103.4 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M136.6 123.6 A10.8 6.5 0 0 0 158.2 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<ellipse cx="120" cy="152.4" rx="5.8" ry="7.2" fill="#2A2350"/>\n</svg>\n';

  // ../wajah/wajah-mengantuk.svg
  var wajah_mengantuk_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<path d="M40.4 54.5 A5.5 3.3 0 0 0 51.5 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M68.5 54.5 A5.5 3.3 0 0 0 79.6 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<ellipse cx="60" cy="69.3" rx="3" ry="3.7" fill="#2A2350"/>\n</svg>\n';

  // ../maskot/numi-bangga.svg
  var numi_bangga_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<path d="M81.8 123.6 A10.8 9.4 0 0 1 103.4 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M136.6 123.6 A10.8 9.4 0 0 1 158.2 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M102.7 147.4 Q120 177.6 137.3 147.4 Z" fill="#2A2350"/>\n<circle cx="120" cy="159.6" r="5" fill="#FF7A85"/>\n</svg>\n';

  // ../wajah/wajah-bangga.svg
  var wajah_bangga_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<path d="M40.4 54.5 A5.5 4.8 0 0 1 51.5 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M68.5 54.5 A5.5 4.8 0 0 1 79.6 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M51.1 66.7 Q60 82.2 68.9 66.7 Z" fill="#2A2350"/>\n<circle cx="60" cy="73" r="2.6" fill="#FF7A85"/>\n</svg>\n';

  // ../maskot/numi-terkejut.svg
  var numi_terkejut_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<circle cx="92.6" cy="123.6" r="12.2" fill="#FFFFFF" stroke="#2A2350" stroke-width="3.6"/>\n<circle cx="92.6" cy="123.6" r="5.8" fill="#2A2350"/>\n<circle cx="147.4" cy="123.6" r="12.2" fill="#FFFFFF" stroke="#2A2350" stroke-width="3.6"/>\n<circle cx="147.4" cy="123.6" r="5.8" fill="#2A2350"/>\n<path d="M82.6 95.5 Q92.6 87.6 102.7 95.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M137.3 95.5 Q147.4 87.6 157.4 95.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<ellipse cx="120" cy="156" rx="7.2" ry="9.4" fill="#2A2350"/>\n</svg>\n';

  // ../wajah/wajah-terkejut.svg
  var wajah_terkejut_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<circle cx="45.9" cy="54.5" r="6.3" fill="#FFFFFF" stroke="#2A2350" stroke-width="1.9"/>\n<circle cx="45.9" cy="54.5" r="3" fill="#2A2350"/>\n<circle cx="74.1" cy="54.5" r="6.3" fill="#FFFFFF" stroke="#2A2350" stroke-width="1.9"/>\n<circle cx="74.1" cy="54.5" r="3" fill="#2A2350"/>\n<path d="M40.8 40 Q45.9 36 51.1 40" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M68.9 40 Q74.1 36 79.2 40" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<ellipse cx="60" cy="71.1" rx="3.7" ry="4.8" fill="#2A2350"/>\n</svg>\n';

  // ../maskot/numi-tertawa.svg
  var numi_tertawa_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<path d="M81.8 126.5 Q92.6 109.2 103.4 126.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M136.6 126.5 Q147.4 109.2 158.2 126.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M101.3 145.9 Q120 182.6 138.7 145.9 Z" fill="#2A2350"/>\n<ellipse cx="120" cy="162.5" rx="7.9" ry="4.3" fill="#FF7A85"/>\n</svg>\n';

  // ../wajah/wajah-tertawa.svg
  var wajah_tertawa_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<path d="M40.4 55.9 Q45.9 47.1 51.5 55.9" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M68.5 55.9 Q74.1 47.1 79.6 55.9" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M50.4 65.9 Q60 84.8 69.6 65.9 Z" fill="#2A2350"/>\n<ellipse cx="60" cy="74.4" rx="4.1" ry="2.2" fill="#FF7A85"/>\n</svg>\n';

  // ../maskot/numi-kagum.svg
  var numi_kagum_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<path d="M92.6 109.9 L96 118.9 L105.7 119.4 L98.1 125.4 L100.7 134.7 L92.6 129.4 L84.6 134.7 L87.2 125.4 L79.6 119.4 L89.3 118.9 Z" fill="#2A2350"/>\n<circle cx="95.5" cy="120" r="2.5" fill="#FFFFFF"/>\n<path d="M147.4 109.9 L150.7 118.9 L160.4 119.4 L152.8 125.4 L155.4 134.7 L147.4 129.4 L139.3 134.7 L141.9 125.4 L134.3 119.4 L144 118.9 Z" fill="#2A2350"/>\n<circle cx="150.2" cy="120" r="2.5" fill="#FFFFFF"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M101.3 145.9 Q120 182.6 138.7 145.9 Z" fill="#2A2350"/>\n<ellipse cx="120" cy="162.5" rx="7.9" ry="4.3" fill="#FF7A85"/>\n</svg>\n';

  // ../wajah/wajah-kagum.svg
  var wajah_kagum_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<path d="M45.9 47.4 L47.7 52.1 L52.6 52.3 L48.8 55.4 L50.1 60.1 L45.9 57.4 L41.8 60.1 L43.1 55.4 L39.3 52.3 L44.2 52.1 Z" fill="#2A2350"/>\n<circle cx="47.4" cy="52.6" r="1.3" fill="#FFFFFF"/>\n<path d="M74.1 47.4 L75.8 52.1 L80.7 52.3 L76.9 55.4 L78.2 60.1 L74.1 57.4 L69.9 60.1 L71.2 55.4 L67.4 52.3 L72.3 52.1 Z" fill="#2A2350"/>\n<circle cx="75.5" cy="52.6" r="1.3" fill="#FFFFFF"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M50.4 65.9 Q60 84.8 69.6 65.9 Z" fill="#2A2350"/>\n<ellipse cx="60" cy="74.4" rx="4.1" ry="2.2" fill="#FF7A85"/>\n</svg>\n';

  // ../maskot/numi-tidur.svg
  var numi_tidur_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.135"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="0.3"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.27"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.105"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.105"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<path d="M81.8 123.6 A10.8 6.5 0 0 0 103.4 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M136.6 123.6 A10.8 6.5 0 0 0 158.2 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M114.2 154.6 Q120 158.9 125.8 154.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M171.8 89.8 H183.4 L171.8 101.3 H183.4" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M188.4 69.6 H197 L188.4 78.2 H197" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<path d="M200.6 53.8 H207.1 L200.6 60.2 H207.1" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n</svg>\n';

  // ../wajah/wajah-tidur.svg
  var wajah_tidur_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<path d="M40.4 54.5 A5.5 3.3 0 0 0 51.5 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M68.5 54.5 A5.5 3.3 0 0 0 79.6 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M57 70.4 Q60 72.6 63 70.4" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M86.6 37.1 H92.6 L86.6 43 H92.6" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M95.2 26.7 H99.6 L95.2 31.1 H99.6" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<path d="M101.4 18.6 H104.8 L101.4 21.9 H104.8" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n</svg>\n';

  // ../maskot/numi-mengedip.svg
  var numi_mengedip_default = '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">\n<defs>\n  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>\n  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>\n</defs>\n<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>\n<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>\n<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>\n<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>\n<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>\n<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>\n<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>\n<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>\n<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>\n<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>\n<path d="M136.6 126.5 Q147.4 109.2 158.2 126.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M135 151.9 A15.1 10.8 0 0 1 105 151.9" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>\n</svg>\n';

  // ../wajah/wajah-mengedip.svg
  var wajah_mengedip_default = '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">\n<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>\n<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>\n<path d="M68.5 55.9 Q74.1 47.1 79.6 55.9" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>\n<path d="M67.7 69 A7.8 5.5 0 0 1 52.3 69" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>\n</svg>\n';

  // ../aset/perahu.svg
  var perahu_default = '<svg xmlns="http://www.w3.org/2000/svg" width="160" height="140" viewBox="0 0 160 140">\n<path d="M80 18 L80 92" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>\n<path d="M84 22 L132 86 L84 86 Z" fill="#FFFFFF"/>\n<path d="M76 34 L36 86 L76 86 Z" fill="#FFD98A"/>\n<path d="M20 94 H140 L124 118 H36 Z" fill="#E07A5F"/>\n<path d="M28 104 H132" stroke="#FFFFFF" stroke-opacity="0.5" stroke-width="4"/>\n<path d="M4 124 Q24 114 44 124 T84 124 T124 124 T164 124" fill="none" stroke="#4FC3F7" stroke-width="5" stroke-linecap="round"/>\n</svg>\n';

  // ../aset/benda/apel.svg
  var apel_default = '<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" viewBox="0 0 72 72">\n<circle cx="36" cy="44" r="24" fill="#FF6B6B"/>\n<circle cx="28" cy="36" r="6" fill="#FFFFFF" fill-opacity="0.5"/>\n<path d="M36 20 Q38 12 44 10" fill="none" stroke="#6B4F3A" stroke-width="4" stroke-linecap="round"/>\n<ellipse cx="46" cy="16" rx="8" ry="4" transform="rotate(-25 46 16)" fill="#6CC47A"/>\n</svg>\n';

  // ../aset/benda/ikan.svg
  var ikan_default = '<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" viewBox="0 0 72 72">\n<ellipse cx="32" cy="36" rx="22" ry="14" fill="#FFB547"/>\n<path d="M52 36 L66 24 L66 48 Z" fill="#FFB547"/>\n<circle cx="22" cy="32" r="3" fill="#2A2350"/>\n</svg>\n';

  // ../aset/benda/kerang.svg
  var kerang_default = '<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" viewBox="0 0 72 72">\n<path d="M36 14 L60 54 Q36 66 12 54 Z" fill="#FF9AA2"/>\n<path d="M36 14 L16.400000000000002 58" stroke="#FFFFFF" stroke-width="2"/>\n<path d="M36 14 L27.6 58" stroke="#FFFFFF" stroke-width="2"/>\n<path d="M36 14 L38.8 58" stroke="#FFFFFF" stroke-width="2"/>\n<path d="M36 14 L50 58" stroke="#FFFFFF" stroke-width="2"/>\n</svg>\n';

  // ../aset/benda/kue.svg
  var kue_default = '<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" viewBox="0 0 72 72">\n<circle cx="36" cy="36" r="28" fill="#F7DE9C"/>\n<path d="M36 36 L36 8 A28 28 0 0 1 64 36 Z" fill="#E07A5F"/>\n<path d="M8 36 H64 M36 8 V64" stroke="#FFFFFF" stroke-width="3"/>\n<circle cx="36" cy="36" r="28" fill="none" stroke="#2A2350" stroke-width="3"/>\n</svg>\n';

  // ../aset/bintang-xp.svg
  var bintang_xp_default = '<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 96 96">\n<circle cx="48" cy="50" r="40" fill="#FFB547" fill-opacity="0.25"/>\n<path d="M48 12 L58 36.2 L84.1 38.3 L64.2 55.3 L70.3 80.7 L48 67 L25.7 80.7 L31.8 55.3 L11.9 38.3 L38 36.2 Z" fill="#FFD166" stroke="#F4A340" stroke-width="4" stroke-linejoin="round"/>\n<text x="48" y="58" text-anchor="middle" font-family="Nunito, Arial, sans-serif" font-weight="900" font-size="20" fill="#2A2350">XP</text>\n</svg>\n';

  // src/svg.ts
  var MASKOT = { senang: numi_senang_default, berpikir: numi_berpikir_default, semangat: numi_semangat_default, sedih: numi_sedih_default, mengantuk: numi_mengantuk_default, bangga: numi_bangga_default, terkejut: numi_terkejut_default, tertawa: numi_tertawa_default, kagum: numi_kagum_default, tidur: numi_tidur_default, mengedip: numi_mengedip_default };
  var WAJAH = { senang: wajah_senang_default, berpikir: wajah_berpikir_default, semangat: wajah_semangat_default, sedih: wajah_sedih_default, mengantuk: wajah_mengantuk_default, bangga: wajah_bangga_default, terkejut: wajah_terkejut_default, tertawa: wajah_tertawa_default, kagum: wajah_kagum_default, tidur: wajah_tidur_default, mengedip: wajah_mengedip_default };
  var ASET = { perahu: perahu_default, apel: apel_default, ikan: ikan_default, kerang: kerang_default, kue: kue_default, bintang: bintang_xp_default };

  // src/main.ts
  var hex = (h) => ({
    r: parseInt(h.slice(1, 3), 16) / 255,
    g: parseInt(h.slice(3, 5), 16) / 255,
    b: parseInt(h.slice(5, 7), 16) / 255
  });
  var solid = (h, opacity = 1) => ({ type: "SOLID", color: hex(h), opacity });
  var gradien = (atas, bawah) => ({
    type: "GRADIENT_LINEAR",
    gradientTransform: [[0, 1, 0], [-1, 0, 1]],
    gradientStops: [
      { position: 0, color: __spreadProps(__spreadValues({}, hex(atas)), { a: 1 }) },
      { position: 1, color: __spreadProps(__spreadValues({}, hex(bawah)), { a: 1 }) }
    ]
  });
  var W = {
    malam: "#1B1F4B",
    malamTerang: "#2B3480",
    laut: "#243B8F",
    lautDalam: "#16215E",
    cahaya: "#FFB547",
    muda: "#FFD98A",
    krem: "#FFF8EC",
    tinta: "#232347",
    pudar: "#6C6C8A",
    pasir: "#F2D48C",
    rumput: "#6CC47A"
  };
  var EMOSI = ["senang", "berpikir", "semangat", "sedih", "mengantuk", "bangga", "terkejut", "tertawa", "kagum", "tidur", "mengedip"];
  var PENANDA = "numi-builder";
  var F = { biasa: { family: "Inter", style: "Regular" }, tebal: { family: "Inter", style: "Bold" } };
  async function siapkanFont() {
    try {
      const nunito = { biasa: { family: "Nunito", style: "Regular" }, tebal: { family: "Nunito", style: "ExtraBold" } };
      await Promise.all([figma.loadFontAsync(nunito.biasa), figma.loadFontAsync(nunito.tebal)]);
      F = nunito;
    } catch (e) {
      await Promise.all([figma.loadFontAsync(F.biasa), figma.loadFontAsync(F.tebal)]);
    }
  }
  function teks(isi, size, opsi = {}) {
    var _a;
    const t = figma.createText();
    t.fontName = opsi.tebal ? F.tebal : F.biasa;
    t.characters = isi;
    t.fontSize = size;
    t.fills = [solid((_a = opsi.warna) != null ? _a : W.tinta)];
    if (opsi.lebar) {
      t.textAutoResize = "HEIGHT";
      t.resize(opsi.lebar, t.height);
    }
    return t;
  }
  var kali = (a, b) => [
    [a[0][0] * b[0][0] + a[0][1] * b[1][0], a[0][0] * b[0][1] + a[0][1] * b[1][1], a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2]],
    [a[1][0] * b[0][0] + a[1][1] * b[1][0], a[1][0] * b[0][1] + a[1][1] * b[1][1], a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2]]
  ];
  function putar(node, derajat, px, py) {
    if (!derajat) return;
    const t = derajat * Math.PI / 180;
    const c = Math.cos(t), s = Math.sin(t);
    const r = kali(kali([[1, 0, px], [0, 1, py]], [[c, s, 0], [-s, c, 0]]), [[1, 0, -px], [0, 1, -py]]);
    node.relativeTransform = kali(r, node.relativeTransform);
  }
  var putarTengah = (n, d) => putar(n, d, n.x + n.width / 2, n.y + n.height / 2);
  function bingkai(nama, w, h, isi) {
    const f = figma.createFrame();
    f.name = nama;
    f.resize(w, h);
    f.fills = isi != null ? isi : [];
    f.clipsContent = false;
    return f;
  }
  function elips(nama, x, y, w, h, warna, opacity = 1) {
    const e = figma.createEllipse();
    e.name = nama;
    e.x = x;
    e.y = y;
    e.resize(w, h);
    e.fills = [solid(warna, opacity)];
    return e;
  }
  function svgNode(svg, nama) {
    const n = figma.createNodeFromSvg(svg);
    n.name = nama;
    n.fills = [];
    n.clipsContent = false;
    return n;
  }
  var log = [];
  function lapor(s) {
    log.push(s);
    figma.ui.postMessage({ log: s });
  }
  async function halaman(nama, timpa) {
    const ada = figma.root.children.find((p2) => p2.name === nama);
    if (ada) {
      if (!timpa || ada.getPluginData(PENANDA) !== "1") {
        lapor(`\u2022 "${nama}" sudah ada, dilewati`);
        return null;
      }
      if (figma.currentPage === ada) await figma.setCurrentPageAsync(figma.root.children.find((p2) => p2 !== ada));
      ada.remove();
    }
    const p = figma.createPage();
    p.name = nama;
    p.setPluginData(PENANDA, "1");
    await figma.setCurrentPageAsync(p);
    return p;
  }
  function judul(page, isi, catatan, y = 0) {
    const t = teks(isi, 48, { tebal: true });
    t.y = y;
    const c = teks(catatan, 18, { warna: W.pudar, lebar: 1100 });
    c.y = y + 70;
    page.appendChild(t);
    page.appendChild(c);
    return y + 70 + c.height + 40;
  }
  var wajahKomp = {};
  function buatWajah(page, y) {
    const t = teks("Wajah emosi", 28, { tebal: true });
    t.y = y;
    page.appendChild(t);
    EMOSI.forEach((e, i) => {
      const c = figma.createComponent();
      c.name = `wajah/${e}`;
      c.resize(120, 120);
      c.fills = [];
      c.clipsContent = false;
      const n = svgNode(WAJAH[e], "garis");
      c.appendChild(n);
      n.x = 0;
      n.y = 0;
      c.description = `Wajah ${e}. Dipasang ke slot/wajah base plate lewat properti "emosi".`;
      c.x = i * 150;
      c.y = y + 50;
      page.appendChild(c);
      const label = teks(e, 14, { warna: W.pudar });
      label.x = c.x;
      label.y = y + 180;
      page.appendChild(label);
      wajahKomp[e] = c;
    });
    return y + 240;
  }
  var TIPE = [
    { id: "bulat", nama: "Bulat (anjing laut)", warna: "#6FB7FF", perut: "#DDEEFF", bw: 140, bh: 120, cy: 130, lengan: 40, kaki: 26, tebal: 22, telinga: true },
    { id: "tinggi", nama: "Tinggi (penjaga pulau)", warna: "#B98CFF", perut: "#EEE3FF", bw: 96, bh: 160, cy: 112, lengan: 52, kaki: 30, tebal: 20 },
    { id: "mungil", nama: "Mungil (kacang)", warna: "#FF9AA2", perut: "#FFE3E6", bw: 84, bh: 84, cy: 150, lengan: 28, kaki: 20, tebal: 16 },
    { id: "bersayap", nama: "Bersayap (sepupu Numi)", warna: "#8FE3B0", perut: "#E3FBEA", bw: 110, bh: 110, cy: 124, lengan: 34, kaki: 22, tebal: 18, sayap: true, antena: true }
  ];
  var POSE = {
    idle: { L: -12, R: 12, KL: 0, KR: 0, B: 0, S: 0, dy: 0 },
    "lambai-a": { L: -12, R: 150, KL: 0, KR: 0, B: 4, S: 10, dy: 0 },
    "lambai-b": { L: -12, R: 112, KL: 0, KR: 0, B: 2, S: -6, dy: 0 },
    lompat: { L: -150, R: 150, KL: -28, KR: 28, B: 0, S: 24, dy: -28 },
    duduk: { L: -40, R: 40, KL: -80, KR: 80, B: 0, S: 0, dy: 18 },
    sedih: { L: -3, R: 3, KL: 0, KR: 0, B: -6, S: -16, dy: 4 },
    tunjuk: { L: -12, R: 88, KL: 0, KR: 0, B: 3, S: 0, dy: 0 }
  };
  var basePlate = {};
  function tulang(nama, x, y, w, panjang, warna, induk) {
    const f = bingkai(`rig/${nama}`, w, panjang);
    f.x = x - w / 2;
    f.y = y;
    const e = elips("bentuk", 0, 0, w, panjang, warna);
    f.appendChild(e);
    f.setPluginData("sendi", JSON.stringify([x, y]));
    induk.appendChild(f);
    return f;
  }
  function rakit(t, namaPose) {
    const p = POSE[namaPose];
    const c = figma.createComponent();
    c.name = `pose=${namaPose}`;
    c.resize(200, 220);
    c.fills = [];
    c.clipsContent = false;
    const root = bingkai("rig/root", 200, 220);
    c.appendChild(root);
    const cx = 100, cy = t.cy, atas = cy - t.bh / 2, bawah = cy + t.bh / 2;
    let sayapL = null, sayapR = null;
    if (t.sayap) {
      sayapL = tulang("sayap-kiri", cx - t.bw * 0.2, atas + t.bh * 0.15, 34, 60, "#CFF3FF", root);
      sayapR = tulang("sayap-kanan", cx + t.bw * 0.2, atas + t.bh * 0.15, 34, 60, "#CFF3FF", root);
      for (const s of [sayapL, sayapR]) {
        const e = s.children[0];
        e.opacity = 0.85;
        e.strokes = [solid("#FFFFFF")];
        e.strokeWeight = 2;
      }
    }
    const kakiL = tulang("kaki-kiri", cx - t.bw * 0.22, bawah - 8, t.tebal, t.kaki, t.warna, root);
    const kakiR = tulang("kaki-kanan", cx + t.bw * 0.22, bawah - 8, t.tebal, t.kaki, t.warna, root);
    const badan = bingkai("rig/badan", t.bw, t.bh);
    badan.x = cx - t.bw / 2;
    badan.y = atas;
    root.appendChild(badan);
    if (t.telinga) {
      badan.appendChild(elips("telinga-kiri", t.bw * 0.12, -8, 28, 28, t.warna));
      badan.appendChild(elips("telinga-kanan", t.bw * 0.88 - 28, -8, 28, 28, t.warna));
    }
    if (t.antena) {
      for (const [nama, x] of [["antena-kiri", t.bw * 0.3], ["antena-kanan", t.bw * 0.7]]) {
        const a = bingkai(`rig/${nama}`, 6, 30);
        a.x = x - 3;
        a.y = -26;
        const batang = figma.createRectangle();
        batang.name = "batang";
        batang.resize(4, 28);
        batang.x = 1;
        batang.fills = [solid(W.tinta)];
        a.appendChild(batang);
        a.appendChild(elips("cahaya", -5, -8, 16, 16, W.muda));
        badan.appendChild(a);
      }
    }
    badan.appendChild(elips("badan", 0, 0, t.bw, t.bh, t.warna));
    badan.appendChild(elips("perut", t.bw * 0.22, t.bh * 0.5, t.bw * 0.56, t.bh * 0.42, t.perut, 0.9));
    const wajah = wajahKomp.senang.createInstance();
    wajah.name = "slot/wajah";
    const ukuran = Math.min(t.bw, t.bh) * 1.35;
    wajah.rescale(ukuran / 120);
    wajah.x = (t.bw - wajah.width) / 2;
    wajah.y = t.bh * 0.42 - wajah.height / 2;
    badan.appendChild(wajah);
    const bahuY = atas + t.bh * 0.45;
    const lenganL = tulang("lengan-kiri", cx - t.bw / 2 + t.tebal * 0.3, bahuY, t.tebal, t.lengan, t.warna, root);
    const lenganR = tulang("lengan-kanan", cx + t.bw / 2 - t.tebal * 0.3, bahuY, t.tebal, t.lengan, t.warna, root);
    const sendi = (f) => JSON.parse(f.getPluginData("sendi"));
    putar(lenganL, p.L, ...sendi(lenganL));
    putar(lenganR, p.R, ...sendi(lenganR));
    putar(kakiL, p.KL, ...sendi(kakiL));
    putar(kakiR, p.KR, ...sendi(kakiR));
    if (sayapL && sayapR) {
      putar(sayapL, 35 + p.S, ...sendi(sayapL));
      putar(sayapR, -35 - p.S, ...sendi(sayapR));
    }
    putar(badan, p.B, cx, bawah);
    root.y = p.dy;
    return c;
  }
  function buatBasePlate(page, y) {
    const t = teks("Base plate mob", 28, { tebal: true });
    t.y = y;
    page.appendChild(t);
    const cat = teks(
      'Setiap base plate adalah component set dengan properti "pose" (variant) dan "emosi" (instance swap ke wajah/*). Tulang: rig/root > rig/badan (badan, perut, slot/wajah, antena), rig/lengan-*, rig/kaki-*, rig/sayap-*. Semua variant memakai nama layer yang sama, jadi ganti pose dengan Smart Animate = animasi rig. Sendi tiap tulang ada di tengah atas frame-nya; saat menganimasikan manual, putar dari titik itu.',
      16,
      { warna: W.pudar, lebar: 1400 }
    );
    cat.y = y + 44;
    page.appendChild(cat);
    let yy = y + 44 + cat.height + 30;
    for (const tipe of TIPE) {
      const varian = Object.keys(POSE).map((n) => rakit(tipe, n));
      const set = figma.combineAsVariants(varian, page);
      set.name = `mob/${tipe.id}`;
      set.description = `Base plate mob ${tipe.nama}. Pilih pose dan emosi dari panel properti.`;
      set.layoutMode = "HORIZONTAL";
      set.itemSpacing = 40;
      set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 30;
      set.primaryAxisSizingMode = "AUTO";
      set.counterAxisSizingMode = "AUTO";
      set.fills = [solid("#F4F1EA")];
      set.cornerRadius = 24;
      set.x = 0;
      set.y = yy;
      const emosiProp = set.addComponentProperty("emosi", "INSTANCE_SWAP", wajahKomp.senang.id, {
        preferredValues: EMOSI.map((e) => ({ type: "COMPONENT", key: wajahKomp[e].key }))
      });
      for (const v of set.children) {
        const slot = v.findOne((n) => n.name === "slot/wajah");
        slot.componentPropertyReferences = { mainComponent: emosiProp };
      }
      basePlate[tipe.id] = { set, emosiProp };
      const label = teks(tipe.nama, 18, { tebal: true });
      label.x = set.width + 30;
      label.y = yy + 20;
      page.appendChild(label);
      yy += set.height + 50;
    }
    const contoh = teks("Contoh: mob/bulat dengan 11 emosi", 20, { tebal: true });
    contoh.y = yy;
    page.appendChild(contoh);
    EMOSI.forEach((e, i) => {
      const inst = mob("bulat", "idle", e);
      inst.x = i * 210;
      inst.y = yy + 40;
      page.appendChild(inst);
    });
    return yy + 300;
  }
  function mob(tipe, pose, emosi) {
    const bp = basePlate[tipe];
    const v = bp.set.children.find((c) => c.name === `pose=${pose}`);
    const inst = v.createInstance();
    inst.setProperties({ [bp.emosiProp]: wajahKomp[emosi].id });
    inst.name = `mob-${tipe}`;
    return inst;
  }
  var k = (dy, s, rot, extra = {}) => __spreadValues({ dy, s, rot }, extra);
  var EMOTE = {
    senang: { durasi: 0.35, kunci: [k(0, 1, 0), k(-10, 1.04, 0), k(0, 1, 0), k(-6, 1.02, 0)], pose: ["idle", "lambai-a", "lambai-b", "lambai-a"] },
    berpikir: { durasi: 0.5, kunci: [k(0, 1, 0), k(0, 1, 8), k(-4, 1, 10), k(0, 1, 4)], pose: ["idle", "tunjuk", "tunjuk", "idle"] },
    semangat: { durasi: 0.3, kunci: [k(0, 1, 0), k(6, 0.95, 0), k(-28, 1.05, -6), k(0, 1, 0)], pose: ["idle", "duduk", "lompat", "idle"] },
    sedih: { durasi: 0.7, kunci: [k(0, 1, 0), k(6, 0.97, -4), k(8, 0.96, -6), k(6, 0.97, -4)], pose: ["idle", "sedih", "sedih", "sedih"] },
    mengantuk: { durasi: 0.8, kunci: [k(0, 1, 0), k(4, 0.99, -8), k(6, 0.98, -12), k(2, 1, -4)], pose: ["idle", "sedih", "sedih", "idle"] },
    bangga: { durasi: 0.4, kunci: [k(0, 1, 0), k(-6, 1.08, 0), k(-8, 1.12, 0), k(-4, 1.06, 0)], pose: ["idle", "lompat", "lompat", "idle"] },
    terkejut: { durasi: 0.25, kunci: [k(0, 1, 0), k(-20, 1.1, 0), k(-14, 1.06, 0), k(0, 1, 0)], pose: ["idle", "lompat", "idle", "idle"] },
    tertawa: { durasi: 0.2, kunci: [k(0, 1, 0), k(-4, 1.02, 8), k(-4, 1.02, -8), k(-2, 1.01, 4)], pose: ["idle", "lambai-a", "idle", "lambai-b"] },
    kagum: { durasi: 0.45, kunci: [k(0, 1, 0), k(-12, 1.06, 0), k(-16, 1.08, 0), k(-8, 1.04, 0)], pose: ["idle", "lompat", "lompat", "idle"] },
    tidur: { durasi: 0.9, kunci: [k(0, 1, 0), k(2, 1.03, 0), k(4, 1.05, 0), k(2, 1.03, 0)], pose: ["duduk", "duduk", "duduk", "duduk"] },
    mengedip: { durasi: 0.3, kunci: [k(0, 1, 0, { wajah: "senang" }), k(0, 1, 6), k(0, 1, 6), k(0, 1, 0, { wajah: "senang" })], pose: ["idle", "tunjuk", "tunjuk", "idle"] }
  };
  async function sambungLoop(frames, durasi) {
    for (let i = 0; i < frames.length; i++) {
      await frames[i].setReactionsAsync([{
        trigger: { type: "AFTER_TIMEOUT", timeout: 0.01 },
        actions: [{
          type: "NODE",
          destinationId: frames[(i + 1) % frames.length].id,
          navigation: "CHANGE_TO",
          transition: { type: "SMART_ANIMATE", easing: { type: "EASE_IN_AND_OUT" }, duration: durasi },
          preserveScrollPosition: false
        }]
      }]);
    }
  }
  function aturVariantSet(set, x, y) {
    set.layoutMode = "HORIZONTAL";
    set.itemSpacing = 24;
    set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 24;
    set.primaryAxisSizingMode = "AUTO";
    set.counterAxisSizingMode = "AUTO";
    set.fills = [solid(W.malam)];
    set.cornerRadius = 24;
    set.x = x;
    set.y = y;
  }
  async function buatEmote(page, y) {
    let yy = y;
    for (const e of EMOSI) {
      const resep = EMOTE[e];
      const frames = resep.kunci.map((kc, i) => {
        var _a;
        const c = figma.createComponent();
        c.name = `frame=${i + 1}`;
        c.resize(260, 260);
        c.fills = [];
        c.clipsContent = false;
        const n = svgNode(MASKOT[(_a = kc.wajah) != null ? _a : e], "numi");
        c.appendChild(n);
        n.rescale(kc.s);
        n.x = (260 - n.width) / 2;
        n.y = (260 - n.height) / 2 + kc.dy;
        putarTengah(n, kc.rot);
        return c;
      });
      const set = figma.combineAsVariants(frames, page);
      set.name = `emote/numi/${e}`;
      set.description = `Emote ${e}. Pasang instance frame=1 lalu Play: berputar ${resep.kunci.length} frame dengan Smart Animate.`;
      aturVariantSet(set, 0, yy);
      await sambungLoop(frames, resep.durasi);
      const framesMob = resep.kunci.map((kc, i) => {
        var _a;
        const c = figma.createComponent();
        c.name = `frame=${i + 1}`;
        c.resize(240, 260);
        c.fills = [];
        c.clipsContent = false;
        const m = mob("bulat", resep.pose[i], (_a = kc.wajah) != null ? _a : e);
        c.appendChild(m);
        m.x = 20;
        m.y = 20 + kc.dy;
        putarTengah(m, kc.rot / 2);
        return c;
      });
      const setMob = figma.combineAsVariants(framesMob, page);
      setMob.name = `emote/mob/${e}`;
      aturVariantSet(setMob, set.width + 60, yy);
      await sambungLoop(framesMob, resep.durasi);
      const label = teks(e, 22, { tebal: true });
      label.x = set.width + setMob.width + 100;
      label.y = yy + 30;
      page.appendChild(label);
      yy += Math.max(set.height, setMob.height) + 40;
    }
    return yy;
  }
  var pp = [0, 1, 2, 1];
  function ombakSvg(w, warna) {
    let d = `M0 20`;
    for (let x = 0; x < w; x += 40) d += ` Q${x + 10} 6 ${x + 20} 20 T${x + 40} 20`;
    return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="40" viewBox="0 0 ${w} 40"><path d="${d} V40 H0 Z" fill="${warna}"/></svg>`;
  }
  var PULAU_SAMPING = `<svg xmlns="http://www.w3.org/2000/svg" width="180" height="120" viewBox="0 0 180 120">
<ellipse cx="90" cy="96" rx="88" ry="24" fill="#B9A675"/><ellipse cx="90" cy="88" rx="80" ry="26" fill="${W.pasir}"/>
<ellipse cx="90" cy="78" rx="56" ry="16" fill="${W.rumput}"/>
<path d="M120 80 Q124 46 116 20" stroke="#8B6B4A" stroke-width="7" fill="none" stroke-linecap="round"/>
<path d="M116 20 Q96 8 80 22 M116 20 Q132 4 150 16 M116 20 Q106 30 98 44 M116 20 Q134 28 140 42" stroke="#4E9F5D" stroke-width="9" fill="none" stroke-linecap="round"/></svg>`;
  var PERAHU = ASET.perahu;
  var IKAN = ASET.ikan;
  function kunciBg(i) {
    const f = figma.createComponent();
    f.name = `frame=${i + 1}`;
    f.resize(360, 780);
    f.clipsContent = true;
    f.fills = [gradien(W.malam, W.malamTerang)];
    for (let b = 0; b < 18; b++) {
      const r = b % 3 ? 3 : 5;
      const s = elips(`bintang-${b + 1}`, b * 97 % 340 + 8, b * 53 % 360 + 20, r, r, "#FFFFFF", 0.25 + 0.75 * ((b + i) % 4 / 3));
      f.appendChild(s);
    }
    const halo = elips("bulan-cahaya", 250, 60, 90, 90, W.muda, 0.15 + 0.05 * pp[i]);
    const bulan = elips("bulan", 270, 80, 50, 50, "#FFF1C1");
    f.appendChild(halo);
    f.appendChild(bulan);
    for (const [nama, x0, y0, arah] of [["awan-1", 20, 150, 1], ["awan-2", 200, 230, -1]]) {
      const a = figma.createFrame();
      a.name = nama;
      a.fills = [];
      a.clipsContent = false;
      a.resize(120, 40);
      a.appendChild(elips("a", 0, 12, 60, 28, "#B9BEDD", 0.35));
      a.appendChild(elips("b", 30, 0, 60, 40, "#B9BEDD", 0.35));
      a.appendChild(elips("c", 64, 12, 56, 28, "#B9BEDD", 0.35));
      a.x = x0 + arah * pp[i] * 14;
      a.y = y0;
      f.appendChild(a);
    }
    const numi = svgNode(MASKOT[i === 2 ? "tertawa" : "senang"], "numi");
    numi.rescale(0.42);
    numi.x = [40, 130, 220, 130][i];
    numi.y = [300, 270, 300, 330][i];
    putarTengah(numi, [6, 0, -6, 0][i]);
    f.appendChild(numi);
    for (let b = 0; b < 6; b++) {
      const g = elips(`kunang-${b + 1}`, (b * 61 + pp[i] * 8) % 340, 380 + (b * 37 + pp[i] * 10) % 80, 8, 8, W.muda, 0.4 + 0.15 * ((b + i) % 3));
      f.appendChild(g);
    }
    const laut = figma.createRectangle();
    laut.name = "laut";
    laut.resize(360, 330);
    laut.y = 450;
    laut.fills = [gradien(W.laut, W.lautDalam)];
    f.appendChild(laut);
    const pulauA = svgNode(PULAU_SAMPING, "pulau-kiri");
    pulauA.x = -10;
    pulauA.y = 420;
    f.appendChild(pulauA);
    const pemancing = mob("bulat", "duduk", ["senang", "senang", "terkejut", "tertawa"][i]);
    pemancing.name = "mob-pemancing";
    pemancing.rescale(0.45);
    pemancing.x = 30;
    pemancing.y = 392;
    f.appendChild(pemancing);
    const tali = figma.createLine();
    tali.name = "tali-pancing";
    tali.resize(70, 0);
    tali.x = 118;
    tali.y = 425;
    tali.rotation = -[40, 50, 70, 40][i];
    tali.strokes = [solid("#FFFFFF", 0.6)];
    tali.strokeWeight = 2;
    f.appendChild(tali);
    const ikan = svgNode(IKAN, "ikan");
    ikan.rescale(0.5);
    ikan.x = [150, 150, 128, 160][i];
    ikan.y = [520, 470, 420, 520][i];
    ikan.opacity = i === 0 ? 0 : 1;
    putarTengah(ikan, [0, 40, 0, -40][i]);
    f.appendChild(ikan);
    const pulauB = svgNode(PULAU_SAMPING, "pulau-kanan");
    pulauB.x = 200;
    pulauB.y = 380;
    f.appendChild(pulauB);
    const penjaga = mob("tinggi", ["idle", "lambai-a", "lambai-b", "lambai-a"][i], i === 0 ? "senang" : "tertawa");
    penjaga.name = "mob-penjaga";
    penjaga.rescale(0.45);
    penjaga.x = 238;
    penjaga.y = 360;
    f.appendChild(penjaga);
    const mungil = mob("mungil", i % 2 ? "lompat" : "idle", i % 2 ? "kagum" : "senang");
    mungil.name = "mob-mungil";
    mungil.rescale(0.4);
    mungil.x = 280;
    mungil.y = 380 - (i % 2 ? 14 : 0);
    f.appendChild(mungil);
    const ayun = [0, 5, 0, -5][i];
    const perahu = svgNode(PERAHU, "perahu");
    perahu.rescale(0.9);
    perahu.x = 96 + pp[i] * 6;
    perahu.y = 560 + ayun;
    putarTengah(perahu, [0, 3, 0, -3][i]);
    const p1 = mob("bersayap", ["lambai-a", "lambai-b", "lambai-a", "lambai-b"][i], "senang");
    p1.name = "mob-penumpang-1";
    p1.rescale(0.36);
    p1.x = 100 + pp[i] * 6;
    p1.y = 572 + ayun;
    const p2 = mob("bulat", i === 2 ? "tunjuk" : "idle", i === 2 ? "terkejut" : "senang");
    p2.name = "mob-penumpang-2";
    p2.rescale(0.32);
    p2.x = 168 + pp[i] * 6;
    p2.y = 580 + ayun;
    f.appendChild(perahu);
    f.appendChild(p1);
    f.appendChild(p2);
    [["ombak-1", 600, "#2F4FB0", 1], ["ombak-2", 660, "#2A45A0", -1], ["ombak-3", 720, "#22388A", 1]].forEach(([nama, yy, warna, arah]) => {
      const o = svgNode(ombakSvg(440, warna), nama);
      o.x = -40 + arah * pp[i] * 10;
      o.y = yy;
      f.appendChild(o);
    });
    return f;
  }
  async function buatBg(page, y) {
    const frames = [0, 1, 2, 3].map(kunciBg);
    const set = figma.combineAsVariants(frames, page);
    set.name = "bg/peta-malam";
    set.description = "Latar peta animasi. Pakai instance frame=1 di layar, lalu Play: berputar 4 frame (1,2 detik per frame). Interaksi: pemancing menangkap ikan dan kaget, penjaga pulau melambai ke perahu, penumpang membalas, si mungil melompat, Numi terbang.";
    aturVariantSet(set, 0, y);
    set.fills = [solid("#F4F1EA")];
    await sambungLoop(frames, 1.2);
    const layar = bingkai("contoh layar peta", 360, 780, [solid(W.malam)]);
    layar.clipsContent = true;
    layar.x = set.width + 80;
    layar.y = y + 24;
    const bg = frames[0].createInstance();
    bg.name = "bg";
    layar.appendChild(bg);
    const tombol = figma.createFrame();
    tombol.name = "tombol MAIN";
    tombol.resize(320, 72);
    tombol.x = 20;
    tombol.y = 680;
    tombol.cornerRadius = 36;
    tombol.fills = [solid(W.cahaya)];
    tombol.layoutMode = "VERTICAL";
    tombol.primaryAxisAlignItems = "CENTER";
    tombol.counterAxisAlignItems = "CENTER";
    tombol.appendChild(teks("MAIN", 24, { tebal: true }));
    layar.appendChild(tombol);
    page.appendChild(layar);
    const cat = teks("Layar peta dengan latar animasi. Pulau skill map nanti ditaruh di atas lapisan ini.", 16, { warna: W.pudar, lebar: 360 });
    cat.x = layar.x;
    cat.y = layar.y + 800;
    page.appendChild(cat);
  }
  async function buatItem(tema, timpa) {
    const page = await halaman(`item / ${tema.nama.toLowerCase()}`, timpa);
    if (!page) return;
    let y = judul(page, tema.nama, `${tema.barang.length} barang yang perlu dikenal anak. Kotak ilustrasi masih kosong: gambar mengikuti gaya di page "ref item", lalu tiap kartu bisa dipakai sebagai komponen soal (hitung benda, pecahan, soal cerita). Label "kecil" = dikenalkan kelas 1-3, "besar" = kelas 4-6.`);
    const grid = figma.createFrame();
    grid.name = "daftar";
    grid.layoutMode = "HORIZONTAL";
    grid.layoutWrap = "WRAP";
    grid.itemSpacing = 24;
    grid.counterAxisSpacing = 24;
    grid.primaryAxisSizingMode = "FIXED";
    grid.counterAxisSizingMode = "AUTO";
    grid.resize(1416, 100);
    grid.fills = [];
    grid.y = y;
    page.appendChild(grid);
    for (const b of tema.barang) {
      const c = figma.createComponent();
      c.name = `item/${tema.id}/${b.id}`;
      c.description = `${b.nama} (${b.en}). Kelas ${b.kelas}. Dipakai untuk: ${b.pakai}.`;
      c.layoutMode = "VERTICAL";
      c.itemSpacing = 8;
      c.paddingLeft = c.paddingRight = c.paddingTop = c.paddingBottom = 16;
      c.primaryAxisSizingMode = "AUTO";
      c.counterAxisSizingMode = "FIXED";
      c.resize(204, 100);
      c.cornerRadius = 20;
      c.fills = [solid("#FFFFFF")];
      c.strokes = [solid("#E4DFD3")];
      c.strokeWeight = 2;
      const ilustrasi = figma.createFrame();
      ilustrasi.name = "ilustrasi";
      ilustrasi.resize(172, 140);
      ilustrasi.cornerRadius = 16;
      ilustrasi.fills = [solid(tema.warna, 0.12)];
      ilustrasi.strokes = [solid(tema.warna, 0.6)];
      ilustrasi.dashPattern = [6, 6];
      ilustrasi.layoutMode = "VERTICAL";
      ilustrasi.primaryAxisAlignItems = "CENTER";
      ilustrasi.counterAxisAlignItems = "CENTER";
      const svg = ASET[b.id];
      if (svg) {
        const n = svgNode(svg, "gambar");
        n.rescale(110 / Math.max(n.width, n.height));
        ilustrasi.appendChild(n);
      } else {
        ilustrasi.appendChild(teks(b.nama.charAt(0), 56, { tebal: true, warna: tema.warna }));
      }
      c.appendChild(ilustrasi);
      c.appendChild(teks(b.nama, 20, { tebal: true }));
      c.appendChild(teks(b.en, 14, { warna: W.pudar }));
      const chip = teks(`kelas ${b.kelas} \xB7 ${b.pakai}`, 12, { warna: W.pudar, lebar: 172 });
      c.appendChild(chip);
      grid.appendChild(c);
    }
    lapor(`\u2713 item / ${tema.nama.toLowerCase()}: ${tema.barang.length} kartu`);
  }
  async function jalankan(pilih, timpa) {
    await siapkanFont();
    const butuhMob = pilih.mob || pilih.emote || pilih.bg;
    if (butuhMob) {
      let page = await halaman("mob base plate", timpa);
      if (page) {
        let y = judul(page, "Mob base plate", 'Badan polos tanpa wajah. Emosi dipasang sebagai wajah lewat properti "emosi", pose lewat properti "pose".');
        y = buatWajah(page, y);
        buatBasePlate(page, y + 40);
        lapor("\u2713 mob base plate: 11 wajah, 4 base plate \xD7 7 pose");
      } else {
        const ada = figma.root.children.find((p) => p.name === "mob base plate");
        await ada.loadAsync();
        for (const e of EMOSI) {
          const c = ada.findOne((n) => n.type === "COMPONENT" && n.name === `wajah/${e}`);
          if (c) wajahKomp[e] = c;
        }
        for (const t of TIPE) {
          const set = ada.findOne((n) => n.type === "COMPONENT_SET" && n.name === `mob/${t.id}`);
          const prop = set && Object.keys(set.componentPropertyDefinitions).find((p) => p.startsWith("emosi"));
          if (set && prop) basePlate[t.id] = { set, emosiProp: prop };
        }
        if (Object.keys(basePlate).length < TIPE.length || Object.keys(wajahKomp).length < EMOSI.length) {
          lapor('\u2717 page "mob base plate" sudah ada tetapi isinya berubah. Centang "timpa" atau hapus page itu dulu.');
          return;
        }
      }
    }
    if (pilih.emote) {
      const page = await halaman("anim emote", timpa);
      if (page) {
        const y = judul(page, "Animasi emote", "Kiri: Numi. Kanan: mob/bulat dengan pose rig dan wajah emosi. Tiap baris component set 4 frame yang saling tersambung (After delay \u2192 Change to, Smart Animate). Taruh instance frame=1 di sebuah frame, lalu tekan Play untuk melihat animasinya.");
        await buatEmote(page, y);
        lapor("\u2713 anim emote: 11 emote Numi + 11 emote mob");
      }
    }
    if (pilih.bg) {
      const page = await halaman("bg animasi", timpa);
      if (page) {
        const y = judul(page, "Latar animasi", "Pengganti latar peta yang polos. Empat frame berputar dengan Smart Animate; semua karakter memakai base plate mob, jadi wajah dan pose bisa diganti dari panel properti.");
        await buatBg(page, y);
        lapor("\u2713 bg animasi: 4 frame + contoh layar peta");
      }
    }
    if (pilih.item) for (const t of barang_default.tema) await buatItem(t, timpa);
  }
  figma.showUI(__html__, { width: 360, height: 420 });
  figma.ui.onmessage = async (m) => {
    try {
      await jalankan(m.pilih, m.timpa);
      lapor("Selesai.");
      figma.notify("Numi Builder selesai");
    } catch (e) {
      lapor(`\u2717 Gagal: ${e.message}`);
      console.error(e);
    }
  };
})();
