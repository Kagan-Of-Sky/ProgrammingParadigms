/*
Mark Kaganovsky (100963794)

Carleton University
COMP3007 - Programming Paradigms
Fall 2018
Prof.Robert Collier

Assignment 4 part 3

This question implements the following problem (torch-bridge problem):

While traveling through Moria, Gandalf, Aragorn, Gilmi, and Legolas approach a great chasm.
There is a bridge going across but it can only hold two people at a time.
Because of poor planning, they only have a single torch between the four of them,
and since the mines are particularly dark, the torch must be carried whenever someone tries to cross the bridge.

Legolas is the fastest and can cross the bridge in only one minute,
and Aragorn is in pretty good shape too so he can cross it in three minutes.
Gimli, being a dwarf, has stubby legs, so it will take him five minutes,
and since Gandalf is over 2000 years old, it will take him eight minutes to cross the bridge.
Whenever two of the company cross the bridge together, they must stick together so that
they both know where they are going. This entails that they move at the pace of the slower of the two.

Is it possible for all of them to cross the bridge in 15 minutes or less? How?
*/




% Speeds of characters
speed(legolas, 1).
speed(aragorn, 3).
speed(gimli, 5).
speed(gandalf, 8).




% Given a list of character names, obtains their speeds.
namesToSpeeds([], []).
namesToSpeeds([H|Names], [Speed|Speeds]) :- speed(H,Speed), namesToSpeeds(Names,Speeds).




/*
------------------------------------------------------------------------------------------------------------
USAGE EXAMPLE:
------------------------------------------------------------------------------------------------------------
crossBridge(15, state([legolas,aragorn,gimli,gandalf], [], left, 0), X).

crossBridge(MAX TIME, state(LEFT_SIDE_CHARACTERS, RIGHT_SIDE_CHARACTERS, TORCH_POSITION, INITIAL_TIME), X).

This problem is modeled by the characters trying to cross a bridge from left to right
That is, it is the goal for all characters to make it to the right side after starting from the left.
*/
crossBridge(MaxTime, state([], _, right, TimeTaken), []) :-
	TimeTaken =< MaxTime.

crossBridge(MaxTime, state(LeftStart, RightStart, TorchPosition, TimeTaken), [T|Transitions]) :-
	TimeTaken < MaxTime,
	transition(state(LeftStart, RightStart, TorchPosition, TimeTaken), T, AfterState),
	crossBridge(MaxTime, AfterState, Transitions).




% This handles the usual case where there 2 people on the left are available to cross the bridge.
transition(state(LeftStart, RightStart, left, StartTime), cross2right(Crossers, torch, timeTaken(TimeTaken)), state(LeftEnd, RightEnd, right, EndTime)) :-
	length(LeftStart,LeftStartLength),
	LeftStartLength >= 2,
	choose(LeftStart, 2, Crossers),
	subtract(LeftStart, Crossers, LeftEnd),
	append(RightStart, Crossers, RightEnd),
	namesToSpeeds(Crossers,Speeds),
	max_list(Speeds, TimeTaken),
	EndTime is StartTime + TimeTaken.

% This handles a single person running back.
transition(state(LeftStart, RightStart, right, StartTime), backtrack1Left(Crosser, torch, timeTaken(TimeTaken)), state(LeftEnd, RightEnd, left, EndTime)) :-
	choose(RightStart, 1, Crosser),
	subtract(RightStart, Crosser, RightEnd),
	append(LeftStart, Crosser, LeftEnd),
	namesToSpeeds(Crosser,Speeds),
	sumlist(Speeds, TimeTaken),
	EndTime is StartTime + TimeTaken.




/*
This rule chooses n elements from a list.

Example Usage:
	?- choose([1,2,3,4],2,X).
	X = [1, 2] ;
	X = [1, 3] ;
	X = [1, 4] ;
	X = [2, 3] ;
	X = [2, 4] ;
	X = [3, 4] ;
	false.
*/
choose(_,0,[]).
choose([H|T],LeftToSelect,[H|Selected]) :- LeftToSelect > 0, Less1 is LeftToSelect - 1, choose(T,Less1,Selected).
choose([_|T],LeftToSelect,Selected) :- LeftToSelect > 0, choose(T,LeftToSelect,Selected).