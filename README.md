## PID tuning of your coffee roasting machine

## Repository content
`filterdata.sh` is a bash script used to extract from Artisan roaster scope the
step and response data of you coffee roasting machine.
By default, it uses the column labeled "Heater" as step data, and "BT" as
response data. This can be changed by editing the script.

> **Note**: data should be logged by Artisan with a 1 second logging interval.

`ziegler-nichols.m` is a MatLab / Octave script that uses the data generated by
`filterdata.sh` to automatically compute the PID coefficients. It also displays
a plot of the step response and the lines used by the Ziegler-Nichols PID
tuning method to calculate T and L.

## Usage

### Log the step response using Artisan

1. Run your roasting machine with manual control (PID OFF). Set the heater to a
low value (0% is OK too) and wait for the BT to stabilize.

2. Start a "fake" roasting on Artisan by clicking "START", so that everything
from now on is logged. Wait some seconds, and then generate a "step" by setting
your heater to a value high enough to generate a observable increment of BT.
Something above 50% should be enough.

3. Wait until BT reaches a steady (flat) value, then stop the fake roasting and
export the data in CSV format.

### Compute the PID coefficients

Assuming that you are on a Linux system:

```
$ ./filterdata.sh artisan-export.csv step-response.txt
INFO: found step (Heater) at column 6 and response(BT) at column 4

$ octave --persist ziegler-nichols.m
```
