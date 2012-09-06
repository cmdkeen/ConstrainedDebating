%-----------------------------------------------------------------------------%
% World University Debating Championship Draw
%
% Sep 2012; Chris Hawkins
%
% Draw positions in rooms for teams in a debating competition such that teams
% of similar ability face each other, whilst minimising repeated positions across
% rounds.
%-----------------------------------------------------------------------------%

include "globals.mzn";

% (with data file)
int: teams = 8;
int: teams_per_room = 4;
int: rooms = teams div teams_per_room; %Add assert to check divisible
int: rounds = 1;
int: weight = 3;

set of int: team_set = 1..teams;
set of int: positions = 1..teams_per_room;

array[team_set] of int: previous_positions = [1,2,3,4,4,2,3,1];
array[team_set] of int: scores = [3,2,1,0,2,1,3,0];

% Model
array[team_set] of var team_set: Allocations;
array[team_set] of var team_set: Positions;
array[team_set] of var 0..rounds: Previously;

var int: cost = sum(t in team_set)(
				Previously[t] * weight
			);

constraint alldifferent(Allocations);

constraint inverse(Allocations, Positions);

constraint forall(t in team_set)(
				Previously[t] = 1 <-> (Positions[t] mod teams_per_room) = previous_positions[t]
			);

constraint forall(r in 0..(rooms-2), n in r+1..rooms-1, i,j in 1..teams_per_room)(
				scores[Allocations[(r * teams_per_room) + i]] >= scores[Allocations[(n * teams_per_room) + j]]
			);

solve minimize cost;
	
output
	[ "Allocations: "] ++
	[
		 show(Allocations[i]) | i in team_set
	] ++
	[ "\n" ++ "Positions: " ] ++
	[
		show(Positions[i]) | i in team_set
	] ++
	[ "\n" ] ++
	[ "Cost: " ++ show(cost)] ++
	[ "\n" ];