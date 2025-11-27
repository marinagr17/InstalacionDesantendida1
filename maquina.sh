###################################
#CREAR Y BORRAR MAQUINA DE PRESEED#
###################################

VM="deb13pr"
ISO="/home/marina/Escritorio/ASO/instalacionDes/debian13preseed.iso"

borrar() {
    virsh destroy $VM
    virsh undefine --remove-all-storage --nvram $VM
    if [ $? -ne 0 ]; then
      echo 'No se ha borrado'
    fi
}

crearU() {
    virt-install \
    --virt-type kvm \
    --name "$VM" \
    --cdrom "$ISO" \
    --os-variant debian13 \
    --disk path=/var/lib/libvirt/images/"$VM".qcow2,size=10 \
    --memory 1024 \
    --vcpus 1 \
    --network network=default \
    --boot uefi \
    --graphics spice
}

crearB() {
    virt-install \
    --virt-type kvm \
    --name "$VM" \
    --cdrom "$ISO" \
    --os-variant debian13 \
    --disk path=/var/lib/libvirt/images/"$VM".qcow2,size=10 \
    --memory 1024 \
    --vcpus 1 \
    --network network=default \
    --graphics spice
}

menu() {
    if [ -z "$1" ]; then
	echo "Mete parametro: b: borrar, cu: maquina UEFI, cb: maquina BIOS"
    exit 1
    fi

    case "$1" in
	b)
	  borrar
	;;
	cu)
	  crearU
	;;
	cb)
	  crearB
	;;
	*)
	  echo "Error, b o cu o cb"
	  exit 1
	;;
    esac
}

menu "$1"
