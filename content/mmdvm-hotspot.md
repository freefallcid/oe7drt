+++
title = "My MMDVM Hotspot"
date = 2020-03-15T10:25:38+01:00
aliases = ["hotspot"]

+++

My Hotspot runs on a Raspberry Pi 4B with 4GB RAM. It is stable most of the time
and the temperature is around 38-40°C normally -- if PHP runs crazy it went up
to 52°C sometimes. But since I disabled the option `extended lookup (show names)`
in the dashboard it stays pretty much on 40°C. I also disabled the option that
shows talk group names.

## General information

I only run MMDVMHost connected to the IPSC2-OE-DMO server. IPSC2 holds some of
the Brandmeister talkgroups like {{< badge "primary" >}}2327{{< /badge >}} so
I thought I will ditch DMRGateway. The connected 7 inch screen displays the
five last heard stations (Callsign, Name, Time, Duration, Slot, Talkgroup). An
online dashboard is also available -- I use the dashboard made by Kim DG9VH.

## Overview

![my hotspot](/images/pages/hotspot_overview.jpg)

## The Dashboard

![Dashboard by Kim DG9VH](/images/pages/hotspot_dashboard.png)

## Hardware

### Raspberry Pi 4B

The main unit is probably the Raspberry Pi 4B. I got myself the version with 4GB
RAM.

![My RaspberryPi 4B](/images/pages/hotspot_raspi4b.jpg)

### MMDVM_HS_Dual_Hat

This is the duplex variant of MMDVM_HS_Hat. It uses [MMDVM_HS] by Andy CA6JAU.

<https://github.com/phl0/MMDVM_HS_Dual_Hat>

[MMDVM_HS]: #mmdvm-firmware

![MMDVM HS Dual Hat](/images/pages/hotspot_modem.jpg)

### Nextion Display

I got myself a 7 inch screen from Nextion and built it into a metal plate that
I bent and welded.

![7 inch dashboard](/images/pages/hotspot_dashboard-nextion.jpg)

## Software

### MMDVMHost

Makefile `Makefile.Pi` - wiringPi installed

```
sudo apt-get install wiringpi
```

Don't ask me if you need this. I thought it won't harm if I install it.

Make `MMDVMHost` with the Pi-Makefile.

```
make -f Makefile.Pi
```

### DMRGateway

[I had this once running]({{< relref "post/hs-dual-hat-with-pistar-v4.md#talkgroup-setup" >}})
but I ditched DMRGateway because I did not use any other Brandmeister talkgroup
than {{< badge "primary" >}}2327{{< /badge >}} -- which is also available on
the IPSC2 network.

If you use DMRGateway you want to use `localhost` as the DMR Network server in
your `MMDVM.ini` file.

### DAPNETGateway

DAPNET is a cool thing to play with, but it is not really the way I want
messages delivered. Sometimes messages did not arrive, or days later. Also you
won't be able to talk on DMR if POCSAG/DAPNET was just sending out messages (well,
that is what MultiMode is).

Besides that, my pager died.

### MMDVM Firmware

{{< background "warning" >}}
<strong>Warning!</strong> When I had the beta firmware flashed I had to reset
the modem with that that little SMD button on the platine first to use M/m mode
(DMR Simplex 1031Hz test pattern (CC1 ID1 TG9)). Otherwise it hang and I wasn't
able to stop the transmitter (even when I killed MMDVMCal).
{{< /background >}}

[This site is a good resource][known-issues] if you are new to this.

[known-issues]: https://github.com/juribeparada/MMDVM_HS/blob/master/README.md#known-issues

I guess the best thing here is to read along the links on the github repo. Also
have a look for files that end with `.md` -- those are Markdown files and
contain useful information most of the time.

```
#if !defined(CONFIG_H)
#define  CONFIG_H

#define MMDVM_HS_DUAL_HAT_REV10
#define ENABLE_ADF7021
#define DUPLEX
#define ADF7021_12_2880
#define AD7021_GAIN_AUTO
#define STM32_USART1_HOST
#define I2C_ADDR 0x22
#define SEND_RSSI_DATA
#define SERIAL_REPEATER
#define SERIAL_REPEATER_BAUD 115200
#define DISCREET_SRV_LED_INVERTED
#define USE_ALTERNATE_POCSAG_LEDS
#define ENABLE_UDID

#endif
```

![Make the modem flashable](/images/pages/hotspot_firmware.jpg)

Flashing will fail when you try to flash the firmware without this connection.

![Flashing](/images/pages/hotspot_flashing.jpg)

But it helps when you got a pair of tweezers in you house. Just make sure to get
good contact to the metal.

{{< alert "danger" >}}Flashing will fail if you cannot hold this steady
for the whole flashing process!{{< /alert >}}

When it fails, just flash again until you get 100%. Reboot the device after that.

https://github.com/juribeparada/MMDVM_HS

## Pictures

At the moment the hotspot sits behind the window and works quite good.

![Another picture #1](/images/pages/hotspot_01.jpg)

The screen is not working 100% but I try my best to improve it every now and
then. It is very hard to have all the used timers set up correctly and I'm still
not sure how precise these timers work -- I have mixed feelings about this and
I think that they are not as precise as I would need them :)

![Another picture #2](/images/pages/hotspot_02.jpg)

It's not perfect but hey, we're hams right?

Although I cannot send from this distance, I can receive the signal of my hotspot
on a trail around 722 meters away. For the record, I am about 80-100 meters
higher than my home QTH where my hotspot stands. I receive the whole way down to
the house with very little interruptions (really, really little).

![Another picture #3 - Distance](/images/pages/hotspot_distance.jpg)

I will for sure record the track to this spot one day, because the hightlighted
track is not correct -- in nature, this path is not as straight as it looks on
the picture HI.
