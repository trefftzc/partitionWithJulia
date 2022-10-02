#
#  Partition with Julia
# 

import CUDA

BLOCK_SIZE = 512

function evaluate!( A::CUDA.CuDeviceVector{Base.Int64,1}, 
                    n::Int64,
                    result::CUDA.CuDeviceVector{Base.Int16,1})
    candidate = (CUDA.blockIdx().x - 1) * CUDA.blockDim().x + CUDA.threadIdx().x + 1
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
    if (candidate < powerOf2/2)
        if sumOneSet == sumOtherSet
            result[candidate] = 1
        else
            result[candidate] = 0
        end
    end
    return
end


function solverPartition()
nString = readline()
n = tryparse(Base.Int64,nString)
println(n)

# Allocate the Array
values = Array{Base.Int64,1}(undef, n)
values = [parse(Base.Int64, x) for x in split(readline())]

deviceValues = CUDA.CuArray{Int64,1}(undef,n)
copyto!(deviceValues,values)
for i = 1:n
    print(values[i]," ")
end
println()
possibleSubSets = 2^(n-1) - 1
println("Number of possible subsets: ",possibleSubSets)

deviceResult = CUDA.zeros(Int16,possibleSubSets)

grid_cols::Int32 = ceil((possibleSubSets) / BLOCK_SIZE)
blocks = (grid_cols)
threads = BLOCK_SIZE
println("Threads: ",threads)
println("Blocks: ",blocks)

print("Time to evaluate: ")
@time begin
    CUDA.@cuda threads = threads blocks = blocks evaluate!(deviceValues,n,deviceResult)
    CUDA.synchronize()
end



maxSolution = reduce(max,deviceResult)

if maxSolution > 0
    print("There is a solution: ")
    # This takes too much memory
    #deviceSolutions = findall(isodd,deviceResult)
    #hostSolutions = Array{Base.Int16,1}(undef, length(deviceSolutions))
    #copyto!(hostSolutions,deviceSolutions)
    
    hostResult=Array{Base.Int16,1}(undef,length(deviceResult))
    copyto!(hostResult,deviceResult)
    setOfSolutions = Set()
    for i = 1:length(hostResult)
        if hostResult[i] > 0
           push!(setOfSolutions,i)
        end
    end
    println("Solutions: ",setOfSolutions)
else
    print("No solution for this problem")
end

end # end function solverPartition



elapsedTime = @elapsed solverPartition()
println("Elapsed time: ",elapsedTime)