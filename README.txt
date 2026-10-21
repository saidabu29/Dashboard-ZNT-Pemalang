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
