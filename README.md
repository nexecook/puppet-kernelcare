# kernelcare

[![Travis](https://img.shields.io/travis/nexcess/puppet-kernelcare.svg)](https://travis-ci.org/nexcess/puppet-kernelcare)
[![Puppet Forge](https://img.shields.io/puppetforge/v/nexcess/kernelcare.svg)](https://forge.puppetlabs.com/nexcess/kernelcare)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description ](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference ](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
7. [Copyright](#copyright)

## Overview

This module installs, configures, and manages kernelcare for rebootless kernel upgrades.

## Module Description

The kernelcare module installs, configures, and manages
[kernelcare](https://www.cloudlinux.com/all-products/product-overview/kernelcare) to update your kernel without needing to
reboot.

A license key from cloudlinux is required to use kernelcare longer than 30 days.

The module will install the kernelcare repository, install the kernelcare package, and
manage the kernelcare configuration file.

This module follows [semantic versioning](http://semver.org/).

## Usage

### Beginning with kernelcare
If you have a license key and want to check for kernel updates every 30 minutes and automatically install them. This is what the normal manual installation of kernelcare will do.

```
class { '::kernelcare':
  config_managekey => true,
  config_accesskey => 'YOUR_LICENSE_KEY',
}
```


### Custom cron times

By default kcarectl runs every 30 minutes unless you give it a custom cron time.

```
class { '::kernelcare':
  config_managekey => true,
  config_accesskey => 'YOUR_LICENSE_KEY',
  cron_minute      => '13',
  cron_hour        => '03',
  cron_month       => '*',
  cron_monthday    => '*',
  cron_weekday     => '*',
}
```

## Reference

### Classes

* kernelcare::repo: Installs the package repository on the server
* kernelcare::install: Installs the kernelcare package on the server
* kernelcare::config: Manages the configuration for kernelcare
* kernelcare::cron: Manages the cron job for kernelcare
* kernelcare::service: Manages the kcare service


### Parameters

#### `config_ensure`
Specifiy if `kcare.conf` and `freezer.modules.blacklist` should exist. Default value: 'present'

#### `config_template_kcare`
Specify a custom template to use for `/etc/sysconfig/kcare/kcare.conf`. Default value: 'kernelcare/kcare.conf.erb'

#### `config_template_kmod_blacklist`
Specify a custom template to use for `/etc/sysconfig/kcare/freezer.modules.blacklist`. Default value: 'kernelcare/freezer.modules.blacklist.erb'

#### `config_kmod_blacklist`
Specify kernel modules to insert into `/etc/sysconfig/kcare/freezer.modules.blacklist`. Default value: `['vxodm', 'vxportal', 'vxfen', 'vxspec', 'vxio']`

#### `config_managekey`
Specify if the license should be managed. Default value: `false`

#### `config_accesskey`
Specify your license. Default value: 'INSERT_ACCESS_KEY'

#### `config_ensurekey`
Specify if the server should be registered. Default value: 'present'

#### `config_autoupdate`
kcarectl --auto runs in a cron job to check for and download new updates. You can can configure this cron job to automatically install new updates as they become available. Default value: 'true'

#### `cron_manage`
Specify if you want the module to manage the kernelcare cron job. Default value: true

#### `cron_ensure`
Specify if you want the cron job to be present. Default value: 'present'

#### `cron_minute`
Specify a custom cron_minute. Default value: `[fqdn_rand(30) , fqdn_rand(30) + 30]`

#### `cron_hour`
Specify a custom cron_hour. Default value: '*'

#### `cron_month`
Specify a custom cron_month. Default value: '*'

#### `cron_monthday`
Specify a custom cron_monthday. Default value: '*'

#### `cron_weekday`
Specify a custom cron_weekday. Default value: '*'

#### `repo_install`
Specify if you want the module to install the kernelcare repo. Default value: 'true'

#### `repo_name`
Specify a custom name for the yum and apt repo. Default value: 'kernelcare'

#### `repo_desc`
Specify a custom description for the yum repo. Default value: 'kernelcare'

#### `repo_yum_baseurl_prefix`
Specify a baseurl_prefix for the yum repo. Default value: 'https://repo.cloudlinux.com/kernelcare'

#### `repo_apt_location`
Specify a baseurl_prefix for the apt repo. Default value: 'https://repo.cloudlinux.com/kernelcare-debian/8'

#### `repo_apt_release`
Specify the release branch to use for the apt repo. Default value: 'stable'

#### `repo_apt_repos`
Specify the repos (space delimited) to use for the apt repo. Default value: 'main'

#### `repo_enabled`
Specify the enable value for the yum and apt repo. Default value: true

#### `repo_gpgcheck`
Specify the gpgcheck value for the yum repo. Default value: true

#### `repo_gpgkey`
Specify a custom url or path for the GPG key for the packages in the yum repo. Default value: 'https://repo.cloudlinux.com/kernelcare/RPM-GPG-KEY-KernelCare'

#### `repo_key_id`
Specify a custom key id for the apt repo. Default value: '6DC3D600CDEF74BB'

#### `repo_key_source`
Specify a custom url for the apt key. Default value: 'https://repo.cloudlinux.com/kernelcare-debian/8/conf/kcaredsa_pub.gpg'

#### `package_name`
Specify the name of the kernelcare package. Default value: 'kernelcare'

#### `package_ensure`
Specify a version of status for the kernelcare package. Default value: 'present'

#### `service_manage`
Specify if the service should be managed. Default value: 'true'

#### `service_name`
Specify the name of the kernelcare service. Default value: 'kcare'

#### `service_ensure`
Specify if the service should be running/stopped. Default value: 'running'

### Facts
`kcare-uname` will print out the effective version of kernel after patching. It accepts uname(1) command-line options and produces compatible output. There are facts, using kcare-uname, corresponding to the kernel facts that already come with facter.

* kernelcare_kernelrelease: effective kernel release
* kernelcare_kernelversion: effective kernel version
* kernelcare_kernelmajversion: effective kernel major version

## Development

Install necessary gems:
```
bundle install --path vendor/bundle
```

Check syntax of all puppet manifests, erb templates, and ruby files:
```
bundle exec rake validate
```

Run puppetlint on all puppet files:
```
bundle exec rake lint
```

Run spec tests in a clean fixtures directory
```
bundle exec rake spec
```

Run acceptance tests with a kernelcare license:
```
KERNELCARE_LICENSE=abc123 PUPPET_INSTALL_TYPE=agent BEAKER_set=centos-7-x64 bundle exec rake acceptance
```

Run acceptance tests on docker without a kernelcare license (faster):
```
PUPPET_INSTALL_TYPE=agent BEAKER_set=docker/centos-7-x64 bundle exec rake acceptance
```

## Copyright

Copyright 2017 [Nexcess](https://www.nexcess.net/)

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
