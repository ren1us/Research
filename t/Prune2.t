use v6;
use Test;
use SimNet::Net;
use SimNet::Frames;
use PokeEnv::Entity::Agent;
use PokeEnv::IO::WorldBuilder;
use PokeEnv::Grid;
use TestUtils::Utils;
use TestData;

#my %verbFrames = loadFrames(open('frames/verbs.in').slurp);
#my $verbNetwork = SimNet::Network.new('frames/verbs.in');
#my %nounFrames = loadFrames(open('frames/nouns.in').slurp);
#my $nounNetwork = SimNet::Network.new('frames/nouns.in');

sub pick_prune(@list is copy, $l, $pos is copy, $verbNetwork, $nounNetwork) {

	if $l < 1 {
		return @list;
	} else {
		say "Data: $l $pos " ~ @list.elems;
		my @replacement;
		for 0..^$l {
			push @replacement, 0;
		}
		my @pulled = @list.splice($pos, $l, @replacement);
		if testRun(@list, $verbNetwork, $nounNetwork) ~~ "success" {
			@list.splice($pos, $l);
			$pos -= $l;
		} else {
			for 0..^@pulled.elems {
				@list[$_ + $pos] = @pulled[$_];
			}
		}
	}
	if $l >= @list.elems {
		pick_prune(@list, floor(@list.elems / 2), 0, $verbNetwork, $nounNetwork);
	} elsif ($pos + $l) + $l >= @list.elems {
		pick_prune(@list, floor($l / 2), 0, $verbNetwork, $nounNetwork);
	} else {
		pick_prune(@list, $l, $pos + $l, $verbNetwork, $nounNetwork);
	}
}

#my $str = open('testdata.in').slurp;
#my %hash = EVAL($str);
my %hash = getTestHash;

#say "Test run: ";
#testRun(%hash{0}, $verbNetwork, $nounNetwork);
say "Real: ";
#for %hash.keys {
#	say %hash{$_}.list.elems;
#}

for %hash.keys -> $rid {
#say pick_prune(%hash{1}.list);
#	$count = 0;
	say "Sequence $rid";
	my $verbNetwork = SimNet::Network.new('frames/verbs.in');
	my $nounNetwork = SimNet::Network.new('frames/nouns.in');
#	%hash{$rid} = 
	pick_prune(%hash{$rid}.list, %hash{$rid}.list.elems - 1, 0, $verbNetwork, $nounNetwork);
#	pick_prune(%hash{1}.list, %hash{1}.list.elems - 1, 0, $verbNetwork, $nounNetwork);
#	pick_prune(%hash{2}.list, %hash{2}.list.elems - 1, 0, $verbNetwork, $nounNetwork);
}

say %hash;

# vim: ft=perl6
