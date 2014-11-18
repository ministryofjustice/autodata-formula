Upgrading
---------

On an initial installation, this formula takes care not to mount on top of your
existing /data area.

Instead, it will create all LV as needed, and wait until you have fully emptied /data.
Ideally this would be my moving it out of the way, or by manually populating the LV in 
a temporary mount point.

Once that has been done, re-run salt, and the mount will be made permanent.

It is advised to reboot after this.


