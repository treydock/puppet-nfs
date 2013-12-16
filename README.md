# puppet-nfs

[![Build Status](https://travis-ci.org/treydock/puppet-nfs.png)](https://travis-ci.org/treydock/puppet-nfs)

## Overview

The nfs module manages NFS client and server configurations.

## Usage

### Class: nfs::client

Basic usage to install NFS client resources

    class { 'nfs::client': }

To define nfs::mount resources you can define the *nfs_mounts* parameter using a Hash that's valid for the **create_resources** function.

The following will mount a remote NFS at */mnt/foo* and */mnt/bar*.

    class { 'nfs::client':
      nfs_mounts => {
        'foo' => {
          'device'  => '192.168.1.1:/foo',
          'path'    => '/mnt/foo',
          'options' => 'rw,nfsvers=3',
        },
        '/mnt/bar' => {
          'device'  => '192.168.1.1:/bar',
          'options' => 'rw,nfsvers=3',
        },
      },
    }

### Class: nfs::server

### Define: nfs::mount

## Compatibility

This module should be compatible with all RedHat based operating systems and Puppet 2.7.x and later.

It has only been tested on:

* CentOS 6
* Scientific Linux 6

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake ci

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake spec:system
