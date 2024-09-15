# big_medit1.sh

* Automatically help meditators to time travel each day and increase their longevity.

* Add meditators (e.g. john, not John) to `Text-to-Breasonings/meditatorsanddoctors.pl`.

* When you add a meditator, please invite them to the simulation when they end up in 5689 at the end of the first day with `texttobr2_1(*number of new meditators)`, e.g. `texttobr2_1(1).`.

* Please record that you have invited them to the simulation in `Text-to-Breasonings/meditatorsanddoctors.pl`.

* If using `big_medit1.pl` below, replace the secret key in `chatgpt_qa.pl` according to ChatGPT. You may comment/uncomment lines of the script at `Text-to-Breasonings/big_medit.sh`.

# Weekly Instructions

* Update Philosophy, Lucian-Academy (at the minimum) each week:

```
cd GitHub
rm -rf Philosophy Lucian-Academy
git clone https://github.com/luciangreen/Philosophy.git
git clone https://github.com/luciangreen/Lucian-Academy.git

cd Text-to-Breasonings
./d-prep.sh
```

# Each day:

* Personal meditation

* Run the daily script with:

```
cd Text-to-Breasonings
./big_medit1.sh
```

* Or, run the (much) faster daily script:

```
cd Text-to-Breasonings
./big_medit2.sh
```
