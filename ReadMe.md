# 🚀 MikroTik Backup Docker

This repository contains a **Docker container** that performs **automatic backups** of a **MikroTik** router via **SSH**.
✔ **Scheduled with cron** (configurable).
✔ **Backup with numeric date format** (`YYYY-MM-DD_HH-MM`).
✔ **Automatic backup rotation** (keeps only the last N backups).
✔ **Optional execution on first startup**.
✔ **Flexible configuration with environment variables**.

---

## 📁 Project Structure  

```
/mikrotik-backup
│── Dockerfile       # Container build
│── backup.sh        # Backup script
│── start.sh         # Cron setup and container startup
│── README.md        # Documentation
```

---

## 🚀 Installation and Usage  

### 🔹 **1️⃣ Build the Docker image**  
```bash
docker build -t mikrotik-backup .
```

### 🔹 **2️⃣ Run the container with custom configuration**  
```bash
docker run -d \
  --name mikrotik-backup \
  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \   # Mount SSH key
  -v $(pwd)/backups:/backups \           # Save backups on host
  -e MIKROTIK_IP="192.168.88.1" \        # MikroTik IP
  -e MIKROTIK_USER="admin" \             # SSH User
  -e CRON_SCHEDULE="0 * * * *" \         # Run every hour
  -e BACKUP_ROTATION=5 \                 # Keep only last 5 backups
  -e RUN_ON_STARTUP=true \               # Run backup on first start
  mikrotik-backup
```

### 🔹 **3️⃣ View container logs**  
```bash
docker logs mikrotik-backup
```

### 🔹 **4️⃣ Check saved backups**  
```bash
ls backups/
```

---

## ⚙️ Environment Variable Configuration  

| Variable          | Description                                     | Default Value |
|------------------|---------------------------------------------|--------------|
| `MIKROTIK_IP`    | MikroTik router IP address                 | `192.168.88.1`  |
| `MIKROTIK_USER`  | SSH user for MikroTik access               | `admin`         |
| `MIKROTIK_SSH_KEY` | Path to private SSH key                  | `/root/.ssh/id_rsa` |
| `CRON_SCHEDULE`  | Backup frequency in cron format           | `0 0 * * *` (daily at midnight) |
| `BACKUP_ROTATION` | Number of backups to keep before deletion | `7` (last 7 backups) |
| `RUN_ON_STARTUP` | Run backup on first startup (`true/false`) | `true` |

---

## 🛠 Maintenance  

### 🔹 **Stop and remove the container**  
```bash
docker stop mikrotik-backup && docker rm mikrotik-backup
```

### 🔹 **Update the image and restart**  
```bash
docker build -t mikrotik-backup .
docker stop mikrotik-backup && docker rm mikrotik-backup
docker run -d --name mikrotik-backup [options...]
```

---

## 📜 License  
This project is under the **MIT** license. Feel free to contribute! 😃  

---

🚀 **Created to simplify MikroTik backups in Docker.**  

If you have improvements or suggestions, open an **Issue** or a **Pull Request**! 🎉

