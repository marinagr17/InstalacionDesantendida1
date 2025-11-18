#!/bin/bash

###########################################
# CONFIGURACIÓN GENERAL
###########################################

ISO_ORIGINAL="debian-13.1.0-amd64-netinst.iso"
ISO_NUEVA="deb13reseed.iso"
DIR="DebAso"
VOLUMEN="Debian"
INITRD="install.amd/initrd.gz"

###########################################
# CREAR DIRECTORIO PARA ISO DESCOMPRIMIDA
###########################################

echo "Preparando directorio"

rm -r $DIR

mkdir $DIR


###########################################
# EXTRAER ISO
###########################################

    echo "Extrayendo ISO original..."

    7z x "$ISO_ORIGINAL" -o"$DIR"
    if [ $? -ne 0 ]; then
	echo "No se ha extraído"
    fi

###########################################
# COPIAR PRESEED
###########################################

    echo "Copiando preseed"

    chmod +w -R $DIR/$INITRD
    gunzip $DIR/$INITRD

    echo preseed.cfg | cpio -H newc -o -A -F $DIR/install.amd/initrd
    if [ $? -ne 0 ]; then
	echo "No se ha copiado"
    fi

    gzip $DIR/install.amd/initrd
    chmod -w -R $DIR/$INITRD

###########################################
# ACTUALIZAR md5sum.txt
###########################################

    echo "Actualizando sumas md5sum.txt..."

        cd $DIR
	chmod +w md5sum.txt
        find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
	chmod -w md5sum.txt
        cd ..

###########################################
# COMPRIMIR ISO
###########################################

    echo "Generando ISO personalizada..."

 xorriso -as mkisofs \
    -r -V $VOLUMEN \
    -o $ISO_NUEVA \
    -J -joliet-long \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -boot-load-size 4 -boot-info-table -no-emul-boot \
    -eltorito-alt-boot \
    -e boot/grub/efi.img \
    -no-emul-boot -isohybrid-gpt-basdat \
    $DIR

   if [ $? -ne 0  ]; then
 	echo "Error empaquetando la ISO"
   fi

###########################################
# VALIDACIÓN FINAL
###########################################


    echo "ISO generada correctamente:"
    ls -lh "$ISO_NUEVA"


