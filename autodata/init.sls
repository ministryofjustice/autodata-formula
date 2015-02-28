{% from "autodata/map.jinja" import autodata with context %}

autodata-lvm2:
  pkg.installed:
    - name: lvm2

# we expect that our mount point will be created elsewhere, but
# this should be independent of that.
# If it is not present, create it, and then future operations will
# ensure it has the right permissions
ensure_mount_point_created:
  cmd.run:
   - name: 'mkdir -p {{autodata.mount_point}}'
   - unless: 'test -d {{autodata.mount_point}}'

/usr/local/bin/auto-resize-data-fs:
  file.managed:
    - source: salt://autodata/files/auto-resize-data-fs
    - user: root
    - group: root
    - mode: 0755

run_auto_resize:
  cmd.run:
   - name: '/usr/local/bin/auto-resize-data-fs'
   - require:
     - file: /usr/local/bin/auto-resize-data-fs
     - cmd: ensure_mount_point_created
     - pkg: autodata-lvm2

#
# run unless there already an fstab entry
# and only if /data is empty and only if LV exists
#
ensure_fstab_entry:
  cmd.run:
   - name: "echo '/dev/{{autodata.vg_name}}/{{autodata.lv_name}} {{autodata.mount_point}} {{autodata.fs_type}} {{autodata.mount_options}} 0 2' >> /etc/fstab"
   - onlyif: 'test -z "$( ls {{autodata.mount_point}} )" && lvs /dev/{{autodata.vg_name}}/{{autodata.lv_name}}'
   - unless: 'grep -q /dev/{{autodata.vg_name}}/{{autodata.lv_name}} /etc/fstab'
   - require:
     - cmd: run_auto_resize

# only try to mount the filesystem if it isn't already mounted
# and only if /data is empty.
ensure_fs_mounted:
  cmd.run:
   - name: 'mount {{autodata.mount_point}}'
   - unless: 'df {{autodata.mount_point}} | grep -q {{autodata.vg_name}}-{{autodata.lv_name}}'
   - onlyif: 'test -z "$( ls {{autodata.mount_point}} )" && lvs /dev/{{autodata.vg_name}}/{{autodata.lv_name}}'
   - require:
     - cmd: ensure_fstab_entry
