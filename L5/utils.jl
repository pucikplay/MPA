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
        _string *= "$i: $(_wagonFormat(t.wagons[i].wagon))\n   $(_passengerFormat(t.wagons[i].passengers))\n"
    end
    return _string
end

Base.show(io::IO, t::Train) = print(io, _trainFormat(t))