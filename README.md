# autoupdate

[![Build Status](https://travis-ci.org/MetaCenterCloudPuppet/cesnet-autoupdate.svg?branch=master)](https://travis-ci.org/MetaCenterCloudPuppet/cesnet-autoupdate)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with autoupdate](#setup)
    * [What autoupdate affects](#what-autoupdate-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with autoupdate](#beginning-with-autoupdate)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

<a name="#overview"/>
## Overview

This module sets up automatic updates in the system. It is easy to use module with one scheduled job and email support.

<a name="#module-description"/>
## Module Description

This module offers unified simplified way to handle automatic updates in Debian-like and RedHat-like systems.

On Debian **cron-apt** tool is used.

On RedHat **yum-autoupdate** tool is used (using *aco-yum\_autoupdate* puppet module).

<a name="#setup"/>
## Setup

<a name="#what-autoupdate-affects"/>
### What autoupdate affects

#### Debian

* *cron-apt* package installed
* */etc/cron-apt/config*
* */etc/cron-apt/action.d/\**
* */etc/cron.d/cron-apt* - removed
* crontab

#### RedHat

See [https://github.com/antoineco/aco-yum_autoupdate#setup](https://github.com/antoineco/aco-yum_autoupdate#setup).

<a name="#beginning-with-autoupdate"/>
### Beginning with autoupdate

*Example*: default parameters without email notification

    include autoupdate

Updates at random time 5:00 - 6:00 each day.

<a name="#usage"/>
## Usage

*Example*: some parameters and email

    class { 'autoupdate':
      email      => 'email@example.com',
      hour       => 7,
      randomwait => 1200,
    }

Updates at random time 7:00 - 7:20 each day and send email notification, if someting were updated.

<a name="#reference"/>
## Reference

<a name="#parameters"/>
### Parameters

####`email`
Email to sent notifications. Default is undef.

####`randomwait`
Random time to wait before update in seconds. Default is to leave it to the autoupdate tools (1 hour for cron-apt and yum-autoupdate).

####`type`
Update type. Default is 'default'.

* *cron-apt*: **default**, **dist**
* *yum\_autoupdate*: **default**, **security**, **minimal**, ...

####`hour`
####`minute`
####`month`
####`monthday`
####`weekday`
####`special`
Parameters for cron job.

<a name="#limitations"/>
## Limitations

RedHat-like and Debian-like systems are supported.

<a name="#development"/>
## Development

* repository: [https://github.com/MetaCenterCloudPuppet/cesnet-autoupdate](https://github.com/MetaCenterCloudPuppet/cesnet-autoupdate)
* email: František Dvořák &lt;valtri@civ.zcu.cz&gt;
