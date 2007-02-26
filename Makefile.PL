#!/usr/bin/perl -w
use warnings;
use strict;
use inc::Module::Install;

name            'Blikistan';
author          'Luke Closs <cpan@5thplane.com>';
build_requires  'Test::More'        => '0.42';
license         'perl';
version_from    'lib/Blikistan.pm';
requires        'Socialtext::Resting::Utils' => '0.10';

# Auto-install all dependencies from CPAN
auto_install;

# Generate the Makefile
WriteAll;