autodata-formula
================

Formula to automatically set up a /data volume based on LVM.

It is greedy, and will claim any non-root disk for its lv_data.

Use at your peril until it's at v1.0.0


###How to use###

In order to use it you have to:
 - include `autodata` in your top.sls
 - add an extra block device to your instance
 - don't format or partition that block device in any way
 - run a highstate
 
For example, if you use `template-deploy` you can add a section in your cloudformation yaml file, under `block_devices` like:
 
```
  block_devices:
    - DeviceName: /dev/xvdf
      VolumeSize: 30
```

**Note: In order for autodata-formula to pick up your new device you should either name it `/dev/xvd[f-z]` or `/dev/sd[b-z]`**
