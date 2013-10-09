# puppet-nfs

## Overview

The nfs module manages NFS client and server configurations.

## Usage

### Class: nfs::client

### Class: nfs::server

### Define: nfs::mount

## Compatibility

This module should be compatible with all RedHat based operating systems and Puppet 2.6.x and later.

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
