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
for i = 1:possibleSubSets
    if evaluate(values,i,n) 
        push!(setOfSolutions,i)
    #    println(i," is a solution")
    #else
    #    println(i," is not a solution")
    end
end
println("Set of solutions: ",setOfSolutions)
