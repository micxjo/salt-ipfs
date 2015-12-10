sysutils/ipfs-go:
  ports.installed: []
  user.present:
    - name: ipfs
    - fullname: IPFS User
    - home: /var/db/ipfs
    - shell: /sbin/nologin
  group.present:
    - name: ipfs

/var/db/ipfs:
  file.directory:
    - user: ipfs
    - group: ipfs
    - dir_mode: 755
    - file_mode: 644
    - require:
      - user: ipfs
      - group: ipfs

ipfs-init:
  cmd.run:
    - name: IPFS_PATH=/var/db/ipfs /usr/local/bin/ipfs-go init
    - user: ipfs
    - require:
      - file: /var/db/ipfs
    - unless: ls /var/db/ipfs/datastore

/usr/local/etc/rc.d/ipfs-go:
  file.managed:
    - source: salt://usr/local/etc/rc.d/ipfs-go
    - user: root
    - group: wheel
    - file_mode: 644

/etc/ipfs-go.ipfw.rules:
  file.managed:
    - source: salt://etc/ipfs-go.ipfw.rules
    - user: root
    - group: wheel
    - file_mode: 644

ipfs-daemon:
  service.running:
    - name: ipfs-go
    - enable: True
    - require:
      - ports: sysutils/ipfs-go
      - cmd: ipfs-init
      - file: /usr/local/etc/rc.d/ipfs-go
      - file: /etc/ipfs-go.ipfw.rules
