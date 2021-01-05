# Offsite Payments

[![Gem Version](https://badge.fury.io/rb/offsite_payments_migs.svg)](http://badge.fury.io/rb/offsite_payments_migs)
[![Build Status](https://github.com/sealink/offsite_payments_migs/workflows/Build%20and%20Test/badge.svg?branch=master)](https://github.com/sealink/offsite_payments_migs/actions)

Offsite Payments is an extraction from the ecommerce system [Shopify](http://www.shopify.com). Shopify's requirements for a simple and unified API to handle dozens of different offsite payment pages (often called hosted payment pages) with very different exposed APIs was the chief principle in designing the library.

It was developed for usage in Ruby on Rails web applications and integrates seamlessly
as a Rails plugin. It should also work as a stand alone Ruby library, but much of the benefit is in the ActionView helpers which are Rails-specific.

This gem provides integration for [MiGS](https://en.wikipedia.org/wiki/Mastercard_Internet_Gateway_Service)
through the Offsite Payments gem.

## Installation

### From Git

You can check out the latest source from git:

    git clone https://github.com/sealink/offsite_payments_migs.git

### From RubyGems

Installation from RubyGems:

    gem install offsite_payments_migs

Or, if you're using Bundler, just add the following to your Gemfile:

    gem 'offsite_payments_migs'

## Misc.

- This library is MIT licensed.


## Release

To publish a new version of this gem the following steps must be taken.

- Update the version in the following files
  ```
    CHANGELOG.md
    lib/offsite_payments_migs/version.rb
  ```
- Create a tag using the format v0.1.0
- Follow build progress in GitHub actions
