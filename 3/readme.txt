Mark Kaganovsky
100963794

Carleton University
COMP3007 - Programming Paridigms
Fall 2018
Prof.Robert Collier
Assignment 3




The functions in the assignment are grouped by the question they correspond to in the haskell source code file.




Question 1: Pseudorandom Numbers
	lcg :: Float -> Float
		This linear congruential generator takes a number as an argument and produces the next in the sequence.




Question 2: Recursive Structures
	Please see the "Expression" data type in the source file.




Question 3: Expression Tree Functions
	Evaluation:
		evaluate :: Expression -> Float -> Maybe Float
			Takes an expression tree as an argument, a substitute for any variables in the expression, and outputs
			a Maybe Float. If there is a division by zero then the returned value will be "Nothing", otherwise it will
			be a "Just Float" value.
	
	String representation:
		expressionStringify :: Expression -> [Char]
			Takes an expression tree as an argument and prints the human readable string representation of it.
	
	Tree representation:
		Did not finish.




Question 4: Expression Tree Mutation
	expressionMutate :: Expression -> Float -> Expression
		The mutate function takes the expression to mutate, a seed float, and outputs a mutated expression tree.




Question 5: Trees of Best Fit
	fit :: Expression -> (Float -> Float) -> [Float] -> Float
		Takes an expression as an argument, a function which takes a float and returns a float, an array of values to
		send to the expression and function, and returns a float between 0 and 1.