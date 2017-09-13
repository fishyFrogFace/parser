functor
import
    List at './List.ozf'
    System
export
    shunt:Shunt
define

    OpPrec = ops(
                 minus:0
                 plus:0
                 divide:1
                 multiply:1
                 inverse:2)

    fun {ShuntInternal Tokens OperatorStack OutputStack}
        case OperatorStack of
            nil then {ShuntTokens Tokens OperatorStack OutputStack}
            [] _|nil then {ShuntTokens Tokens OperatorStack OutputStack}
            [] operator(type:H)|operator(type:S)|T then
                if {OpLeq H S} then
                    {ShuntInternal Tokens operator(type:H)|T operator(type:S)|OutputStack}
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
        {ShuntTokens Tokens nil nil}
    end
    
    {System.show {Shunt [number(3.0) operator(type:minus) number(10.0) operator(type:multiply) number(9.0) operator(type:plus) number(3.0)]}}
end
