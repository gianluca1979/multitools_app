#!/bin/bash

echo "--- Inizio procedura di aggiornamento Multitools (v2) ---"

# --- Sezione Backup ---
echo "[1/7] Esecuzione del backup del database..."
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p storage/backups
mysqldump -u multitools_user -p'password_sicura' multitools_db > storage/backups/db_backup_$TIMESTAMP.sql
echo "Backup del database completato."

# --- Sezione Aggiornamento Forzato ---
echo "[2/7] Download delle informazioni dal repository..."
git fetch --all

echo "[3/7] Forzatura dell'allineamento con la versione ufficiale..."
git reset --hard origin/main
echo "Codice sorgente allineato."

echo "[4/7] Installazione delle dipendenze..."
composer install --no-dev --optimize-autoloader
nvm use --lts > /dev/null 2>&1
npm install

echo "[5/7] Applicazione delle modifiche al sistema..."
npm run build
php artisan migrate --force
php artisan optimize:clear

echo "[6/7] Sistemazione dei permessi..."
sudo chown -R www-data:www-data .

echo "[7/7] Pulizia finale."

echo "--- Aggiornamento completato con successo! ---"
