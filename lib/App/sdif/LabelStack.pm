package App::sdif::LabelStack;

use strict;
use warnings;
use Carp;

sub new {
    my $class = shift;
    my $obj = bless {
	LABELS => [],
	COUNTS => {},
	LISTS  => [],
	OPTION => { UNIQUE => 1 },
	ATTR   => {},
    }, $class;

    if (@_) {
	$obj->option(@_);
    }

    if (my $initial_label = $obj->option('START')) {
	$obj->newlabel($initial_label);
    }

    $obj;
}

sub option { splice @_, 1, 0, 'OPTION' ; goto &__attr }
sub attr   { splice @_, 1, 0, 'ATTR'   ; goto &__attr }
sub __attr {
    my $obj = shift;
    my $attr_name = shift;

    return undef if @_ < 1;
    return $obj->{$attr_name}->{+shift} if @_ == 1;

    my $hash = $obj->{$attr_name};
    while (my($name, $value) = splice @_, 0, 2) {
	$hash->{$name} = $value;
    }

    $obj;
}

sub exists {
    my $obj = shift;
    my $label = shift;
    $obj->{COUNTS}->{$label};
}

sub count {
    my $obj = shift;
    scalar @{$obj->{LISTS}};
}

sub newlabel {
    my $obj = shift;
    my $label = shift;
    if ($obj->{COUNTS}->{$label}++ and $obj->option('UNIQUE')) {
	croak "Duplicated label: $label\n";
    }
    push @{$obj->{LABELS}}, $label;
    push @{$obj->{LISTS}}, [];
}

sub append {
    my $obj = shift;
    my($label, $line) = @_;
    if ($obj->labels == 0 or $label ne $obj->lastlabel) {
	$obj->newlabel($label);
    }
    push @{$obj->{LISTS}->[-1]}, $line;
    $obj;
}

sub labels {
    my $obj = shift;
    if (@_ == 0) {
	@{$obj->{LABELS}};
    } else {
	map { @{$obj->{LABELS}[$_]} } @_;
    }
}

sub lastlabel {
    my $obj = shift;
    $obj->{LABELS}->[-1];
}

sub lists {
    my $obj = shift;
    if (@_ == 0) {
	@{$obj->{LISTS}};
    } else {
	map { @{$obj->{LISTS}[$_]} } @_;
    }
}

sub blocks {
    my $obj = shift;
    map { join '', @$_ } $obj->lists;
}

sub listpair {
    my $obj = shift;
    my @labels = $obj->labels;
    map { $labels[$_] => $obj->{LISTS}[$_] } 0 .. $#labels;
}

sub blockpair {
    my $obj = shift;
    my @labels = $obj->labels;
    my @blocks = $obj->blocks;
    map { $labels[$_] => $blocks[$_] } 0 .. $#labels;
}

sub match {
    my $obj = shift;
    my $label = shift;
    my $pattern = ref $label eq 'Regexp' ? $label : qr/^\Q$label\E$/;
    my @labels = $obj->labels;

    map  { $obj->{LISTS}[$_] }
    grep { $labels[$_] =~ /$pattern/ }
    0 .. $#labels;
}

sub collect {
    my $obj = shift;
    map { @$_ } $obj->match(@_);
}

sub push {
    my $obj = CORE::shift;
    croak "Invalid argument." if @_ % 2;
    while (my($label, $data) = splice @_, 0, 2) {
	CORE::push @{$obj->{LABELS}}, $label;
	CORE::push @{$obj->{LISTS}}, $data;
	$obj->{COUNTS}{$label}++;
    }
    $obj;
}

sub pop {
    my $obj = CORE::shift;
    return () if $obj->count == 0;
    my $label = CORE::pop @{$obj->{LABELS}};
    my $entry = CORE::pop @{$obj->{LISTS}};
    $obj->{COUNTS}{$label}--;
    ($label, $entry);
}

sub unshift {
    my $obj = CORE::shift;
    croak "Invalid argument." if @_ % 2;
    while (my($label, $data) = splice @_, 0, 2) {
	CORE::unshift @{$obj->{LABELS}}, $label;
	CORE::unshift @{$obj->{LISTS}}, $data;
	$obj->{COUNTS}{$label}++;
    }
    $obj;
}

sub shift {
    my $obj = CORE::shift;
    return () if $obj->count == 0;
    my $label = CORE::shift @{$obj->{LABELS}};
    my $entry = CORE::shift @{$obj->{LISTS}};
    $obj->{COUNTS}{$label}--;
    ($label, $entry);
}

1;
