functor
import
    System
    List at './List.ozf'
export
    execute:Execute
    tokenize:Tokenize
    lex:Lex
    interpret:Interpret
define
    
    Opmap = ops(
                    minus:Number.'-'
                    plus:Number.'+'
                    divide:Float.'/'
                    multiply:Number.'*')
    Commands = cmd(
                    p:proc {$ Stack} {System.show {List.reverse Stack}} end
                    d:fun {$ Stack}
                        case Stack of
                            nil then nil
                            [] H|T then H|H|T
                            end
                      end)
    Inverses = inv(
                   i:Number.'~'
                   m:fun {$ Num}
                        1.0/Num
                     end)

    fun {Lex Input}
        {List.split Input}
    end
 
    fun {CheckInts L}
        fun {CheckIntsInternal L}
            case L of
                nil then true
                [] H|T then
                    if {And (H =< 57) (H >= 48)} then
                        {CheckIntsInternal T}
                    else
                        false
                    end
            end
        end
        in
        case L of
            nil then false
            [] _|_ then {CheckIntsInternal L}
        end
    end
    
    fun {FloatSplit L}
        {List.map CheckInts {List.splitOn L 46}}
    end

    fun {CheckFloats L}
        case {FloatSplit L} of
            nil then false
            [] true|true|nil then true
            [] true|nil then true
            else
                false
        end
    end
    
    fun {OneToken Lexeme}
        case Lexeme of
            nil then nil
            [] _|_ then
                if {CheckFloats Lexeme} then
                    number({String.toFloat Lexeme})
                elseif {List.member ["+" "-" "/" "*" "p" "d" "^" "i"] Lexeme} then
                    case Lexeme of
                        "+" then operator(type:plus)
                        [] "-" then operator(type:minus)
                        [] "/" then operator(type:divide)
                        [] "*" then operator(type:multiply)
                        [] "p" then command({String.toAtom Lexeme})
                        [] "d" then command({String.toAtom Lexeme})
                        [] "^" then inverse(m)
                        [] "i" then operator(String.toAtom Lexeme)
                    end
                else
                    invalid({String.toAtom Lexeme}) 
                end
        end
    end

    fun {Tokenize Lexemes}
        {List.map OneToken Lexemes}
    end

    fun {InterpretInv Inv Stack Tokens}
        case Stack of
            nil then error(emptyStack)|Stack
            [] number(Num)|Remainder then {Iterate number({Inverses.Inv Num})|Remainder Tokens}
            else
                error(nonNum)|Stack
        end
    end

    fun {InterpretOp Op Stack Tokens}
        case Stack of
            nil then error(emptyStack)|Stack
            [] _|nil then error(emptyStack)|Stack
            [] number(Num1)|number(Num2)|Remainder then
                {Iterate number({Opmap.Op Num2 Num1})|Remainder Tokens}
            else
                error(nonNum)|Stack
        end
    end

    fun {Iterate Stack Tokens}
        case Tokens of
            nil then {List.reverse Stack}
        [] number(Num)|T then {Iterate number(Num)|Stack T}
        [] invalid(_)|_ then error(parse)|Stack
        [] command(p)|T then
            {Commands.p Stack}
            {Iterate Stack T}
        [] command(d)|T then {Iterate {Commands.d Stack} T}
        [] inverse(Inv)|T then {InterpretInv Inv Stack T}
        [] operator(type:Op)|T then {InterpretOp Op Stack T}
        else
            error(nonToken)|Stack
        end
    end

    fun {Interpret Tokens}
        {Iterate nil Tokens}
    end
    
    fun {Execute Line}
        {Interpret {Tokenize {Lex Line}}}
    end
end
