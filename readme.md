# 🚀 Docker Service

Repositori ini berisi konfigurasi dan sumber daya untuk menjalankan semua layanan secara lokal menggunakan Docker. Termasuk _Dockerfile_, _Docker Compose_, dan skrip untuk mempermudah pengelolaan serta orkestrasi layanan dalam lingkungan kontainer.

## 📌 Cara Menggunakan dan Setup

### 1️⃣ Clone Repository

Clone repositori ini ke mesin lokal Anda:

```bash
git clone https://github.com/anggamys/docker-service.git
cd docker-service
```

### 2️⃣ Install Docker dan Docker Compose

Pastikan Docker dan Docker Compose sudah terinstal di sistem Anda. Jika belum, ikuti panduan instalasi berikut:

- [Instalasi Docker](https://docs.docker.com/get-docker/)
- [Instalasi Docker Compose](https://docs.docker.com/compose/install/)

### 3️⃣ Pilih Layanan

Masuk ke salah satu folder layanan, misalnya `mysql-phpmyadmin`:

```bash
cd mysql-phpmyadmin
```

### 4️⃣ Konfigurasi Lingkungan

Periksa dan sesuaikan file konfigurasi seperti `.env` atau `docker-compose.yml` jika diperlukan.

### 5️⃣ Bangun dan Jalankan Layanan

Gunakan perintah berikut untuk membangun dan menjalankan semua layanan:

```bash
docker-compose up --build
```

### 6️⃣ Akses Layanan

Setelah semua kontainer berjalan, akses layanan melalui URL atau port yang telah dikonfigurasi dalam `docker-compose.yml`.

### 7️⃣ Hentikan Layanan

Untuk menghentikan semua layanan, gunakan perintah berikut:

```bash
docker-compose down
```

---

Repositori ini dirancang untuk mempermudah pengelolaan layanan berbasis Docker secara lokal. Selamat mencoba! 🚀
