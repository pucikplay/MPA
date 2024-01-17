using Distributions
include("utils.jl")
include("log_ser.jl")

MIN_WHEELS = 4
MIN_WHEEL_SIZE = 4

Seq(x) = 1/(1-x)
Cyc(x) = log(Seq(x))
Set(x) = exp(x)
Pa(x) = Cyc(x)^2
Pl(x) = x*x * (1 + Cyc(x))
Wa(x) = Pl(x) * Seq(Pl(x))
Tr(x) = Wa(x) * Seq(Wa(x) * Set(Pa(x)))

function GCycPa(x)
    k = rand(LogSer(x))
    return k
end

function GCycWh(x)
    p = 1/(1 + Cyc(x))
    if rand(Bernoulli(p)) == 1
        return 0
    end
    k = rand(truncated(LogSer(x), lower=MIN_WHEEL_SIZE))
    return k
end

function GSeqPl(x)
    p = Pl(x)
    k = rand(Geometric(1-p)) + 1
    return [GPl(x) for _ in 1:k]
end

function GSetPa(x)
    p = Set(x)
    k = rand(Poisson(p))
    return [GPa(x) for _ in 1:k]
end

function GSeqWaPa(x)
    k = rand(Geometric(1-x))
    return [PassengerWagon(GWa(x), GSetPa(x)) for _ in 1:k]
end

GPa(x) = Passenger(GCycPa(x), GCycPa(x))
GPl(x) = Plank(GCycWh(x))
function GWa(x)
    planks = GSeqPl(x)
    while !(MIN_WHEELS <= wheelCount(planks) < length(planks))
        planks = GSeqPl(x)
    end
    Wagon(planks)
end
GTr(x) = Train(GWa(x), GSeqWaPa(x))

GTr(0.0)
