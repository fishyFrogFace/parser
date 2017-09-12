functor
import
    List at './List.ozf'
export
    shunt:Shunt
define

    OpPrec = ops(
                 minus:0
                 plus:1
                 divide:2
                 multiply:3
                 inverse:4)

    fun {ShuntInternal Tokens OperatorStack OutputStack}
        case OperatorStack of
            nil then {ShuntTokens Tokens OperatorStack OutputStack}
            [] _|nil then {ShuntTokens Tokens OperatorStack OutputStack}
            [] operator(type:H)|operator(type:S)|T then
                if {OpLeq H S} then
                    {ShuntTokens Tokens operator(type:H)|T operator(type:S)|OutputStack}
                else
                    {ShuntTokens Tokens OperatorStack OutputStack}
                end
        end
    end

    fun {ShuntTokens Tokens OperatorStack OutputStack}
        case Tokens of
            nil then {List.reverse {List.append OperatorStack OutputStack}}
            [] operator(type:Op)|T then
                {ShuntInternal T operator(type:Op)|OperatorStack OutputStack}
            [] H|T then
                {ShuntInternal T OperatorStack H|OutputStack}
        end
    end

    fun {OpLeq Pushing Top}
        if OpPrec.Pushing =< OpPrec.Top then
            true
        else
            false
        end
    end

    fun {Shunt Tokens}
        {ShuntInternal Tokens nil nil}
    end
end
