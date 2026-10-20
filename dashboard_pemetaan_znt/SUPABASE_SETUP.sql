-- DASHBOARD PEMETAAN ZNT
-- Jalankan seluruh skrip ini di Supabase > SQL Editor > New query.
-- Dashboard menggunakan akses baca publik; hanya user yang tercatat di znt_admins boleh mengubah data.

create table if not exists public.znt_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.znt_zones (
  id text primary key,
  target integer not null default 5 check (target >= 0),
  surveyor text not null default '',
  feature jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.znt_samples (
  id text primary key,
  lat double precision not null,
  lng double precision not null,
  sample_date date,
  value numeric,
  surveyor text not null default '',
  created_at timestamptz not null default now(),
  constraint znt_samples_lat_range check (lat between -90 and 90),
  constraint znt_samples_lng_range check (lng between -180 and 180)
);

alter table public.znt_admins enable row level security;
alter table public.znt_zones enable row level security;
alter table public.znt_samples enable row level security;

-- User hanya boleh melihat baris admin miliknya sendiri; tidak ada akses tulis dari browser.
drop policy if exists "admin can read own admin row" on public.znt_admins;
create policy "admin can read own admin row" on public.znt_admins
  for select to authenticated using (user_id = (select auth.uid()));

-- Pengunjung tanpa login boleh melihat data dashboard.
drop policy if exists "public can read zones" on public.znt_zones;
create policy "public can read zones" on public.znt_zones
  for select to anon, authenticated using (true);

drop policy if exists "public can read samples" on public.znt_samples;
create policy "public can read samples" on public.znt_samples
  for select to anon, authenticated using (true);

-- Hanya akun yang user_id-nya dimasukkan ke znt_admins boleh menulis data.
drop policy if exists "admins can insert zones" on public.znt_zones;
create policy "admins can insert zones" on public.znt_zones
  for insert to authenticated with check (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  );
drop policy if exists "admins can update zones" on public.znt_zones;
create policy "admins can update zones" on public.znt_zones
  for update to authenticated using (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  ) with check (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  );
drop policy if exists "admins can delete zones" on public.znt_zones;
create policy "admins can delete zones" on public.znt_zones
  for delete to authenticated using (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  );

drop policy if exists "admins can insert samples" on public.znt_samples;
create policy "admins can insert samples" on public.znt_samples
  for insert to authenticated with check (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  );
drop policy if exists "admins can update samples" on public.znt_samples;
create policy "admins can update samples" on public.znt_samples
  for update to authenticated using (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  ) with check (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  );
drop policy if exists "admins can delete samples" on public.znt_samples;
create policy "admins can delete samples" on public.znt_samples
  for delete to authenticated using (
    exists (select 1 from public.znt_admins a where a.user_id = (select auth.uid()))
  );

grant select on public.znt_zones, public.znt_samples to anon, authenticated;
grant select on public.znt_admins to authenticated;
grant insert, update, delete on public.znt_zones, public.znt_samples to authenticated;

-- LANGKAH PENTING SETELAH MEMBUAT AKUN ADMIN:
-- 1. Buat akun di Supabase > Authentication > Users > Add user.
-- 2. Salin UUID user tersebut.
-- 3. Ganti UUID_DI_SINI pada query berikut, lalu jalankan query terpisah:
-- insert into public.znt_admins (user_id) values ('UUID_DI_SINI');
