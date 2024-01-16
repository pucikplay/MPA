using Distributions
import Base.rand, StatsBase.params
import Random, Distributions, Statistics, StatsBase

struct LogSer{T<:Real} <: DiscreteUnivariateDistribution
    p::T ## p parameter
    function LogSer{T}(p::T; check_args = true) where {T<:Real}
        check_args && Distributions.@check_args(LogSer, p>0 && 1>p)
        return new{T}(p)
    end
end

# constructor for no type and param Float64
function LogSer(p::Float64; check_args = true)
    return LogSer{Float64}(p, check_args = check_args)
end

# 0 helper
StatsBase.params(d::LogSer) = (d.p,)

# rand(::AbstractRNG, d::UnivariateDistribution)
function Base.rand(rng::AbstractRNG, d::LogSer)
    p = StatsBase.params(d)

    r = log1p(-p)
    while true
        V = rand(rnd)
        if V >= p
            return 1
        end
        U = rand(rng)
        q = -expm1(r * U)
        if V <= q*q
            result = floor(1 + log(V) / log(q))
            if (result < 1) || (V == 0.0)
                continue
            else
                return result
            end
        end
        if V >= q
            return 1
        end
        return 2
    end
end
# sampler(d::Distribution)
Distributions.sampler(rng::AbstractRNG, d::LogSeq) = Base.rand(rng::AbstractRNG, d::LogSer)

# logpdf(d::UnivariateDistribution, x::Real)
function Distributions.pdf(d::LogSer{T}, x::Real) where {T<:Real}
    p = params(d)
    return (-p^k)/(k*log(1-p))
end

Distributions.logpdf(d::LogSer, k::Integer) = log(pdf(d,k))

# cdf(d::UnivariateDistribution, x::Real)
function Distributions.cdf(d::LogSer)
    
end

# quantile(d::UnivariateDistribution, q::Real)
# minimum(d::UnivariateDistribution)
# maximum(d::UnivariateDistribution)
# insupport(d::UnivariateDistribution, x::Real)