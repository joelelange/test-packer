cd test-packer, then,
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.229-1/virtio-win-0.1.229.iso ## Not sure about this file being needed, looks like all the necessary drivers are included in QEMU builder.
then,
PACKER_LOG=1 packer build windows2022_build.pkr.hcl
