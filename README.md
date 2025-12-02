# twit_motd

### Table of Contents

- [twit\_motd](#twit_motd)
    - [Table of Contents](#table-of-contents)
  - [Module Description](#module-description)
  - [Usage](#usage)
  - [Reference](#reference)
  - [OS-Support](#os-support)
  - [Requirements](#requirements)

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
	* 12
	* 13
* Ubuntu
	* 22.04
	* 24.04
* FreeBSD
	* 13
	* 14

## Requirements

- [puppetlabs/stdlib](https://forge.puppet.com/modules/puppetlabs/stdlib/readme)
- [puppetlabs/concat](https://forge.puppet.com/modules/puppetlabs/concat/readme)
