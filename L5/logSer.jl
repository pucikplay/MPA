using Distributions


struct LogSer{T<:Real} <: Distribution{Univariate,Discrete}
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

