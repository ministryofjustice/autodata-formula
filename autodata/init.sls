{% from "autodata/map.jinja" import autodata with context %}

/usr/local/bin/auto-resize-data-fs:
  file.managed:
    source: salt://autodata/files/auto-resize-data-fs
    user: root
    group: root
    mode: 0755

run_auto_resize:
  cmd: /usr/local/bin/auto-resize-data-fs
  require:
    - file: /usr/local/bin/auto-resize-data-fs

#
# run unless there already an fstab entry
# and only if /data is empty and only if LV exists
#
ensure_fstab_entry:
  cmd: "echo '/dev/{{vg_name}}/{{lv_name}} {{mount_point}} {{fs_type}} {{mount_options}} 0 2' >> /etc/fstab"
  onlyif: 'test -z "$( ls /data )" && lvs /dev/{{vg_name}}/{{lv_name}})'
  unless: 'grep -q /dev/{{vg_name}}/{{lv_name}} /etc/fstab'
  require:
    - cmd: run_auto_resize

# only try to mount the filesystem if it isn't already mounted
# and only if /data is empty.
ensure_fs_mounted:
  cmd: "mount /data"
  unless: 'df /data | grep -q {{vg_name}}/{{lv_name}}'
  onlyif: 'test -z "$( ls /data )"'
