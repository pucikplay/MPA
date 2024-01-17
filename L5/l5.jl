using DataStructures
using CSV
include("boltzmann_train.jl")

p_values = [0.4,0.45,0.475,0.48,0.485,0.4851,0.48512]
data_dir = "data/"
test_no = 100

for p in p_values
    wagons = Vector{Int}()
    wheels = Vector{Int}()
    planks = Vector{Int}()
    wheel_sizes = Vector{Int}()
    passengers = Vector{Int}()
    head_sizes = Vector{Int}()
    body_sizes = Vector{Int}()

    for _ in 1:test_no
        train = GTr(p)
        elems = elemCount(train)

        push!(wagons, elems.wagons)
        append!(wheels, elems.wheels)
        append!(planks, elems.planks)
        append!(wheel_sizes, elem.wheel_sizes)
        append!(passengers, elems.passengers)
        append!(head_sizes, elem.head_sizes)
        append!(body_sizes, elems.body_sizes)
    end

    
end