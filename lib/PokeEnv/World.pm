use v6;
use PokeEnv::Entity::Agent;

class PokeEnv::Level {
	has	$.id;
	has	%.layers;
	has	$.width;
	has	$.height;
	
	method new($width, $height, $id) {
		self.bless(:$width, :$height, :$id);
	}

	method addLayer($lid, $layer) {
		%.layers{$lid} = $layer;
	}

	method hasLayer($lid) {
		%.layers{$lid}:exists;
	}
	
	method getLayer($lid) {
		%.layers{$lid};
	}

	method dump() {
		say "Level: $.id";
		for %.layers.keys {
			say "Layer: $_";
			%.layers{$_}.dump;
		}
	}
}

class PokeEnv::World {
	has	%.levels;
	has	$.level is rw;
	has	@.agents;

	method new() {
		self.bless();
	}

	method run() {
		for @.agents -> $agent {
			$agent.act;
		}
	}

	method spawn_agent($agent) {
		@.agents.push($agent);
	}

	method switch_level($level_id) {
		if (%.levels{$level_id}:exists) {
			$.level = %.levels{$level_id};
			$.level;
		} else {
			False;
		}
	}

	method addLevel($level, $level_id = $level.id) {
		%.levels{$level_id} = $level;
	}

	method hasLevel($level_id) {
		%.levels{$level_id}:exists;
	}

	method getLevel($level_id) {
		%.levels{$level_id};
	}

	method dump() {
		%.levels.values>>.dump;
	}
}
# vim: ft=perl6