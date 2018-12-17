/*
Mark Kaganovsky - 100963794

Carleton University
COMP3007 - ProgramMing Paradigms
Fall 2018
Prof.Robert Collier

Assignment 4 part 2b
*/




/*
Cound the number of elements with a given range in a list.

Example:
?- countInRange([2,4,6,8,10,12,14,16,18], 3, 11, X).
X = 4 .
*/
countInRange([],_, _,0).

countInRange([Head|Tail],Min,Max,Sum1) :-
	Head >= Min, Head =< Max,
	countInRange(Tail,Min,Max,Sum),
	Sum1 is (Sum + 1).

countInRange([Head|Tail],Min,Max,Sum) :-
	(Head < Min; Head > Max),
	countInRange(Tail,Min,Max,Sum).