package Blikistan::MagicEngine;
use strict;
use warnings;
    
sub new {
    my $class = shift;
    my $self = { @_ };
    bless $self, $class;
    use Data::Dumper;
    warn Dumper $self;
    return $self;
}

sub print_blog { die 'Subclass must implement' }

1;
