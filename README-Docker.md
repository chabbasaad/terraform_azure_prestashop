# PrestaShop Docker Setup - Taylor Shift

Quick setup to test PrestaShop locally with Docker and automatic installation.

## 🚀 Quick Start

1. **Start the containers:**
   ```bash
   docker compose up
   ```

2. **Wait for installation** (2-3 minutes)

3. **Access your PrestaShop store:**
   - **Store Front**: http://localhost:8080
   - **Admin Panel**: http://localhost:8080/admin-taylor

## 🔐 Login Credentials

- **Email**: `admin@taylorshift.local`
- **Password**: `admin123`

## 📋 What's Included

- ✅ **Automatic Installation** - No manual setup required
- ✅ **Demo Data** - Sample products and content
- ✅ **Custom Admin URL** - `/admin-taylor` for security
- ✅ **MySQL Database** - Persistent data storage

## 🛠️ Commands

```bash
# Start containers
docker compose up

# Start in background
docker compose up -d

# Stop containers
docker compose down

# View logs
docker compose logs prestashop

# Access container shell
docker exec -it prestashop /bin/bash
```

## 🔧 Troubleshooting

If you see installation errors, wait a few minutes for MySQL to fully initialize, then restart:

```bash
docker compose down
docker compose up
```

## 🌐 URLs

- **PrestaShop Store**: http://localhost:8080
- **Admin Panel**: http://localhost:8080/admin-taylor
- **MySQL Port**: localhost:3306 (if needed for external tools)

The installation process will automatically:
- Create the database
- Install PrestaShop with demo data
- Set up the admin user
- Configure the store for localhost access
