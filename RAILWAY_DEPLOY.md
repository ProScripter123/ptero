# 🚀 Deploy Pterodactyl Panel ke Railway

Deploy Pterodactyl Panel ke Railway dengan satu klik! Setup lengkap dengan MySQL dan Redis.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/pterodactyl)

## 📋 Apa yang Termasuk?

Setup ini akan deploy:
- ✅ **Pterodactyl Panel** - Web interface untuk manage game servers
- ✅ **MySQL 8.0** - Database untuk panel
- ✅ **Redis 7.2** - Cache dan queue management
- ✅ **Nginx** - Web server yang sudah dikonfigurasi
- ✅ **Queue Workers** - Background job processing
- ✅ **Scheduler** - Automated tasks

## ⚠️ Penting untuk Diketahui

> **Deployment ini hanya untuk PANEL (web interface)**
> 
> Pterodactyl membutuhkan 2 komponen terpisah:
> 1. **Panel** (ini yang di-deploy ke Railway) - untuk web interface
> 2. **Wings** (perlu deploy terpisah) - untuk menjalankan game servers
>
> Setelah Panel di-deploy, Anda masih perlu setup Wings di server dengan Docker support.

## 🎯 Method 1: One-Click Deploy (Recommended)

1. Klik tombol **Deploy on Railway** di atas
2. Login ke Railway (bisa pakai GitHub)
3. Railway akan otomatis:
   - Setup MySQL database
   - Setup Redis
   - Deploy Pterodactyl Panel
   - Configure networking

4. **Generate Domain**:
   - Buka service **pterodactyl-panel** di Railway
   - Klik tab **Settings**
   - Scroll ke **Networking** → klik **Generate Domain**
   - Copy domain yang di-generate (contoh: `your-app.up.railway.app`)

5. **Update APP_URL**:
   - Di service **pterodactyl-panel**, buka tab **Variables**
   - Set `APP_URL` = `https://your-app.up.railway.app` (ganti dengan domain Anda)
   - Redeploy service

6. **Create Admin User**:
   ```bash
   # Install Railway CLI
   npm i -g @railway/cli
   
   # Login ke Railway
   railway login
   
   # Link ke project
   railway link
   
   # Create admin user
   railway run -s pterodactyl-panel bash scripts/create-admin.sh
   ```
   
   Ikuti prompt untuk setup admin user (email, username, password, dll)

7. **Access Panel**:
   - Buka `https://your-app.up.railway.app`
   - Login dengan credentials admin yang baru dibuat
   - Done! Panel sudah siap digunakan 🎉

## 🔧 Method 2: Manual Deploy dari GitHub

### Prerequisites
- Railway account
- GitHub account

### Steps

1. **Fork Repository**
   ```bash
   git clone https://github.com/pterodactyl-installer/pterodactyl-installer.git
   cd pterodactyl-installer
   ```

2. **Push ke GitHub Anda**
   ```bash
   git remote set-url origin https://github.com/YOUR_USERNAME/pterodactyl-installer.git
   git push -u origin master
   ```

3. **Deploy ke Railway**
   - Login ke [Railway](https://railway.app)
   - Klik **New Project**
   - Pilih **Deploy from GitHub repo**
   - Select repository yang baru di-push

4. **Add MySQL Database**
   - Klik **New** → **Database** → **Add MySQL**
   - Railway akan otomatis inject environment variables

5. **Add Redis**
   - Klik **New** → **Database** → **Add Redis**
   - Railway akan otomatis inject environment variables

6. **Configure Environment Variables**
   
   Di service Panel, tambahkan variables berikut:
   
   ```env
   APP_NAME=Pterodactyl
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://your-app.up.railway.app
   APP_TIMEZONE=Asia/Jakarta
   
   CACHE_DRIVER=redis
   SESSION_DRIVER=redis
   QUEUE_CONNECTION=redis
   
   TRUSTED_PROXIES=*
   ```
   
   > **Note**: `DB_*` dan `REDIS_*` variables otomatis diisi oleh Railway

7. **Generate Domain & Update APP_URL**
   - Generate domain di Settings → Networking
   - Update `APP_URL` dengan domain yang di-generate
   - Redeploy

8. **Create Admin User** (lihat Method 1 step 6)

## 📱 Post-Deployment Setup

### Create Admin User (Detail)

Setelah deployment berhasil, buat admin user:

```bash
# Via Railway CLI
railway run -s pterodactyl-panel php artisan p:user:make
```

Anda akan diminta input:
- **Email**: Email admin
- **Username**: Username admin
- **First Name**: Nama depan
- **Last Name**: Nama belakang
- **Password**: Password (min 8 karakter)
- **Admin**: Pilih `yes` untuk admin privileges

### Configure Mail (Optional)

Untuk email notifications, update environment variables:

```env
MAIL_DRIVER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_FROM=noreply@yourdomain.com
MAIL_FROM_NAME=Pterodactyl
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
```

## 🎮 Connecting Wings Nodes

Setelah Panel ready, Anda perlu setup Wings untuk run game servers:

1. **Prepare Wings Server**
   - Server dengan Docker installed
   - Minimal 2GB RAM
   - Public IP address

2. **Add Location di Panel**
   - Login ke Panel
   - Admin → Locations → Create New
   - Nama location (contoh: "US-East")

3. **Create Node**
   - Admin → Nodes → Create New
   - Isi details:
     - Name: Nama node
     - Location: Pilih location yang dibuat
     - FQDN: IP atau domain Wings server
     - Ports: Allocation ports untuk game servers
   
4. **Install Wings di Server**
   ```bash
   # Di Wings server
   bash <(curl -s https://pterodactyl-installer.se)
   # Pilih option "Install Wings"
   ```

5. **Configure Wings**
   - Di Panel, buka node yang dibuat
   - Tab **Configuration** → copy configuration
   - Di Wings server: `/etc/pterodactyl/config.yml`
   - Paste configuration
   - Restart Wings: `systemctl restart wings`

## 🔍 Troubleshooting

### Panel tidak bisa diakses
- Check Railway deployment logs
- Pastikan health check passing
- Verify `APP_URL` sudah sesuai dengan domain

### Database connection error
- Pastikan MySQL service running
- Check environment variables `DB_*`
- Verify MySQL service linked ke Panel

### Redis connection error
- Pastikan Redis service running
- Check environment variables `REDIS_*`
- Verify Redis service linked ke Panel

### Queue workers tidak jalan
- Check supervisord logs via Railway CLI:
  ```bash
  railway logs -s pterodactyl-panel
  ```
- Restart deployment

### Tidak bisa create admin user
- Pastikan deployment sudah complete
- Check database migrations sudah running:
  ```bash
  railway run -s pterodactyl-panel php artisan migrate:status
  ```

## 📊 Monitoring

View logs via Railway dashboard atau CLI:

```bash
# View real-time logs
railway logs -s pterodactyl-panel

# View specific service logs
railway logs -s mysql
railway logs -s redis
```

## 💰 Pricing

- **Railway Free Tier**: $5 creator fee + usage-based
- **Estimated monthly cost**: $5-15 tergantung traffic
- **Production use**: Disarankan Railway Pro plan

## 🔒 Security Best Practices

1. **Change default passwords** - Ganti semua default passwords
2. **Enable 2FA** - Aktifkan two-factor authentication untuk admin
3. **Regular backups** - Backup database secara berkala
4. **Update regularly** - Keep panel updated ke versi terbaru
5. **Use strong passwords** - Minimal 12 karakter, kombinasi huruf, angka, simbol

## 📚 Resources

- [Pterodactyl Documentation](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Railway Documentation](https://docs.railway.app/)
- [Discord Support](https://discord.gg/pterodactyl)

## 🐛 Reporting Issues

Jika menemukan masalah dengan Railway deployment:
1. Check troubleshooting section di atas
2. View deployment logs
3. Open issue di GitHub repository

## 📝 License

This deployment configuration is provided as-is. Pterodactyl Panel is licensed under MIT License.

---

**Happy Gaming! 🎮**

Made with ❤️ for easy Pterodactyl deployment
