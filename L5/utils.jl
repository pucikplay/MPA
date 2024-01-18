struct Passenger
    head::Int
    body::Int
end

struct Plank
    wheel::Int
end

struct Wagon
    planks::Vector{Plank}
    passengers::Vector{Passenger}
end

struct Train
    engine::Wagon
    wagons::Vector{Wagon}
end

struct ElemCounts
    wagons::Vector{Int}
    wheels::Vector{Int}
    planks::Vector{Int}
    wheel_sizes::Vector{Int}
    passengers::Vector{Int}
    head_sizes::Vector{Int}
    body_sizes::Vector{Int}
end

loga(p::Real) = rand(LogSer(p))
loga(p::Real, min_size::Int) = rand(truncated(LogSer(p), lower=min_size))
geo(p::Real) = rand(Geometric(1-p))
geo(p::Real, min_size::Int) = rand(truncated(Geometric(1-p), lower=min_size))
bern(p::Real) = rand(Bernoulli(p))
poiss(p::Real) = rand(Poisson(p))

function wheelCount(w::Vector{Plank})
    if length(w) == 0
        return 0
    end
    return sum(p -> sign(p.wheel), w)
end

function elemCount(t::Train)::ElemCounts
    wagons = [length(t.wagons)]
    wheels = [wheelCount(w.planks) for w in t.wagons]
    planks = [length(w.planks) for w in t.wagons]
    wheel_sizes = filter(!iszero, [p.wheel for p in collect(Iterators.flatten([w.planks for w in t.wagons]))])
    passengers = [length(w.passengers) for w in t.wagons]
    head_sizes = [p.head for p in collect(Iterators.flatten([w.passengers for w in t.wagons]))]
    body_sizes = [p.body for p in collect(Iterators.flatten([w.passengers for w in t.wagons]))]

    return ElemCounts(wagons,
                      wheels,
                      planks,
                      wheel_sizes,
                      passengers,
                      head_sizes,
                      body_sizes)
end

function _wagonFormat(w::Wagon)
    _string = "("
    for p in w.planks
        _string *= "$(p.wheel),"
    end
    _string *= ")\n    ("
    for pa in w.passengers
        _string *= "[$(pa.head), $(pa.body)],"
    end
    _string *= ")"
    return _string
end

function _passengerFormat(p::Vector{Passenger})
    
    return _string
end

function _trainFormat(t::Train)
    _string = ""
    _string *= "$(_wagonFormat(t.engine))\n"
    for i in eachindex(t.wagons)
        # space = repeat(' ', ndigits(i) + 2)
        _string *= "$i: $(_wagonFormat(t.wagons[i]))\n"
    end
    return _string
end

Base.show(io::IO, t::Train) = print(io, _trainFormat(t))

struct Stats
    min::Int
    max::Int
    avg::Float64
    exp::Float64
    chbshv::Float64
    kurt::Float64
end

struct Record
    wagons::Stats
    wheels::Stats
    planks::Stats
    wheel_sizes::Stats
    passengers::Stats
    head_sizes::Stats
    body_sizes::Stats
end

function getStats(V::Vector{Int})::Stats
    if isempty(V)
        return Stats(0, 0, 0.0, 0.0, 0.0, 0.0)
    end
    min = minimum(V)
    max = maximum(V)
    E = mean(V)
    diff = [abs(x - E) for x in V]
    exp = sort(diff)[Int(ceil(0.95 * length(V)))]
    Var = var(V)
    chbshv = sqrt(Var/0.05)
    kurt = kurtosis(V)

    return Stats(min, max, E, exp, chbshv, kurt)
end
