using Distributions
include("utils.jl")
include("log_ser.jl")

MIN_WHEEL_SIZE = 1
MIN_HEAD_SIZE = 1
MIN_BODY_SIZE = 1
MIN_WAGON_SIZE = 1

Seq(x) = 1/(1-x)
Cyc(x, min_size) = log(Seq(x)) - sum(n -> x^n/n, 1:min_size-1; init=0)
Set(x) = exp(x)
Pa(x) = Cyc(x,MIN_HEAD_SIZE) * Cyc(x,MIN_BODY_SIZE)
Pl(x) = x*x * (1 + Cyc(x,MIN_WHEEL_SIZE))
Pl_wheel(x) = x*x * Cyc(x,MIN_WHEEL_SIZE)
Wa(x) = Pl(x) * Seq(Pl(x))
Wa_wheel(x) = Pl_wheel(x) * Pl_wheel(x) * Seq(Pl(x))
Tr(x) = Wa(x) * Seq(Wa(x) * Set(Pa(x)))

function GPa(x::Real)::Passenger
    head = loga(x, MIN_HEAD_SIZE)
    body = loga(x, MIN_BODY_SIZE)
    return Passenger(head, body)
end

function GPl(x::Real)::Plank
    if bern(1/(1 + Cyc(x,1))) == 1
        return Plank(0)
    end
    return Plank(loga(Cyc(x,MIN_WHEEL_SIZE), MIN_WHEEL_SIZE))
end

function GPl_wheel(x::Real)::Plank
    return Plank(loga(Cyc(x,MIN_WHEEL_SIZE), MIN_WHEEL_SIZE))
end

function GWa(x::Real)::Vector{Plank}
    wagon = [GPl(x) for _ in 1:geo(Pl(x))]
    # wagon = append!([GPl_wheel(x), GPl_wheel(x)],[GPl(x) for _ in 1:geo(Pl(x))])
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

GTr(0.48512)