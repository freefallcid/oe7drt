+++
title = "Get DMRIDs Via Command Line"
summary = "This is a quick workaround to retrieve a DMRID on console or terminal. This comes in handy when you don't have a browser window open or not even a graphical setup running. The script uses w3m to retrieve website content from ham-digital.org. It's also usable when piping its output to a file."
date = 2020-02-04T13:05:25+01:00
tags = ["dmr","ham radio","pi-star","script"]

+++

## First off

You want to install `w3m`. It is a text browser. Don't forget `rpi-rw` before
installing anything if you're on Pi-Star.

```
sudo apt-get -y install w3m
```

## The script

The script itself does not verify the given callsign, so whatever you write as
an argument, it will be passed to the website. The script returns with `0` if
nothing is found. 

``` bash
#!/bin/bash
# Author: Dominic OE7DRT, <https://oe7drt.com>

# test if w3m is installed
command -v w3m >/dev/null 2>&1 || { echo >&2 "w3m not found.  Aborting."; exit 1; }

# define some variables
CALL=$(echo ${1} | tr a-z A-Z)
FILE=/tmp/${CALL}

# get the website
w3m "https://ham-digital.org/dmr-userreg.php?callsign=${CALL}" > ${FILE}

# count number of ids
c=$(grep ${CALL} ${FILE} | wc -l | xargs)

# display ids one by one (only dmrid,callsign,name)
while [ $c -gt 0 ]
do
  OUT=$(grep ${CALL} ${FILE} | head -n $c | tail -n 1 | awk '{ print $2,$4,$5 }')
  echo $OUT
  ((c--))
done

# delete the temp file
rm ${FILE}
```

{{< background "primary" >}}
If someone has two DMRIDS, the most recent registered callsign will appear on
the top. Feel free to modify the script to your needs if you also want to display
the date of registration. Or modify the url if you want to only display last
heard ids.
{{< /background >}}

## Example usage

Simply get one DMRID (or two, depends on the callsign though):

```
call.sh OE7DRT
```

Now let's think a bit more complex. You can use the script in a loop. Let's fetch
some austrian callsigns only.

```
for i in 7one 7two 1three; do call.sh oe$i ids >>! ids; done
```

That would fetch 3 callsigns `OE7ONE`, `OE7TWO` and `OE1ONE` and write them
all into the file `ids`. So run `cat ids` and display them on screen. Or copy
them into clipboard (on a mac only) with `cat ids | pbcopy`.

```
0007001 OE7ONE User1
0007002 OE7TWO User2
0007002 OE7TWO User2
0001002 OE1ONE User3
0001001 OE1ONE User3
```

*I've been anonymizing the data a bit.*
