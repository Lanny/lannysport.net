# Lannysport

I'm Lanny, I make some things. My largest project in recent years has been [ISS](#ISS). In the course of that project I started [Houston](#Houston), which is a Django app aimed at providing site usage analytics, sorta like Google Analytics but without all the privacy invasion and likely selling off of data. Lately I've been working on a project aimed at delivering synchronized video playback in modern browsers over networks with non-negligible latency, [CGRO](#CGRO). I don't name all my projects after space stuff, I swear. I also make little games sometimes, most notably web based implementations of [Onitama](#onitama) and [YINSH](#YINSH).

## ISS<a name="ISS"></a>
ISS (short for "International Space Station", although no one calls it that) is a piece of BBS style forum software. While fairly feature complete at this point, it aims to be simple both in user experience and implementation. I took pains to ensure that it is fast, both in terms of server requirements to run it and in terms of client side demand, being fully functional on browsers with no javascript engine and conservative with optional enhancements as clients can support. The codebase is modern but is designed to support the computing capabilities of the 90s. [Source code](https://github.com/Lanny/ISS).

## CGRO<a name="CGRO"></a>
CGRO (Compton Gamma Ray Observatory) aims to deliver synchronized video playback between a small number of peers. Think of it like skype for movie night. [Source code](https://github.com/Lanny/Compton-Gamma-Ray-Observatory).

## Onitama<a name="onitama"></a>
[Onitama](https://www.arcanewonders.com/game/onitama/) is a two player, perfect information game, played in a 5 by 5 grid. It's kind of similar to chess but plays much faster, honestly it's not as deep, it has a fun twist to it. I didn't design the game but I implemented a netplay version of it. [Source code](https://github.com/Lanny/Onitama). [Play online](http://onitama.lannysport.net/).

## YINSH<a name="YINSH"></a>
YINSH a two player, perfect information game, played on something like a non-square grid. Maybe think of chess and Othello combined? I made a pass-and-play implementation of it (and want to get around to making a netplay version at some point). [Source code](https://github.com/Lanny/Yinch).

## Chemical Space<a name="cspace"></a>
Chemical space is a tool for computing and viewing chemical similarity (under a few different definitions of "chemical similarity") between large sets of chemicals. It is one of the more demo-able results of my work in chemical analysis/drug discovery as part of my masters. [Source code](https://github.com/Lanny/cspace). [Live version](http://cspace.lannysport.net/).

## Recipes
Recipe management seems like the one thing we should be able to do well on a computer at this point but honestly it really kind of sucks. There's no well accepted interchange format and lots of garbage software that's one or more of closed source, paid, lock-in-y, or just plain lousy. I've had to manually transfer recipes several times now and it blows. And all I really need is a lightly formatted document at the end of the day. So now my recipe book lives here.

- [Groundnut Stew](recipes/groundnut-stew.html)

