ipfs:
  pkg.installed:
    - name: ipfs-go
  user.present:
    - home: /var/db/ipfs
    - shell: /sbin/nologin
  group.present: []

/var/db/ipfs:
  file.directory:
    - user: ipfs
    - group: ipfs
    - require:
      - user: ipfs
      - group: ipfs

/usr/local/etc/rc.d/ipfs-go:
  file.managed:
    - source: salt://usr/local/etc/rc.d/ipfs-go
    - user: root
    - group: wheel
    - dir_mode: 755
    - file_mode: 644

ipfs-daemon:
  service.running:
    - name: ipfs-go
    - enable: True
    - require:
      - pkg: ipfs-go
      - file: /var/db/ipfs
      - file: /usr/local/etc/rc.d/ipfs-go
