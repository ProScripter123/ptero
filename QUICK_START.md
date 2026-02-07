# 🚀 Quick Start - Pterodactyl Panel Railway Deployment

## Deploy Sekarang! (5 Menit Setup)

### Option 1: One-Click Deploy (Tercepat! ⚡)

1. **Klik tombol ini** → [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/pterodactyl)

2. **Login ke Railway** (bisa pakai GitHub)

3. **Tunggu deployment selesai** (~3-5 menit)

4. **Generate Domain**:
   - Buka service `pterodactyl-panel`
   - Settings → Networking → Generate Domain
   - Copy domain (contoh: `your-app.up.railway.app`)

5. **Update APP_URL**:
   - Tab Variables → Set `APP_URL` = `https://your-app.up.railway.app`
   - Redeploy

6. **Create Admin User**:
   ```bash
   npm i -g @railway/cli
   railway login
   railway link
   railway run -s pterodactyl-panel bash scripts/create-admin.sh
   ```

7. **Access Panel** → `https://your-app.up.railway.app` 🎉

---

### Option 2: Deploy dari GitHub Repo Ini

1. **Push ke GitHub** (jika belum):
   ```bash
   cd d:\pterodactyl-installer-master
   git init
   git add .
   git commit -m "Add Railway deployment"
   git remote add origin https://github.com/YOUR_USERNAME/pterodactyl-railway.git
   git push -u origin master
   ```

2. **Deploy di Railway**:
   - New Project → Deploy from GitHub
   - Select repository
   - Add MySQL database
   - Add Redis
   - Generate domain
   - Create admin user (step 6 di atas)

---

## 📁 Files yang Sudah Dibuat

✅ **Dockerfile** - Production-ready container
✅ **docker-compose.yml** - Local testing
✅ **nginx.conf** - Web server config
✅ **supervisord.conf** - Process management
✅ **entrypoint.sh** - Startup script
✅ **railway.json** - Railway config
✅ **railway.template.json** - One-click template
✅ **.env.railway** - Environment template
✅ **scripts/create-admin.sh** - Admin helper
✅ **RAILWAY_DEPLOY.md** - Full deployment guide
✅ **README.md** - Updated dengan Railway info

---

## ⚠️ Penting!

> **Panel vs Wings**
> - ✅ Railway deploy = **Panel** (web interface) ✅
> - ❌ Wings (game servers) perlu server terpisah ❌
>
> Setelah Panel ready, setup Wings di server lain untuk jalankan game servers.

---

## 📖 Documentation

- **Quick Guide**: File ini
- **Full Guide**: [RAILWAY_DEPLOY.md](RAILWAY_DEPLOY.md)
- **Troubleshooting**: [RAILWAY_DEPLOY.md#troubleshooting](RAILWAY_DEPLOY.md#-troubleshooting)

---

## 💰 Cost Estimate

- Railway Free: $5 + usage
- Estimated: **$5-15/bulan**
- Production: Railway Pro recommended

---

**Happy Gaming! 🎮**
