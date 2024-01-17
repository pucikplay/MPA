using SpecialFunctions
using Distributions
using Random
import Random.rand
import SpecialFunctions.beta_inc
import Distributions.@check_args, Distributions.@distr_support, Distributions.DiscreteUnivariateDistribution

struct LogSer{T<:Real} <: DiscreteUnivariateDistribution
    p::T
    function LogSer{T}(p::T) where {T <: Real}
        new{T}(p)
    end
end

function LogSer(p::Real; check_args::Bool=true)
    @check_args LogSer (p, zero(p) < p < one(p))
    return LogSer{typeof(p)}(p)
end

LogSer() = LogSer{Float64}(0.5)

@distr_support LogSer 1 Inf

### Conversions
Distributions.convert(::Type{LogSer{T}}, p::Real) where {T<:Real} = LogSer(T(p))
Base.convert(::Type{LogSer{T}}, d::LogSer) where {T<:Real} = LogSer{T}(T(d.p))
Base.convert(::Type{LogSer{T}}, d::LogSer{T}) where {T<:Real} = d

### Parameters
Distributions.params(d::LogSer) = (d.p,)
Distributions.partype(::LogSer{T}) where {T<:Real} = T


### Statistics

Distributions.mean(d::LogSer) = (-d.p)/(log1p(-d.p) * (1 - d.p))

Distributions.mode(d::LogSer{T}) where {T<:Real} = one(T)

Distributions.var(d::LogSer) = (d.p^2 + d.p * log1p(-d.p)) / ((1 - d.p)^2 * (log1p(-d.p))^2)

### Evaluations

function Distributions.pdf(d::LogSer, x::Int)
    insupport(d, x) ? -(d.p^x) / (log1p(-d.p) * x) : zero(d.p)
end

function Distributions.logpdf(d::LogSer, x::Real)
    insupport(d, x) ? log(pdf(d,Int(x))) : log(zero(d.p))
end

function Distributions.cdf(d::LogSer, x::Real)
    pdf_d(a) = pdf(d,a)
    insupport(d, x) ? sum(pdf_d, 1:x) : zero(d.p)
end

function Distributions.quantile(d::LogSer, p::Real)
    k = 1
    cdf_k = pdf(d,k)
    while cdf_k < p
        k += 1
        cdf_k += pdf(d,k)
    end
    return k
end

### Sampling

function Random.rand(rng::AbstractRNG, d::LogSer)
    r = log1p(-d.p)
    while true
        V = Random.rand(rng)

        if V >= d.p
            return 1
        end

        U = Random.rand(rng)
        q = -expm1(r * U)

        if V <= q * q
            result = Int(floor(1 + log(V) / log(q)))
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

sampler(rng::AbstractRNG, d::LogSer) = rand(rng::AbstractRNG, d::LogSer)