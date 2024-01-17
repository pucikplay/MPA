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
    wagons::Int
    wheels::Vector{Int}
    planks::Vector{Int}
    wheel_sizes::Vector{Int}
    passengers::Vector{Int}
    head_sizes::Vector{Int}
    body_sizes::Vector{Int}
end

loga(p::Real) = rand(LogSer(p))
loga(p::Real, min_size::Int) = rand(truncated(LogSer(p), lower=min_size))
geo(p::Real) = rand(Geometric(1-p)) + 1
geo(p::Real, min_size::Int) = rand(truncated(Geometric(1-p), lower=min_size)) + 1
bern(p::Real) = rand(Bernoulli(p))
poiss(p::Real) = rand(Poisson(p))


function wheelCount(w::Vector{Plank})
    if length(w) == 0
        return 0
    end
    return sum(p -> sign(p.wheel), w)
end

function elemCount(t::Train)
    wagons = length(t.wagons)
    wheels = [wheelCount(w.planks) for w in t.wagons]
    planks = [length(w.planks) for w in t.wagons]
    wheel_sizes = [p.wheel for w in t.wagons, p in w.planks]
    passengers = [length(w.passengers) for w in t.wagons]
    head_sizes = [p.head for w in t.wagons, p in w.passengers]
    body_sizes = [p.body for w in t.wagons, p in w.passengers]

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