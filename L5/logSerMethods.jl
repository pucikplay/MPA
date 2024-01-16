import Base.rand, StatsBase.params
import Random, Distributions, Statistics, StatsBase

# 0 helper
params(d::LogSer) = (d.p)

# rand(::AbstractRNG, d::UnivariateDistribution)
function rand(rng::AbstractRNG, d::LogSer)
    (p) = params(d)
    u = rand(rnd)
    return 
# sampler(d::Distribution)
# logpdf(d::UnivariateDistribution, x::Real)
# cdf(d::UnivariateDistribution, x::Real)
# quantile(d::UnivariateDistribution, q::Real)
# minimum(d::UnivariateDistribution)
# maximum(d::UnivariateDistribution)
# insupport(d::UnivariateDistribution, x::Real)