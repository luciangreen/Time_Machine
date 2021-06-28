# Time_Machine

* Travel through time with meditation.

# Prerequisites

* Please download and install SWI-Prolog for your machine at `https://www.swi-prolog.org/build/`.

# 1. Install manually

Download <a href="http://github.com/luciangreen/Time_Machine/">this repository</a>.

# 2. Or Install from List Prolog Package Manager (LPPM)

* Download the <a href="https://github.com/luciangreen/List-Prolog-Package-Manager">LPPM Repository</a>:

```
git clone https://github.com/luciangreen/List-Prolog-Package-Manager.git
cd List-Prolog-Package-Manager
swipl
['lppm'].
lppm_install("luciangreen","Time_Machine")
halt
```

# Running

* In Shell:
`cd Time_Machine`
`swipl`
`['time_machine.pl'].`
`time_machine.`

```
[debug]  ?- time(time_machine).
Time Machine

Warning: This software is to be used at your own risk.  Please read the Instructions for TextToBr to avoid medical problems before use.

This time machine will transport you and named friends to a place and time and back before a specified time.  You may come back before the given time with the thought command, "I want to time travel back to the same place in my own time line, the same amount of time relative to when I left".,

Please wear clothes appropriate for the time and determine whether it is a good time to travel, especially in the past and using predictions of the future.
Do you want to continue (y/n)?
|: y
How many people and animals are travelling, including you?
|: 2
When do you want to travel to?
|: now
Where do you want to travel to?
|: here
How many hours do you want to return after
|: 1
Do you want to travel now (y/n)?
|: y
% 19,615 inferences, 0.616 CPU in 13.338 seconds (5% CPU, 31851 Lips)
true.

[debug]  ?- texttobr2_1(6). % to turn off and return 2 travellers using A,B,B to B
```
