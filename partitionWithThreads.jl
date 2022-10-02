#
# Parallel version of partition solver
# using threads
#
#
# Program in Julia to solve, by brute force, the partition problem
#
# The program reads from the standard input
# It reads the size of the problem (up to 32)
# Then it reads the integer values in the multiset
#
function evaluate( A::Array{Base.Int64,1}, candidate,n)
    powerOf2 = 1
    sumOneSet = 0
    sumOtherSet = 0
    for i = 1:n
        if (candidate & powerOf2 != 0) 
            sumOneSet = sumOneSet + A[i]
        else
            sumOtherSet = sumOtherSet + A[i]
        end
        powerOf2 = powerOf2 * 2
    end
    if sumOneSet == sumOtherSet
        return true
    else
        return false
    end
end


#
# Print the actual values in the solution
#
function printSolution(values::Array{Base.Int64,1},solution,n)
    print("The value in the solution for the partition problem ")
    powerOf2 = 1 
    sum1 = 0
    sum2 = 0
    print("In the first partition: ")
    for i = 1:n
        if (solution & powerOf2 != 0) 
            print(values[i]," ")
            sum1 += values[i]
        
        end
        powerOf2 = powerOf2 * 2
    end
    println()
    println("Sum: ",sum1)
    print("In the second partition: ")
    powerOf2 = 1
    for i = 1:n
        if (solution & powerOf2 == 0) 
            print(values[i]," ")        
            sum2 += values[i]
        end
        powerOf2 = powerOf2 * 2
    end
    println()
    println("Sum: ",sum2)
end

function solverPartition()
nString = readline()
n = tryparse(Base.Int64,nString)
println(n)

# Allocate the Array
values = Array{Base.Int64,1}(undef, n)
values = [parse(Base.Int64, x) for x in split(readline())]
for i = 1:n
    print(values[i]," ")
end
println()
possibleSubSets = 2^(n-1) - 1
println("Number of possible subsets: ",possibleSubSets)
setOfSolutions = Set()
setLock = ReentrantLock()
Threads.@threads for i = 1:possibleSubSets
    if evaluate(values,i,n) 
    	 lock(setLock)
	 try    
            push!(setOfSolutions,i)
       finally
            unlock(setLock)
       end
        
    #    println(i," is a solution")
    #else
    #    println(i," is not a solution")
    end
end
#println("Set of solutions: ",setOfSolutions)
println("A solution is ",first(setOfSolutions))
printSolution(values,first(setOfSolutions),n)
end
 
elapsedTime = @elapsed solverPartition()
println("Elapsed time: ",elapsedTime)
