###################################
#CREAR Y BORRAR MAQUINA DE PRESEED#
###################################

VM="deb13pr"
ISO="/home/marina/Escritorio/ASO/instalacionDes/debian13preseed.iso"

borrar() {
    virsh undefine --remove-all-storage --nvram $VM
    if { $? -ne 0 }
      echo 'No se ha borrado'
    fi
}

crear() {
    virt-install \
    --virt-type kvm \
    --name $VM \
    --cdrom $ISO \
    --os-variant debian13 \
    --disk path=/var/lib/libvirt/images/$VM.qcow2,size=10 \
    #--disk path=/var/lib/libvirt/images/servidornas2.qcow2,size=1 \
    --memory 1024 \
    --vcpus 1 \
    --network network=default \
    --graphics none --console pty,target_type=serial
}

menu() {
    if [ -z "$1" ]
	echo "Mete parametro"
    exit 1
    fi

    case "$1" in
	b)
	  borrar
	;;
	c)
	  crear
	;;
	*)
	  echo "Error, b o c"
	  exit 1
	;;
    esac
}
