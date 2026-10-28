DASHBOARD PEMETAAN ZNT — GEOJSON + SUPABASE

1. Zona sekarang diimpor dari file GeoJSON (.geojson atau .json), bukan ZIP SHP.
   GeoJSON harus berisi FeatureCollection/Feature dengan geometri Polygon atau MultiPolygon.
   Pastikan koordinat GeoJSON menggunakan WGS84 longitude/latitude (EPSG:4326).
2. Titik sampel tetap diimpor dari CSV.
3. Buka index.html dan isi SUPABASE_URL serta SUPABASE_PUBLISHABLE_KEY dengan nilai project Anda.
4. Di Supabase > SQL Editor, jalankan seluruh isi SUPABASE_SETUP.sql.
   Jika tabel sudah ada, periksa struktur dan policies sebelum menjalankan ulang.
5. Buat admin melalui Supabase > Authentication > Users. Salin UUID user dan jalankan:
   insert into public.znt_admins (user_id) values ('UUID_ADMIN_ANDA');
6. Unggah index.html ke root repository GitHub Anda dan aktifkan Settings > Pages > Deploy from a branch > main > /(root).
7. Buka website, login admin, pilih GeoJSON zona. Pesan di dashboard akan menunjukkan status penyimpanan.
8. Periksa Supabase > Table Editor > znt_zones untuk memastikan zona tersimpan.

KEAMANAN:
- Gunakan hanya publishable key/anon key pada HTML.
- Jangan memasukkan service_role/secret key ke file HTML.
- Data zona/sampel yang dapat dibaca publik harus memang aman untuk dipublikasikan.
- Jika upload gagal, buka F12 > Console dan periksa pesan error.


Pembaruan fitur:
- Saat memilih CSV, pilih kolom pada 'KOLOM UNTUK RATA-RATA NILAI TANAH' sebelum menekan 'Muat CSV Terpilih'. Kolom yang dipilih digunakan untuk menghitung rata-rata nilai tanah pada rekapitulasi zona.
- Klik baris zona pada tabel rekapitulasi untuk zoom peta ke batas zona tersebut. Tombol Rincian tetap membuka detail zona.


Pembaruan statistik rekapitulasi:
- Rata-rata nilai tanah, Standar Deviasi Sampel (SD, pembagi n-1), dan SBR (%) dihitung per zona berdasarkan kolom nilai tanah yang dipilih ketika impor CSV.
- Rumus SD = akar dari jumlah kuadrat (nilai - rata-rata) dibagi (n-1). SBR = SD / |rata-rata| x 100%.
- SD ditampilkan sebagai — bila kurang dari dua nilai valid dalam zona; SBR ditampilkan sebagai — bila SD tidak tersedia atau rata-rata nol.
- Ekspor CSV rekapitulasi mencakup kolom rata-rata, SD, dan SBR.


PERBAIKAN PAGINATION DATA SUPABASE
Dashboard sekarang memuat tabel znt_zones dan znt_samples secara bertahap dengan range 1.000 baris per permintaan hingga seluruh baris selesai dibaca. Impor sampel disimpan dalam batch 500 baris. Setelah memasang, periksa notifikasi jumlah zona dan sampel yang dimuat.


FITUR NAMA SURVEYOR BERDASARKAN DATA ZONA & LEGENDA PETA
- Nama surveyor pada tabel rekapitulasi dan grafik jumlah zona per surveyor diambil dari atribut pada data zona, bukan disimpulkan dari titik sampel.
- Setelah memuat GeoJSON zona, pilih kolom nama surveyor pada pilihan "ATRIBUT NAMA SURVEYOR PADA DATA ZONA". Dashboard mencoba mendeteksi otomatis kolom yang mengandung nama surveyor/petugas/pelaksana; periksa dan pilih kolom yang benar.
- Perubahan pilihan kolom surveyor akan memperbarui nama surveyor pada zona dan menyimpannya ke Supabase.
- Pada peta, pilihan "Keseluruhan zona (status)" mewarnai zona berdasarkan status target (Terpenuhi/Kurang/Kosong).
- Pilihan "Warna berdasarkan surveyor" memberi warna berbeda untuk setiap nama surveyor dan menampilkan legenda nama surveyor.
- Pilihan "Semua surveyor" atau nama surveyor tertentu dapat digunakan untuk menampilkan semua zona atau hanya zona milik surveyor terpilih.

FITUR VISUALISASI SBR PADA PETA
- Pada pilihan mode warna peta, pilih "Kategori SBR (<25%, 25–100%, >100%)" untuk mewarnai poligon zona menurut nilai SBR.
- Hijau: SBR <25%; kuning: SBR 25–100%; merah: SBR >100%; abu-abu: SBR tidak tersedia.
- SBR dihitung dari nilai sampel valid di dalam zona: SD sampel (pembagi n-1) dibagi nilai absolut rata-rata, lalu dikali 100%.
- Zona memerlukan minimal dua nilai sampel valid dan rata-rata tidak boleh nol agar SBR dapat dihitung. Klik zona untuk melihat nilai dan kategori SBR.
- Pilihan mode ini hanya mengubah pewarnaan/visualisasi peta; tidak mengubah data sampel, target zona, maupun perhitungan ketercapaian.
