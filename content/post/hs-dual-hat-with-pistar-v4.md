+++
title = "Hs Dual Hat With Pistar v4"
summary = "This is a MMDVM_HS_Dual_Hat hotspot in duplex mode with DMRGateway and an actual Pi-Star image. In this setup I use **DMR+_IPSC2-OE-DMO** and **BM_German_2621** as master servers."
date = 2020-01-23T15:03:35+01:00
tags = ["mmdvm","pi-star","ham radio"]
draft = "true"

+++

I've been playing with Pi-Star now for a while and I finally got my
IPSC2-Brandmeister dual-setup working.

I'm using the beta version v4 because I read somewhere, that DUAL-HATS won't
work properly with the older v3 firmware -- but I never really tested the v3.
Instead I went for v4 straight away as it seemed pretty stable anyway.

Now, I began with a very simple IPSC2-only setup in the first place. I then made
a backup and changed all settings to be used for Brandmeister only. Another backup
of the Brandmeister setup and I moved on to using DMRGateway.

It was a bit tricky at the beginning, because I was not used to the configuration
of such devices in any kind. After a few hours of research and testing I finally
got the DMR-GW setup ready.

Those pages helped me a lot when I researched for this topic. There might be
more but...

<http://ham-dmr.at/index.php/download/#panel-340-0-0-3>  
There are plenty of instructions on how to setup different things like DVMEGA,
Openspots, Jumbospots etc. Even [code plugs] can be downloaded. The website is
maintained by the Austrian DMR team, the Austrian amateur radio leage ÖVSV and
Michi OE8VIK. Just read along, there is shitload of information.

[code plugs]: http://ham-dmr.at/index.php/download/#panel-340-0-0-0

<https://www.youtube.com/channel/UCw2IvlJcK9kXzn32xI7XB0Q/videos>  
This is the youtube channel of Michi OE8VIK / HB3YZE with tons of information
about digital amateur radio.

<https://www.youtube.com/channel/UC6Us7z_gkxNKc0PcCuS7fYQ/videos>  
The youtube channel of Winters Huang BI7JTA. He writes also on his [blog]. If
you want a nice duplex hotspot with fancy acrylic "L" case and nextion display
you want to have a look at his [shop].

[blog]: https://mmdvm.bi7jta.org/
[shop]: https://www.bi7jta.org/cart/

{{< alert "danger" >}}
This part gets probably updated from time to time. At least as long new websites
come back to my memory ;-)
{{< /alert >}}

## The first thing I did on Pi-Star

Setup the keyboard and language on the console. I mostly type in german and I
know most of the characters on an en_US or en_UK keyboard, but I still prefer
a german layout ;-)

Before we start, we have to make the filesystem writable. Do this with the
command alias `rpi-rw` either in a console or in the SSH-Access tab on the
dashboard (Configuration -> Expert -> SSH Access). The login details for SSH are
the same as on the dashboard.

Now you got the filesystem writable, so start the keyboard configuration:

```
sudo dpkg-reconfigure keyboard-configuration
```

I then usually go for the 105-key PC one. Choose German (Austria) and go for the
default keyboard layout with no compose key -- except you have other needs.

Then start generating the locales for your environment.

```
sudo dpkg-reconfigure locales
```

Choose the locales that you need or want. My setup looks like this:

![locales setup](/images/post/2020/01/00_locales.png)

If you don't know what to choose, go with your language and the UTF-8 version.

### Optional

More software that comes in handy from time to time.

```
sudo apt-get install htop lsof nmap arping vnstat
```

#### If you intent to install and use vnstat, you need to set it up

The installation of vnstat is useful, if you let your pi-star run 24/7 as the
database gets cleared on every reboot!

Add the following line to your `/etc/fstab` file -- I assume that you still
have the filesystem writable.

```
tmpfs  /var/lib/vnstat  tmpfs nodev,noatime,nosuid,mode=1777,size=4m  0  0
```

If you run `cat /etc/fstab` it should look similar to this:

``` shell
#File System    Mountpoint              Type  Options                                   Dump  Pass
proc            /proc                   proc  defaults                                  0     0
/dev/mmcblk0p1  /boot                   vfat  defaults,ro                               0     2
/dev/mmcblk0p2  /                       ext4  defaults,noatime,ro                       0     1
tmpfs           /run                    tmpfs nodev,noatime,nosuid,mode=1777,size=32m   0     0
tmpfs           /run/lock               tmpfs nodev,noatime,nosuid,mode=1777,size=5m    0     0
tmpfs           /sys/fs/cgroup          tmpfs nodev,noatime,nosuid,mode=1755,size=32m   0     0
tmpfs           /tmp                    tmpfs nodev,noatime,nosuid,mode=1777,size=64m   0     0
tmpfs           /var/log                tmpfs nodev,noatime,nosuid,mode=0755,size=64m   0     0
tmpfs           /var/lib/sudo           tmpfs nodev,noatime,nosuid,mode=1777,size=16k   0     0
tmpfs           /var/lib/dhcpcd5        tmpfs nodev,noatime,nosuid,mode=1777,size=32k   0     0
tmpfs           /var/lib/vnstat         tmpfs nodev,noatime,nosuid,mode=1777,size=4m    0     0
tmpfs           /var/lib/logrotate      tmpfs nodev,noatime,nosuid,mode=0755,size=16k   0     0
tmpfs           /var/lib/nginx/body     tmpfs nodev,noatime,nosuid,mode=1700,size=1m    0     0
tmpfs           /var/lib/php/sessions   tmpfs nodev,noatime,nosuid,mode=0777,size=64k   0     0
tmpfs           /var/lib/samba/private  tmpfs nodev,noatime,nosuid,mode=0755,size=4m    0     0
tmpfs           /var/cache/samba        tmpfs nodev,noatime,nosuid,mode=0755,size=1m    0     0
tmpfs           /var/spool/exim4/db     tmpfs nodev,noatime,nosuid,mode=0750,size=64k   0     0
tmpfs           /var/spool/exim4/input  tmpfs nodev,noatime,nosuid,mode=0750,size=64k   0     0
tmpfs           /var/spool/exim4/msglog tmpfs nodev,noatime,nosuid,mode=0750,size=64k   0     0
```

Now create the directory where vnstat saves its database.

```
sudo mkdir /var/lib/vnstat
```

Finally mount the ramdisk into the filesystem

```
sudo mount -a
```

Now run `vnstat` to display network interface statistics. It's output could
look similar to this one:

``` shell
                      rx      /      tx      /     total    /   estimated
 wlan0:
       Jän '20     39,23 MiB  /   39,10 MiB  /   78,33 MiB  /  106,00 MiB
         today     39,23 MiB  /   39,10 MiB  /   78,33 MiB  /     138 MiB
```

It takes time to gather enough information. Get back to this in a few days and
you will get more useful information.

## Make the filesystem read-only again

Once you finished your setup, make the filesystem read-only again.

```
rpi-ro
```

## Start setting up your Pi-Star MMDVM

{{< background "warning" >}}
<strong>Very very very important information</strong><br>
The MMDVM services restart every time you hit
the {{< badge >}}Apply Changes{{< /badge >}} button. So when hitting the button
wait a few seconds &ndash; this takes some time to complete ;-)
{{< /background >}}

### Talkgroup setup

This setup uses some talk groups from IPSC2 and the rest from Brandmeister.
Specifically these talkgroups are:

- {{< badge "secondary" >}}Timeslot 1{{< /badge >}}
  - {{< badge "primary" >}}TG 1{{< /badge >}} -
    {{< badge "primary" >}}TG 7{{< /badge >}}
  - {{< badge "primary" >}}TG 10{{< /badge >}} -
    {{< badge "primary" >}}TG 89{{< /badge >}}
  - {{< badge "primary" >}}TG 100{{< /badge >}} -
    {{< badge "primary" >}}TG 199{{< /badge >}}
- {{< badge "danger" >}}Timeslot 2{{< /badge >}}
  - reflectors with {{< badge "primary" >}}TG 9{{< /badge >}}
  - {{< badge "primary" >}}TG 232{{< /badge >}}
  - {{< badge "primary" >}}TG 8181{{< /badge >}} -
    {{< badge "primary" >}}TG 8189{{< /badge >}}
  - {{< badge "primary" >}}TG 8191{{< /badge >}} -
    {{< badge "primary" >}}TG 8199{{< /badge >}}
- {{< badge "success" >}}GPS data{{< /badge >}} sent as private calls
  to {{< badge "primary" >}}262999{{< /badge >}}

All other talkgroups are used with the Brandmeister network.

### Simplex or Duplex?

This is where we actually start. At the first start either connect your
Raspberry Pi to an ethernet port or look out for a WiFi network called
Pi-Star Setup.

![Control Software](/images/post/2020/01/01_control-software.png)

Make sure to use Duplex Repeater in order to use different RX and TX frequencies.

### MMDVMHost

![Control Software](/images/post/2020/01/02_mmdvmhost.png)

Choose the modes that you want to use. I only use DMR for now.

### General information about the station

![Control Software](/images/post/2020/01/03_general.png)

Put in your own callsign and your DMR-ID --
[register your callsign](https://register.ham-digital.org/) if you don't have
one yet. Select appropiate frequencies and make sure they are at least a few
MHz apart from each other. I used the common shift that we use in Austria
on 70cm (-7.6 MHz).

### DMR configuration

{{< background "warning" >}}
Now, setup IPSC2 only or Brandmeister only if you are unsure about the
DMRGateway setup. Make yourself comfortable with both of the systems but only
one system at a time and move over to DMRGateway when you feel confident enough.
The rewrite rules can be sometimes a bit tricky to set up.
{{< /background >}}

![Control Software](/images/post/2020/01/04_dmrconfig.png)

Choose the Brandmeister master server you want to connect to. Also set a
password in [Brandmeisters SelfCare](https://brandmeister.network/?page=selfcare)
for Hotspot Security. That makes sure, that only you can add a Hotspot with your
callsign. Also select the IPSC2 server of your choice and set the wanted options. I go
with these:

```
StartRef=4197;RelinkTime=15;UserLink=1;TS2_1=232;TS2_2=8189;
```

In this scenario I want to statically link the two talk groups `232` and `8189`
on timeslot 2. I also allow `UserLink` which allows users to link to different
reflectors. The default reflector is `4197` and this gets relinked if nobody
presses PTT for 15 minutes. If you need talk groups from timeslot 1 you would
probably write something like this:

```
StartRef=4197;RelinkTime=15;UserLink=1;TS1_1=20;TS2_1=232;TS2_2=8189;
```

That will also include talk group 20 from timeslot 1. I thought you can
statically link up to 5 talkgroups, but I'm not sure if this information is up
to date (I haven't tried this yet, but you can do that on your own very easy).

Note, that I used the german Brandmeister server instead of the austrian one --
this is because I had problem with APRS with the austrian server. Problems were
gone when I switched to the german server.

*Maybe the 262999 does not get routed correctly on BM_Austria 2321 -- who
knows...*

### Move over to the expert configuration tab

#### Quick edit

Whenever you feel comfortable with DMRGateway, head over to the expert settings
page and select MMDVMHost. I've adjusted the Jitter settings "a bit", although
this should run smooth with a setting of `1000` too -- I'm still a bit of
experimenting with this. I read a lot of times that `1000` should be fine with
slower networks -- but you should definitely experiment yourself a bit with this
setting.

![Control Software](/images/post/2020/01/05_exp_mmdvmhost-dmrnetwork.png)

Now let's have a look at the DMR Gateway configuration. Navigate to the DMR GW
expert settings. Choose **DMR GW** of the upper line (Quick Edit).

![Control Software](/images/post/2020/01/06_exp_dmrgw-dmrnetwork1.png)

![Control Software](/images/post/2020/01/07_exp_dmrgw-dmrnetwork2.png)

Don't forget to save the settings.

#### Full edit

When you have saved that, go to the expert settings again and choose again
**DMR GW** -- **but this time, choose the one from the lower line (Full Edit)**.

This configuration file is split into paragraphs. Look out for the
**\[DMR Network 1]** block.

```
[DMR Network 1]
Enabled=1
Address=87.106.126.49
Port=62031
TGRewrite0=2,8,2,8,1
PCRewrite0=2,84000,2,84000,1001
TypeRewrite0=2,9990,2,9990
SrcRewrite0=2,84000,2,8,1001
PassAllPC0=1
PassAllTG0=1
PassAllPC1=2
PassAllTG1=2
Password="***"
Debug=0
Id=232718001
Name=BM_Germany_2621
```

Our next block is called **\[DMR Network 2]**.

```
[DMR Network 2]
Enabled=1
Address=89.185.97.34
Port=55555
TGRewrite0=1,1,1,1,7
TGRewrite1=1,10,1,10,80
TGRewrite2=1,100,1,100,100
TGRewrite3=2,232,2,232,1
TGRewrite4=2,8181,2,8181,9
TGRewrite5=2,8191,2,8191,9
TGRewrite6=2,9,2,9,1
PCRewrite0=1,9055,1,9055,6
PCRewrite1=2,9055,2,9055,6
PCRewrite2=2,4000,2,4000,1001
Password="PASSWORD"
Debug=0
Id=2327180
Name=DMR+_IPSC2-OE-DMO
Options="StartRef=4197;RelinkTime=15;UserLink=1;TS2_1=232;TS2_2=8189;"
```

[Read along here](https://github.com/g4klx/DMRGateway/wiki/Rewrite-Rules)
if you want to know more about the different rewrite rules.

## That's it

I suppose this gets easier from time to time -- depending on how ofter I have to
install this stuff on a Pi :-)

### There is a picture of my Raspberry Pi 3

![Control Software](/images/post/2020/01/08_raspberrypi.jpg)

### And this is the admin page of the dashboard

If you want to use the Brandmeister Manager you need to set the api key. Go to
expert settings and choose **BM API** in the lower line. It is somewhat in the
middle of the page. To get an api key visit the
[Brandmeister API Keys page](https://brandmeister.network/?page=profile-api).

![Control Software](/images/post/2020/01/09_dashboard-admin.png)

There are some more handy links for Brandmeister if you like:

- [list connected hotspots to the Austrian BM_2321 server][list]
- [last heard on this specific master server][lh]

[list]: http://94.199.173.125/status/list.htm
[lh]: https://brandmeister.network/?page=lh&Master=2321
