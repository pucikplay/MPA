using DataStructures
using CSV
using Plots
include("boltzmann_train.jl")

# p_values = range(0.2, 0.4851, length=100)
p_values = range(0.5, 0.8405, length=100)

# plots_dir = "plots"
plots_dir = "plots_capped"
test_no = 100000

info = ["wagons", "wheels", "planks", "wheel_sizes", "passengers", "head_sizes", "body_sizes"]
records = Vector{Record}()

for p in p_values
    println(p)
    if p == 0.8405
        global test_no = 1000
    end

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

        append!(wagons, elems.wagons)
        append!(wheels, elems.wheels)
        append!(planks, elems.planks)
        append!(wheel_sizes, elems.wheel_sizes)
        append!(passengers, elems.passengers)
        append!(head_sizes, elems.head_sizes)
        append!(body_sizes, elems.body_sizes)
    end

    record = Record(getStats(wagons),
                    getStats(wheels),
                    getStats(planks),
                    getStats(wheel_sizes),
                    getStats(passengers),
                    getStats(head_sizes),
                    getStats(body_sizes))
    
    push!(records, record)
end

println("Plotting...")

for i in eachindex(info)
    stats = [getproperty(records[j], Symbol(info[i])) for j in eachindex(p_values)]
    plot(p_values,
         [[s.avg for s in stats],
          [s.min for s in stats]],
         title=info[i],
         labels=["avg" "min"],)
    savefig("$plots_dir/$(info[i])")
    plot(p_values,
         [[s.avg for s in stats],
          [s.avg - s.chbshv for s in stats],
          [s.avg + s.chbshv for s in stats],
          [s.avg - s.exp for s in stats],
          [s.avg + s.exp for s in stats]],
         title="$(info[i])_concentration",
         labels=["avg" "chbshv-" "chbshv+" "exp-" "exp+"])
    savefig("$plots_dir/$(info[i])_concentration")
    plot(p_values,
         [s.kurt for s in stats],
         title="$(info[i])_kurtosis",
         labels=["kurt"])
    savefig("$plots_dir/$(info[i])_kurtosis")
end