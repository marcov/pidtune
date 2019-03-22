# Easy PID tuning from a step response

This repository contains MATLAB/Octave code to automatically compute PID
coefficients from the step response of a system using the Ziegler-Nichols open
loop step response PID tuning method.

I created this to tune the PID that controls the heater of my homemade coffee
roasting machine.

## Repository content

### Main MATLAB script
`ziegler_nichols.m` is a MatLab / Octave script that automatically computes the
PID coefficients from a step response log file, in the format explained [here](#input-file-format).

It also displays a plot of the step response and the lines used by the
Ziegler-Nichols PID tuning method to compute T and L.

#### Input file format
The step response log file shall be in ASCII. Each line of the file is a sample
of a logged step response, in the format: `<STEP VALUE> <RESPONSE VALUE>`.

> **Note**: you need to provide a step responses logged with a 1 second period.

### Artisan scope CSV log processor
`filterdata.sh` is a bash script used to extract from Artisan roaster scope the
step and response data of you coffee roasting machine.
By default, it uses the column labeled "Heater" as step data, and "BT" as
response data. This can be changed by editing the script.

> **Note**: data should be logged by Artisan with a 1 second logging interval.

# Example usage

## Coffee Roasting machine PID tuning

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

$ octave --persist ziegler_nichols.m
```

