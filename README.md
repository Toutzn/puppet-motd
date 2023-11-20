# twit_motd

### Table of Contents

1. [Module Description](#description)
2. [Usage](#usage)
3. [Reference](#reference)
4. [Supported OS](#os-support)
5. [Requirements](#requirements)

## Module Description

This module sets up your motd. A message will appear stating that your system is managed by Puppet and will also display the added modules.

## Usage

Use ```twit_motd::register { $module_name: }``` at the end of your init.pp and the module name will be add into the motd.

```
class your_class () {
  include twit_motd
  ...
  contain your_class::params
  contain your_class::config
  ...

  Class['your_class::params']
  -> Class['your_class::config']

  twit_motd::register { $module_name: }
}

```

Also you can add text into the $motd_motd variable to add a custom message as well. Output will be the follows:

```
==============================[ NOTICE ]==============================

    This system is monitored by puppet.
    Local changes could be lost!
    If you have any questions, please contact your@e-mail.ltd

======================================================================

Custom Message

======================================================================

    Registered puppet modules:
      -- twit_motd
      -- ...

```


## Reference

See [REFERENCE.md](REFERENCE.md).

## OS-Support

This module is supported on the following operating systems:

* Debian
	* 9
	* 10
	* 11
	* 12
* Ubuntu
	* 18.04
	* 20.04
	* 22.04
* FreeBSD
	* 12
	* 13

## Requirements

- [puppetlabs/stdlib](https://forge.puppet.com/modules/puppetlabs/stdlib/readme)
- [puppetlabs/concat](https://forge.puppet.com/modules/puppetlabs/concat/readme)
