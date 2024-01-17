include("boltzmann_train.jl")

p_values = [p for p in range(0.0001, 0.48512, length=10)]
data_dir = "data/"
test_no = 10000

for p in p_values
    wagons = Vector{Int}()
    wheels = Vector{Int}()
    planks = Vector{Int}()
    wheel_sizes = Vector{Int}()
    passengers = Vector{Int}()
    head_sizes = Vector{Int}()
    body_sizes = Vector{Int}()

    train = GTr(p)
    elems = elemCount(train)

end