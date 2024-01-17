struct Passenger
    head::Int
    body::Int
end

struct Plank
    wheel::Int
end

struct Wagon
    planks::Vector{Plank}
end

struct PassengerWagon
    wagon::Wagon
    passengers::Vector{Passenger}
end

struct Train
    engine::Wagon
    wagons::Vector{PassengerWagon}
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

function wheelCount(planks::Vector{Plank})
    return sum(p -> sign(p.wheel), planks)
end

function elemCount(t::Train)
    wagons = length(t.wagons)
    wheels = [wheelCount(w.wagon.planks) for w in t.wagons]
    planks = [length(w.wagon.planks) for w in t.wagons]
    wheel_sizes = [p.wheel for w in t.wagons, p in w.wagon.planks]
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
    _string *= ")"
    return _string
end

function _passengerFormat(p::Vector{Passenger})
    _string = "("
    for pa in p
        _string *= "[$(pa.head), $(pa.body)],"
    end
    _string *= ")"
    return _string
end

function _trainFormat(t::Train)
    _string = ""
    _string *= "$(_wagonFormat(t.engine))\n"
    for i in eachindex(t.wagons)
        space = repeat(' ', ndigits(i) + 2)
        _string *= "$i: $(_wagonFormat(t.wagons[i].wagon))\n$(space)$(_passengerFormat(t.wagons[i].passengers))\n"
    end
    return _string
end

Base.show(io::IO, t::Train) = print(io, _trainFormat(t))