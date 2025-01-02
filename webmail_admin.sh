#!/bin/bash

# Nama file: webmail_admin.sh
# Script ini untuk mengelola server webmail

# Fungsi untuk menampilkan menu utama
function show_menu() {
    echo "=== Webmail Server Administration ==="
    echo "1. Tambah Pengguna Baru"
    echo "2. Hapus Pengguna"
    echo "3. Periksa Status Layanan"
    echo "4. Cadangkan Konfigurasi"
    echo "5. Keluar"
    echo "====================================="
}

# Fungsi untuk menambah pengguna baru
function add_user() {
    read -p "Masukkan nama pengguna baru: " username
    read -sp "Masukkan password: " password
    echo
    sudo useradd -m "$username"
    echo "$username:$password" | sudo chpasswd
    echo "Pengguna $username berhasil ditambahkan."
}

# Fungsi untuk menghapus pengguna
function delete_user() {
    read -p "Masukkan nama pengguna yang akan dihapus: " username
    sudo userdel -r "$username"
    echo "Pengguna $username berhasil dihapus."
# Fungsi untuk memeriksa status layanan
function check_services() {
    echo "Memeriksa status layanan..."
    for service in postfix dovecot apache2; do
        if systemctl is-active --quiet $service; then
            echo "$service: Aktif"
        else
            echo "$service: Tidak aktif"
        fi
    done
}

# Fungsi untuk mencadangkan konfigurasi
function backup_config() {
    backup_dir="/backup/webmail_config_$(date +%Y%m%d)"
  sudo mkdir -p "$backup_dir"
    sudo cp -r /etc/postfix "$backup_dir/"
    sudo cp -r /etc/dovecot "$backup_dir/"
    echo "Konfigurasi berhasil dicadangkan di $backup_dir"
}

# Program utama
while true; do
    show_menu
    read -p "Pilih opsi [1-5]: " choice
    case $choice in
        1) add_user ;;
        2) delete_user ;;
        3) check_services ;;
        4) backup_config ;;
        5) echo "Keluar dari program."; exit 0 ;;
        *) echo "Opsi tidak valid, coba lagi." ;;
    esac
    echo
done

