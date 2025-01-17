cd test-packer, then,
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.229-1/virtio-win-0.1.229.iso
then,
PACKER_LOG=1 packer build windows2022_build.pkr.hcl
