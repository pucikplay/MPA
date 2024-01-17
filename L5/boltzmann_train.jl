using Distributions
include("utils.jl")
include("log_ser.jl")

MIN_WHEELS = 4
MIN_WHEEL_SIZE = 4
MIN_HEAD_SIZE = 3
MIN_BODY_SIZE = 3
MIN_WAGON_SIZE = 8

Seq(x) = 1/(1-x)
Cyc(x) = log(Seq(x))
Set(x) = exp(x)
Pa(x) = Cyc(x)^2
Pl(x) = x*x * (1 + Cyc(x))
Wa(x) = Pl(x) * Seq(Pl(x))
Tr(x) = Wa(x) * Seq(Wa(x) * Set(Pa(x)))

function GPa(x::Real)::Passenger
    head = loga(Cyc(x), MIN_HEAD_SIZE)
    body = loga(Cyc(x), MIN_BODY_SIZE)
    return Passenger(head, body)
end

function GPl(x::Real)::Plank
    if bern(1/(1 + Cyc(x))) == 1
        return Plank(0)
    end
    return Plank(loga(Cyc(x), MIN_WHEEL_SIZE))
end

function GWa(x::Real)::Vector{Plank}
    wagon = [GPl(x) for _ in 1:geo(Pl(x))]
    while !(MIN_WHEELS <= wheelCount(wagon) <= length(wagon))
        wagon = [GPl(x) for _ in 1:geo(Pl(x))]
    end
    return wagon
end

function GTr(x::Real)::Train
    engine = Wagon(GWa(x), Vector{Wagon}())
    wagons = Vector{Wagon}()
    wagon_no = geo(Wa(x) * Set(Pa(x)))
    for _ in 1:wagon_no
        wagon = GWa(x)
        passengers = [GPa(x) for _ in 1:poiss(Pa(x))]
        push!(wagons, Wagon(wagon, passengers))
    end
    return Train(engine, wagons)
end

# GTr(0.48512)