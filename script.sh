#Detection du syteme
if [ -f "/etc/os-release" ]; then
    # Extraire l'identifiant de la distribution depuis le fichier /etc/os-relea>
    os_id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')

    if [ "$os_id" = "rhel" ]; then
        dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
        echo "[OK] Mise a jour terminer "
    

    sudo dnf update -y 
    dnf install -y hyperv-tools
    echo "hv_sock" | tee -a /etc/modules-load.d/hv_sock.conf > /dev/null
    dnf install -y xrdp xrdp-selinux
    systemctl enable xrdp
    systemctl enable xrdp-sesman
    sed -i_orig -e 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini
    sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
    sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
    sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini
    sed -i_orig -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini
    echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
    firewall-cmd --add-port=3389/tcp --permanent
    firewall-cmd --reload
    reboot