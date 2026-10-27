# Course Explorer v2

Aplikasi Flutter untuk menampilkan daftar mata kuliah (*course*), melihat detail mata kuliah, dan mengelola daftar favorit menggunakan Provider.

## Identitas Mahasiswa

- **Nama:** Ni Komang Trisna Cahyani
- **NIM:** 2415051072
- **Program Studi:** Pendidikan Teknik Informatika
- **Mata Kuliah:** Pemrograman Mobile

## Fitur Aplikasi

- Menampilkan daftar course dari file JSON.
- Menampilkan detail setiap course.
- Menambahkan dan menghapus course dari daftar favorit.
- Menyinkronkan status favorit pada beberapa halaman menggunakan Provider.
- Menampilkan status loading dan error saat memuat data.
- Menyediakan navigasi responsif menggunakan BottomNavigationBar dan NavigationRail.

## Struktur Folder

```text
lib/
├── main.dart
├── course_state.dart
├── models/
│   └── course.dart
├── services/
│   └── course_service.dart
├── repositories/
│   └── course_repository.dart
├── providers/
│   └── course_provider.dart
├── screens/
│   ├── main_page.dart
│   ├── detail_page.dart
│   └── favorites_page.dart
└── widgets/
    ├── course_card.dart
    └── student_identity_card.dart
```

## Tanggung Jawab Setiap Folder

- **models/**: Mendefinisikan struktur data course dan mengonversi data JSON menjadi objek.
- **services/**: Membaca dan mengolah data dari sumber data.
- **repositories/**: Menjadi perantara antara Provider dan Service dalam menyediakan data.
- **providers/**: Mengelola state aplikasi, termasuk daftar course, loading, error, dan favorit.
- **screens/**: Menyusun halaman Courses, Detail, dan Favorites.
- **widgets/**: Menyimpan komponen UI yang dapat digunakan kembali.
- **main.dart**: Menjadi titik awal aplikasi serta mengatur Provider dan tema aplikasi.
- **course_state.dart**: Menyimpan pengelolaan state course sesuai implementasi project.

## Architecture dan Dependency Direction

Aplikasi menggunakan pemisahan tanggung jawab dengan arah dependency:

**Screen/Widget → Provider → Repository → Service/Data Source**

Screen dan Widget berfokus pada tampilan serta interaksi pengguna. Provider mengelola state dan memberi tahu widget ketika data berubah. Repository menjadi perantara akses data, sedangkan Service bertanggung jawab membaca dan mengolah sumber data.

UI tidak membaca file JSON secara langsung melalui `rootBundle` atau mengolahnya menggunakan `jsonDecode`. Selain itu, Provider tidak menyimpan `BuildContext` sebagai state dan Service tidak menangani tampilan UI.

Pemisahan ini membantu membuat kode lebih terstruktur, mudah dipahami, dan lebih mudah dipelihara.

## Teknologi yang Digunakan

- Flutter
- Dart
- Provider
- JSON
- HTTP
- Git dan GitHub

## Cara Menjalankan Aplikasi

1. Pastikan Flutter dan Dart sudah terpasang.
2. Buka folder proyek di VS Code.
3. Jalankan perintah berikut di terminal:

```bash
flutter pub get
flutter analyze
flutter run
```

## Hasil Audit Tahap 16

Audit dilakukan untuk memastikan setiap layer memiliki tanggung jawab yang jelas, arah dependency sesuai dengan rancangan, dan pembacaan JSON hanya dilakukan pada Service. Dokumentasi tanggung jawab setiap folder ditambahkan sebagai bagian dari pemeliharaan arsitektur aplikasi.

## Tahap 1 — Membaca REST Endpoint dan JSON

### Identifikasi Endpoint

- **Endpoint:** https://course-api-pearl.vercel.app/courses
- **HTTP Method:** GET
- **Status Code:** 200 OK (sesuai hasil pengujian)
- **Resource:** courses
- **Format Response:** JSON array

### Field JSON yang Ditemukan

Berdasarkan response JSON yang diperoleh dari endpoint, ditemukan beberapa field berikut:

1. `id`: identitas unik course.
2. `code`: kode course.
3. `title`: judul course.
4. `credits`: jumlah kredit course.
5. `status`: status course.
6. `created_at`: waktu pembuatan data course.

### Contoh Response JSON

```json
[
  {
    "id": 4,
    "code": "MOB04",
    "title": "State Management Provider",
    "credits": 2,
    "status": "done",
    "created_at": "2026-10-21T03:28:09.576271Z"
  }
]
```

Contoh di atas menampilkan satu objek course. Response asli dari endpoint dapat berisi beberapa objek course.

### Catatan Pengamatan

Pada Tahap 1, dilakukan pengamatan terhadap REST API menggunakan metode GET pada endpoint yang diberikan oleh dosen. Endpoint tersebut digunakan untuk mengambil daftar course dari server dengan response berbentuk array JSON.

Setiap objek course memiliki field `id`, `code`, `title`, `credits`, `status`, dan `created_at`. Pengamatan ini membantu memahami URL endpoint, metode HTTP, struktur response, serta field data yang akan digunakan pada tahap integrasi REST API dalam aplikasi Course Explorer v2.

### Bukti Praktikum

- **Screenshot Kode / Editor:** Dokumentasi endpoint dan field JSON pada README.md.
- **Screenshot Hasil / Emulator atau Device:** Tampilan response JSON dari browser atau Postman.
