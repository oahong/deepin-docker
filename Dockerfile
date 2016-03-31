FROM scratch
ADD rootfs.tar.xz /

ENTRYPOINT /bin/bash
