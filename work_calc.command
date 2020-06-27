#!/usr/bin/env python
import math
import re

# Freetime can have multiple values
# Aggregate freetime
# How broken apart is the freetime

# ie 5 hours free time = 1 hour work
# but maybe it's really 20 15 mintue chunks, so it's better to think about it as 4 chunks, but this functionaliy isn't going to be put in yet
# TODO I could implement some parsing to take in something like 1h15m
# TODO I could implement a floor to handle when I get small time limits
# floor = minuteToHour(5) # 5m

# percentage of freetime that is work
minRatio = 0.1
idealRatio = 0.5


def hourToMinute(hour):
    return math.floor(hour*60)


def minuteToHour(minutes):
    return math.floor(minutes/60)


def calculateTimes():

    h = '(^([0-9]+h|H))'
    m = '(([0-9]+m|M)$)'
    s = '[\s]?'
    regex = h + s + m + '|' + h + m + '|' + h + '|' + m
    p = re.compile(regex)

    # get the input
    while True:
        response = input('How many hours do you have free today?\t'+u"\u001b[32m")
        match = p.match(response.strip())
        if match:
            break
        else:
            print('Please enter a valid input. [#h#m]')
    print(u"\u001b[0m", end="")

    # contains hours
    hasHr = bool(re.search('h|H', match.group()))
    # contains minutes
    hasMin = bool(re.search('m|M', match.group()))

    # parse into float
    t = re.split('h', match.group())

    # case only hours
    if not hasHr:
        hrs = 0
    else:
        hrs = float(t[0])
    if not hasMin:
        mins = 0

    # case only minutes
    if (not hasHr) and hasMin:
        mins = float(t[0].strip()[:-1])
    # case both
    if hasHr and hasMin:
        mins = float(t[1][:-1])

    freehours = hrs + minuteToHour(mins)

    min = freehours * minRatio
    # min = float(min)

    ideal = freehours * idealRatio
    # ideal = float(ideal)

    return ideal, min


def formatTime(time):
    if time < 1:
        unit = 'minutes'
        time = hourToMinute(time)
    else:
        unit = 'hours'
    return f'{time:.1f} {unit}'


def printStats():
    print('>'*3)
    print('\u001b[1mSTATS')
    print(u"\u001b[0m")  # reset
    print(f'minimum percent: {minRatio * 100}')
    print(f'ideal percent:\t {idealRatio * 100}')
    print('>'*3)


print(u'\u001b[1m\n' + '=' * 20 + u'\u001b[0m\n')
ideal, min = calculateTimes()
print(u"\u001b[32m")  # color
print(f'Aim to work {formatTime(ideal)} but at least {formatTime(min)}')
print(u"\u001b[0m")  # reset
printStats()
print(u'\u001b[1m\n' + '=' * 20 + u'\u001b[0m\n')
