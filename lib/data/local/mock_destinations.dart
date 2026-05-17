import '../models/destination_model.dart';

final List<DestinationModel> mockDestinations = [
  // --- KATEGORI 1: BUDAYA & SEJARAH ---
  DestinationModel(
    id: 'dest_1',
    quizId: 'q1',
    name: 'Museum Nasional Indonesia',
    description:
        'Museum Nasional atau "Museum Gajah" adalah museum tertua di Indonesia, berdiri sejak 1778. Didirikan oleh perkumpulan ilmuwan Belanda dan menyimpan lebih dari 190.000 koleksi artefak dari seluruh Nusantara.',
    location: 'Jakarta Pusat',
    category: 'Budaya & Sejarah',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/4/45/Museum_Nasional_Indonesia.jpg',
    rating: 4.8,
    reviews: 12500,
    ticketPrice: 'Rp 30.000 - Rp 50.000',
    openHours: '08:00 - 16:00',
    gallery: [],
    facts: [
      'Ada patung gajah beneran (dari perunggu!) di halamannya — hadiah dari Raja Thailand!',
      'Koleksinya lebih banyak dari jumlah siswa di 10 sekolah digabung!',
      'Ada keris, mahkota raja, dan baju adat dari 250 suku bangsa!',
    ],
  ),
  DestinationModel(
    id: 'dest_2',
    quizId: 'q2',
    name: 'Monumen Nasional (Monas)',
    description:
        'Monas dibangun atas ide Presiden Soekarno sebagai simbol semangat perjuangan kemerdekaan Indonesia. Pembangunannya dimulai tahun 1961 dan selesai tahun 1975 — membutuhkan waktu 14 tahun!',
    location: 'Jakarta Pusat',
    category: 'Budaya & Sejarah',
    imageUrl: 'https://www.iwarebatik.org/wp-content/uploads/2019/11/monas.jpg',
    rating: 4.9,
    reviews: 25000,
    ticketPrice: 'Rp 5.000 - Rp 25.000',
    openHours: '08:00 - 22:00',
    gallery: [],
    facts: [
      'Api di puncak Monas dilapisi 35 kg emas asli yang berkilau!',
      'Tingginya 132 meter — setara dengan gedung 40 lantai!',
      'Di dalam Monas ada 48 miniatur cerita perjalanan bangsa Indonesia',
      'Taman di sekitar Monas seluas 80 hektar — coba bayangin itu!',
    ],
  ),
  DestinationModel(
    id: 'dest_3',
    quizId: 'q3',
    name: 'Kota Tua Jakarta',
    description:
        'Kota Tua adalah jantung sejarah Jakarta yang dulunya bernama Batavia — ibu kota Hindia Belanda. Kawasan ini dibangun oleh VOC pada abad ke-17.',
    location: 'Jakarta Barat',
    category: 'Budaya & Sejarah',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Batavia_City_Hall_%28Jakarta_History_Museum%29_Fatahillah_Square_%282025%29_-_img_02.jpg/960px-Batavia_City_Hall_%28Jakarta_History_Museum%29_Fatahillah_Square_%282025%29_-_img_02.jpg',
    rating: 4.7,
    reviews: 18900,
    ticketPrice: 'Gratis',
    openHours: '24 Jam',
    gallery: [],
    facts: [
      'Kamu bisa naik sepeda onthel warna-warni keliling kawasan ini!',
      'Gedung-gedungnya sudah berumur lebih dari 300 tahun tapi masih kokoh!',
      'Di Taman Fatahillah sering ada seniman jalanan dan pertunjukan seni gratis',
    ],
  ),
  DestinationModel(
    id: 'dest_4',
    quizId: 'q4',
    name: 'Setu Babakan',
    description:
        'Setu Babakan adalah kawasan Perkampungan Budaya Betawi yang diresmikan oleh Pemerintah DKI Jakarta tahun 2000. Di sini kamu bisa belajar tari Betawi, musik gambang kromong, dan cara membuat makanan tradisional Betawi.',
    location: 'Jakarta Selatan',
    category: 'Budaya & Sejarah',
    imageUrl:
        'https://getlost.id/wp-content/uploads/2020/12/setu-babakan_1432740068.jpg',
    rating: 4.6,
    reviews: 8200,
    ticketPrice: 'Gratis',
    openHours: '06:00 - 21:00',
    gallery: [],
    facts: [
      'Di sini kamu bisa nonton ondel-ondel, lenong, dan tari topeng secara langsung!',
      'Ada danau indah bernama Setu Babakan yang bisa dikelilingi sambil makan buah segar',
      'Jajanan Betawi asli seperti kerak telor, asinan, dan bir pletok ada semua di sini',
    ],
  ),
  DestinationModel(
    id: 'dest_5',
    quizId: 'q5',
    name: 'Museum Wayang',
    description:
        'Museum Wayang terletak di kawasan Kota Tua dan menempati gedung bersejarah yang dibangun Belanda pada 1640. Wayang adalah seni pertunjukan tradisional Indonesia yang menggunakan boneka sebagai tokoh cerita.',
    location: 'Jakarta Barat',
    category: 'Budaya & Sejarah',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Museum_Wayang%2C_Jakarta_%282025%29_-_img_01.jpg/500px-Museum_Wayang%2C_Jakarta_%282025%29_-_img_01.jpg',
    rating: 4.5,
    reviews: 4500,
    ticketPrice: 'Rp 5.000',
    openHours: '09:00 - 15:00',
    gallery: [],
    facts: [
      'Ada wayang dari 50 negara berbeda — termasuk wayang dari Eropa dan Amerika!',
      'Koleksinya lebih dari 6.000 wayang — bayangkan semua puppet itu berjajar!',
      'Wayang sudah diakui UNESCO sebagai Warisan Budaya Dunia sejak 2003',
    ],
  ),

  // --- KATEGORI 2: HIBURAN & MODERN ---
  DestinationModel(
    id: 'dest_6',
    quizId: 'q6',
    name: 'TMII (Taman Mini)',
    description:
        'TMII adalah taman budaya miniatur Indonesia yang dibangun atas gagasan Ibu Tien Soeharto dan diresmikan pada 20 April 1975. Dari rumah adat Toraja, tari Saman Aceh, hingga makanan khas Papua — semua ada dalam satu taman.',
    location: 'Jakarta Timur',
    category: 'Hiburan & Modern',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Istana_Anak-anak_Indonesia_TMII_%282025%29_-_img_01.jpg/500px-Istana_Anak-anak_Indonesia_TMII_%282025%29_-_img_01.jpg',
    rating: 4.6,
    reviews: 21500,
    ticketPrice: 'Rp 25.000',
    openHours: '07:00 - 21:00',
    gallery: [],
    facts: [
      'Ada danau buatan berbentuk peta Indonesia yang bisa dilihat dari atas kereta gantung!',
      'Setiap provinsi punya rumah adat asli yang dibangun oleh pengrajin dari daerahnya masing-masing',
      'Ada kebun binatang dan Museum Iptek yang super seru untuk belajar sains!',
    ],
  ),
  DestinationModel(
    id: 'dest_7',
    quizId: 'q7',
    name: 'Ancol Dreamland',
    description:
        'Ancol adalah kawasan wisata tepi laut terbesar di Asia Tenggara yang terletak di Jakarta Utara. Dibuka sejak tahun 1966. Pasar Seni Ancol adalah rumah bagi ratusan seniman lokal Jakarta.',
    location: 'Jakarta Utara',
    category: 'Hiburan & Modern',
    imageUrl:
        'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/rsfit19201280gsm/events/2024/08/08/5d70c0a1-db69-4e64-9d9c-072a11c74d61-1723096699333-e909535ebcb2802a9ae01db3de381638.jpg',
    rating: 4.7,
    reviews: 32000,
    ticketPrice: 'Rp 35.000',
    openHours: '09:00 - 23:00',
    gallery: [],
    facts: [
      'Dufan (Dunia Fantasi) punya wahana seru seperti Halilintar dan Arung Jeram!',
      'Di Ocean Dream Samudra kamu bisa lihat atraksi lumba-lumba dan singa laut langsung!',
      'Ada Pasar Seni Ancol tempat seniman lokal menjual karya dan bisa bikin karya sendiri',
    ],
  ),
  DestinationModel(
    id: 'dest_8',
    quizId: 'q8',
    name: 'Jakarta Aquarium & Safari',
    description:
        'Jakarta Aquarium & Safari (JAQS) adalah akuarium modern yang berlokasi di dalam Neo Soho Mall, Jakarta Barat. Dibuka pada 2019, menjadi akuarium pertama di Indonesia yang berada di dalam pusat perbelanjaan.',
    location: 'Jakarta Barat',
    category: 'Hiburan & Modern',
    imageUrl:
        'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/rsfit1440960gsm/events/2024/08/13/d839b079-17a4-434a-8085-8413f49aadbe-1723529516302-8c4aa7a75a1faf6b37b1a6dee6fd5059.jpg',
    rating: 4.8,
    reviews: 11000,
    ticketPrice: 'Rp 150.000 - Rp 185.000',
    openHours: '10:00 - 21:00',
    gallery: [],
    facts: [
      'Ada hiu paus dan ratusan spesies ikan yang bisa dilihat dari terowongan kaca bawah laut!',
      'Terdapat lebih dari 10.000 biota laut dari berbagai penjuru Indonesia',
      'Ada zona Tropical Rainforest dengan satwa darat seperti singa, harimau, dan orangutan',
    ],
  ),
  DestinationModel(
    id: 'dest_9',
    quizId: 'q9',
    name: 'Planetarium Jakarta',
    description:
        'Planetarium Jakarta adalah gedung pertunjukan astronomi pertama di Indonesia, diresmikan pada 10 November 1964 bertepatan dengan Hari Pahlawan.',
    location: 'Jakarta Pusat',
    category: 'Hiburan & Modern',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Planetarium_dan_Observatorium_Jakarta_%28Januari_2025%29.jpg/500px-Planetarium_dan_Observatorium_Jakarta_%28Januari_2025%29.jpg',
    rating: 4.6,
    reviews: 6700,
    ticketPrice: 'Rp 5.000',
    openHours: '09:00 - 16:00',
    gallery: [],
    facts: [
      'Layar kubah raksasa berdiameter 23 meter memproyeksikan ribuan bintang!',
      'Kamu bisa "terbang" ke luar angkasa dan keliling tata surya tanpa meninggalkan kursi!',
      'Ada teleskop besar yang bisa dipakai untuk melihat bintang saat malam langit cerah',
    ],
  ),
  DestinationModel(
    id: 'dest_10',
    quizId: 'q10',
    name: 'Taman Burung TMII',
    description:
        'Taman Burung yang berada di dalam kawasan TMII adalah salah satu taman burung terbesar di Asia, menampung lebih dari 1.500 ekor burung dari 150 spesies berbeda.',
    location: 'Jakarta Timur',
    category: 'Hiburan & Modern',
    imageUrl:
        'https://tamanmini.com/taman_jelajah_indonesia/wp-content/uploads/2023/07/maxresdefault.jpg',
    rating: 4.5,
    reviews: 5800,
    ticketPrice: 'Rp 50.000',
    openHours: '09:00 - 16:00',
    gallery: [],
    facts: [
      'Ada burung Cendrawasih — burung paling cantik di dunia yang hanya ada di Papua!',
      'Burung Elang Jawa yang hampir punah bisa kamu lihat langsung di sini',
      'Ada kandang burung raksasa yang bisa dimasuki — burung terbang bebas di sekitar kamu!',
    ],
  ),

  // --- KATEGORI 3: ALAM & TAMAN ---
  DestinationModel(
    id: 'dest_11',
    quizId: 'q11',
    name: 'Kepulauan Seribu',
    description:
        'Kepulauan Seribu adalah gugusan 110 pulau di Teluk Jakarta. Nelayan di sini masih menjalankan tradisi Sedekah Laut (Nadran) — ritual syukuran sebelum musim melaut.',
    location: 'Jakarta Utara',
    category: 'Alam & Taman',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/East_side_of_Pari_Island%2C_Kepulauan_Seribu_National_Park.jpg/960px-East_side_of_Pari_Island%2C_Kepulauan_Seribu_National_Park.jpg',
    rating: 4.7,
    reviews: 14200,
    ticketPrice: 'Rp 500.000',
    openHours: '24 Jam',
    gallery: [],
    facts: [
      'Ada pulau yang namanya lucu-lucu: Pulau Bidadari, Pulau Pari, Pulau Tidung!',
      'Terumbu karangnya dihuni lebih dari 200 spesies ikan warna-warni!',
      'Sunset-nya terkenal jadi salah satu yang terindah di seluruh Jakarta!',
    ],
  ),
  DestinationModel(
    id: 'dest_12',
    quizId: 'q12',
    name: 'Hutan Kota Srengseng',
    description:
        'Hutan Kota Srengseng adalah salah satu paru-paru kota Jakarta yang terletak di Jakarta Barat, mencakup area seluas 15,6 hektar.',
    location: 'Jakarta Barat',
    category: 'Alam & Taman',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Taman_kota_di_srengseng_jakarta.jpg/500px-Taman_kota_di_srengseng_jakarta.jpg',
    rating: 4.4,
    reviews: 3500,
    ticketPrice: 'Gratis',
    openHours: '06:00 - 18:00',
    gallery: [],
    facts: [
      'Ada lebih dari 100 jenis pohon berbeda yang tumbuh di sini!',
      'Berbagai jenis kupu-kupu dan burung liar bisa ditemui di pagi hari',
      'Ada danau kecil yang tenang untuk memancing dan piknik keluarga',
    ],
  ),
  DestinationModel(
    id: 'dest_13',
    quizId: 'q13',
    name: 'Ragunan',
    description:
        'Ragunan adalah kebun binatang tertua di Indonesia, pertama kali dibuka pada 1864. Ini adalah pusat konservasi satwa yang terancam punah asli Indonesia.',
    location: 'Jakarta Selatan',
    category: 'Alam & Taman',
    imageUrl:
        'https://www.99.co/id/_next/image?url=https%3A%2F%2Fassets-id.99.co%2Fprod%2Fassets%2FKebun_Binatang_Ragunan_24e00c752e%2FKebun_Binatang_Ragunan_24e00c752e.jpg&w=2048&q=85',
    rating: 4.5,
    reviews: 28000,
    ticketPrice: 'Rp 4.000',
    openHours: '06:00 - 18:00',
    gallery: [],
    facts: [
      'Ada gorila dan orangutan yang sangat menggemaskan dan mirip manusia!',
      'Badak bercula satu yang hampir punah bisa dilihat di sini!',
      'Ada Pusat Primata Schmutzer — kandang primata terbesar di Asia Tenggara!',
    ],
  ),
  DestinationModel(
    id: 'dest_14',
    quizId: 'q14',
    name: 'Pantai Marunda',
    description:
        'Pantai Marunda terletak di Jakarta Utara dan merupakan salah satu pantai umum yang bisa diakses gratis. Kawasan ini terkait dengan tokoh Si Pitung — jagoan Betawi pembela rakyat kecil.',
    location: 'Jakarta Utara',
    category: 'Alam & Taman',
    imageUrl:
        'https://ik.imagekit.io/tvlk/blog/2025/03/Pantai-Marunda-dekstop.png?tr=q-70,c-at_max,w-500,h-250,dpr-2',
    rating: 4.2,
    reviews: 2100,
    ticketPrice: 'Gratis',
    openHours: '24 Jam',
    gallery: [],
    facts: [
      'Ada rumah Si Pitung yang masih berdiri dan bisa dikunjungi!',
      'Pantai ini menghadap langsung ke Laut Jawa — bisa lihat kapal besar lewat!',
      'Matahari terbit di sini sangat indah untuk foto-foto!',
    ],
  ),
  DestinationModel(
    id: 'dest_15',
    quizId: 'q15',
    name: 'Pantai Ancol',
    description:
        'Pantai Ancol membentang sepanjang 3 kilometer di tepi utara Jakarta, menjadikannya pantai kota paling panjang yang bisa diakses warga ibu kota.',
    location: 'Jakarta Utara',
    category: 'Alam & Taman',
    imageUrl:
        'https://www.ancol.com/blog/wp-content/uploads/2022/03/wisata-pantai-di-jakarta.jpg',
    rating: 4.5,
    reviews: 18500,
    ticketPrice: 'Rp 30.000',
    openHours: '24 Jam',
    gallery: [],
    facts: [
      'Panjang pantainya 3 km — bisa jalan kaki panjang sambil lihat laut!',
      'Ancol adalah tempat terbaik melihat matahari terbenam di sisi barat Jakarta',
      'Setiap malam tahun baru, pesta kembang api terbesar Jakarta digelar di sini!',
    ],
  ),

  // --- KATEGORI 4: RELIGI & SPIRITUAL ---
  DestinationModel(
    id: 'dest_16',
    quizId: 'q16',
    name: 'Masjid Istiqlal',
    description:
        'Masjid Istiqlal adalah masjid negara sekaligus terbesar di Asia Tenggara. Nama "Istiqlal" artinya "Kemerdekaan" dalam bahasa Arab.',
    location: 'Jakarta Pusat',
    category: 'Religi & Spiritual',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/id/thumb/2/25/Masjid_Istiqlal_-_Panoramio.jpg/960px-Masjid_Istiqlal_-_Panoramio.jpg',
    rating: 4.9,
    reviews: 45000,
    ticketPrice: 'Gratis',
    openHours: '04:00 - 21:00',
    gallery: [],
    facts: [
      'Bisa menampung 200.000 orang — bayangkan stadion bola penuh diisi 3 kali!',
      'Kubah utamanya berdiameter 45 meter — melambangkan tahun 1945!',
      'Lokasinya tepat berseberangan dengan Gereja Katedral — simbol kerukunan!',
    ],
  ),
  DestinationModel(
    id: 'dest_17',
    quizId: 'q17',
    name: 'Gereja Katedral Jakarta',
    description:
        'Gereja Katedral Jakarta adalah katedral Katolik yang dibangun dengan gaya arsitektur Neo-Gotik khas Eropa. Berdiri sejak 1901.',
    location: 'Jakarta Pusat',
    category: 'Religi & Spiritual',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Jakarta_Indonesia_Jakarta-Cathedral-10.jpg/960px-Jakarta_Indonesia_Jakarta-Cathedral-10.jpg',
    rating: 4.8,
    reviews: 12400,
    ticketPrice: 'Gratis',
    openHours: '06:00 - 20:00',
    gallery: [],
    facts: [
      'Menara gerejanya setinggi 60 meter — terlihat dari kejauhan!',
      'Jendela kacanya sangat indah — disebut kaca patri dengan warna-warna cerah',
      'Tepat berseberangan dengan Masjid Istiqlal — simbol kerukunan umat beragama',
    ],
  ),
  DestinationModel(
    id: 'dest_18',
    quizId: 'q18',
    name: 'Vihara Dharma Bhakti',
    description:
        'Vihara Dharma Bhakti atau Klenteng Jin De Yuan adalah klenteng tertua di Jakarta, berdiri sejak tahun 1650.',
    location: 'Jakarta Barat',
    category: 'Religi & Spiritual',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Klenteng_Jin_De_Yuan%2C_Glodok%2C_Jakarta.jpg/960px-Klenteng_Jin_De_Yuan%2C_Glodok%2C_Jakarta.jpg',
    rating: 4.6,
    reviews: 5100,
    ticketPrice: 'Gratis',
    openHours: '06:00 - 21:00',
    gallery: [],
    facts: [
      'Setiap Imlek, ribuan lampion merah dinyalakan — sangat indah dan meriah!',
      'Ada pertunjukan barongsai (singa menari) yang seru saat perayaan!',
      'Vihara ini sudah berumur lebih dari 370 tahun — tertua di Jakarta!',
    ],
  ),
  DestinationModel(
    id: 'dest_19',
    quizId: 'q19',
    name: 'Masjid Kebon Jeruk',
    description:
        'Masjid Kebon Jeruk atau Masjid Al-Anshor adalah salah satu masjid tertua di Jakarta dengan arsitektur unik yang memadukan gaya Tionghoa dan Islam.',
    location: 'Jakarta Barat',
    category: 'Religi & Spiritual',
    imageUrl:
        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/39/5a/b9/caption.jpg?w=1400&h=800&s=1',
    rating: 4.5,
    reviews: 2100,
    ticketPrice: 'Gratis',
    openHours: '24 Jam',
    gallery: [],
    facts: [
      'Arsitekturnya perpaduan gaya Cina dan Arab — unik banget!',
      'Dinding masjidnya menggunakan batu bata merah kuno yang sangat tebal',
      'Ornamen dan ukiran di masjid ini sangat indah dan penuh detail',
    ],
  ),
  DestinationModel(
    id: 'dest_20',
    quizId: 'q20',
    name: 'Pura Aditya Jaya',
    description:
        'Pura Aditya Jaya di Rawamangun, Jakarta Timur adalah pura Hindu terbesar di Jakarta, menunjukkan bahwa ibu kota adalah rumah bagi semua agama.',
    location: 'Jakarta Timur',
    category: 'Religi & Spiritual',
    imageUrl:
        'https://multimedia.beritajakarta.id/photo/potret_jakarta/009b7492de89ad71b21f1cff0af7eae3.jpg',
    rating: 4.7,
    reviews: 3200,
    ticketPrice: 'Gratis',
    openHours: '06:00 - 18:00',
    gallery: [],
    facts: [
      'Gapura dan ornamentnya mirip sekali dengan pura-pura di Bali!',
      'Saat Hari Raya Nyepi dan Galungan, pura ini sangat ramai dan meriah',
      'Suasana di dalam pura sangat tenang dan damai — cocok untuk meditasi',
    ],
  ),
];
