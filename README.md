# Docker Service

## 📝 Deskripsi

Comming soon!

## ⚙️ Instalasi

1. **Fork** repository ini ke akun GitHub Anda.
2. **Clone** repository yang telah Anda fork ke komputer lokal:

   ```bash
   git clone https://github.com/<username>/<repo>.git
   cd <repo>
   ```

   > Gantilah `<username>` dengan nama pengguna GitHub Anda dan `<repo>` dengan nama repository yang telah di-fork.

## 🚀 Penggunaan

1. Masuk ke direktori project:

   ```bash
   cd <repo>
   ```

   > Gantilah `<repo>` dengan nama folder project yang telah Anda clone.

2. Pilih layanan yang ingin Anda gunakan:

   - `mysql-phpmyadmin`
   - `postgresql-pgadmin`

   Masuk ke folder layanan yang dipilih:

   ```bash
   cd mysql-phpmyadmin
   # atau
   cd postgresql-pgadmin
   ```

3. Salin file `.env.example` dan ubah namanya menjadi `.env`:

   ```bash
   cp .env.example .env
   ```

4. **Edit file `.env`** sesuai kebutuhan. Anda dapat mengubah:

   - Username
   - Password
   - Nama database
   - Port akses

   > File `.env` digunakan oleh Docker Compose untuk mengatur konfigurasi layanan.

5. Jalankan layanan menggunakan perintah:

   ```bash
   docker-compose up -d
   ```

   > Perintah ini akan membangun dan menjalankan kontainer di background.

6. **Akses layanan melalui browser** sesuai dengan port yang telah Anda tentukan di file `.env`:

   - **MySQL & PhpMyAdmin**:

     - PhpMyAdmin: `http://localhost:8080`
     - MySQL: `localhost:3306`

   - **PostgreSQL & PgAdmin**:
     - PgAdmin: `http://localhost:8081`
     - PostgreSQL: `localhost:5432`

7. Untuk **menghentikan layanan**, gunakan perintah:

   ```bash
   docker-compose down
   ```

   > Ini akan menghentikan dan menghapus semua kontainer yang sedang berjalan.
