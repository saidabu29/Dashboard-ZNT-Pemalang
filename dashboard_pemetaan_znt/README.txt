DASHBOARD PEMETAAN ZNT — VERSI SUPABASE

ISI PAKET
- index.html: dashboard web.
- SUPABASE_SETUP.sql: skema tabel dan kebijakan keamanan Row Level Security (RLS).

FITUR YANG DIPERTAHANKAN
- Peta zona ZNT dan titik sampel.
- Impor polygon dari ZIP Shapefile atau GeoJSON.
- Impor CSV sampel.
- Tren harian memakai tanggal pelaksanaan sampel.
- Grafik jumlah sampel per nama surveyor dengan angka pada batang grafik.
- Rekap target/realisasi per zona, status capaian, rata-rata nilai tanah, dan ekspor CSV.
- Pengunjung dapat melihat dashboard tanpa login.
- Hanya akun yang secara eksplisit didaftarkan pada tabel znt_admins yang dapat login dan mengubah data.

LANGKAH SETUP SINGKAT
1. Buat project di https://supabase.com/.
2. Buka SQL Editor dan jalankan seluruh isi SUPABASE_SETUP.sql.
3. Buka Project Settings / API (atau Connect), salin Project URL dan publishable key. Key lama bernama anon key juga dapat digunakan untuk frontend jika project Anda menampilkannya. JANGAN gunakan service_role/secret key di HTML.
4. Buka index.html dengan editor teks. Cari SUPABASE_URL dan SUPABASE_PUBLISHABLE_KEY, lalu ganti nilai contoh dengan milik project Anda.
5. Di Supabase Authentication > Users, buat akun email/password untuk admin.
6. Salin UUID akun admin. Di SQL Editor jalankan: insert into public.znt_admins (user_id) values ('UUID-AKUN-ADMIN'); ganti UUID-AKUN-ADMIN dengan UUID asli.
7. Upload index.html dan SUPABASE_SETUP.sql ke repository GitHub (README juga boleh diunggah).
8. Aktifkan GitHub Pages dari Settings > Pages > Deploy from a branch > main > /(root).
9. Buka URL GitHub Pages. Dashboard membaca data dari Supabase; admin klik Login Admin untuk mengelola data.
10. Login sebagai admin, lalu impor ZIP Shapefile/GeoJSON zona dan CSV sampel. Data zona/sampel akan tersimpan di Supabase.

FORMAT CSV YANG DISARANKAN
id_sampel,tanggal_pelaksanaan_sampel,latitude,longitude,nilai_tanah,nama_surveyor
S-001,2026-10-20,-7.0000,110.0000,2500000,Andi

CATATAN KEAMANAN DAN BATASAN
- SQL RLS membuat pembacaan data terbuka untuk pengunjung, sedangkan insert/update/delete hanya untuk admin terdaftar. Jangan menghapus atau melonggarkan kebijakan RLS.
- Karena data dibuka untuk publik, semua kolom pada tabel znt_samples dan znt_zones dapat dibaca lewat API publik. Jangan unggah koordinat atau nilai tanah yang bersifat rahasia. Jika data tidak boleh dipublikasikan, perlu dibuat tampilan publik dengan kolom terbatas atau akses baca juga dibatasi.
- Publishable key/anon key boleh ada di frontend jika RLS aktif. Service role/secret key tidak boleh pernah dimasukkan ke HTML atau GitHub.
- Paket ini adalah kerangka integrasi yang perlu dikonfigurasi dengan URL/key Supabase dan diuji setelah tabel, akun admin, serta RLS disiapkan.
- Saat mengimpor ulang zona, data zona dengan ID sama akan diperbarui. Zona lama yang ID-nya tidak ada di file baru tidak otomatis dihapus. Sampel dengan ID yang sudah ada dilewati saat impor CSV.
- Tombol simulasi hanya untuk mencoba tampilan dan bukan data survei asli.
