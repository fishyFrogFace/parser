functor
import
    Application(exit:Exit)
    System
    List at './List.ozf'
    Open
define
    fun {Lex Input}
        {List.split Input}
    end 
    
    /*doesn't catch original empty string*/
    fun {CheckInts List}
        case List of
            nil then true
            [] H|T then
                if {And (H =< 57) (H >= 48)} then
                    {CheckInts T}
                else
                    false
            end
        end
    end
    
    fun {OneToken Lexeme}
        case Lexeme of
            nil then nil
            [] _|_ then
                if {CheckInts Lexeme} then
                    number({String.toInt Lexeme})
                elseif {List.member ["+" "-" "/" "*" "p" "d" "^"] Lexeme} then
                    case Lexeme of
                        "+" then operator(type:plus)
                        [] "-" then operator(type:minus)
                        [] "/" then operator(type:divide)
                        [] "*" then operator(type:multiply)
                        [] "p" then command({String.toAtom Lexeme})
                        [] "d" then command({String.toAtom Lexeme})
                        [] "^" then operator(type:inverse)
                    end
                else
                    invalid({String.toAtom Lexeme}) 
                end
        end
    end

    fun {Tokenize Lexemes}
        {List.map OneToken Lexemes}
    end
    
    fun {Interpret Tokens}
        Operators = ops(
                        minus:Number.'-'
                        plus:Number.'+'
                        divide:Int.'div'
                        multiply:Number.'*')
        Commands = cmd(
                        p:proc {$ Stack} {System.show {List.reverse Stack}} end
                        d:fun {$ H|T} H|H|T end)
        fun {Iterate Stack Tokens}
            case Tokens of
                nil then {List.reverse Stack}
            [] number(Num)|T then {Iterate number(Num)|Stack T}
            [] invalid(E)|_ then error(parse)|Stack
            [] command(p)|T then 
                {Commands.p Stack}
                {Iterate Stack T}
            [] command(d)|T then {Iterate {Commands.d Stack} T}
            [] operator(type:inverse)|T then
                case Stack of
                    nil then error(emptyStack)|Stack
                    [] number(Num)|Remainder then {Iterate number(~Num)|Remainder T}
                    else
                        error(nonNum)|Stack
                    end
            [] operator(type:Op)|T then
                case Stack of
                    nil then error(emptyStack)|Stack
                    [] _|nil then error(emptyStack)|Stack
                    [] number(Num1)|number(Num2)|Remainder then
                        {Iterate number({Operators.Op Num2 Num1})|Remainder T}
                    else
                        error(nonNum)|Stack
                end
            end
        end
        in
        {Iterate nil Tokens}
    end
    
    fun {Execute Line}
        {Interpret {Tokenize {Lex Line}}}
    end

    local
        Input
        F = {New Open.file init(name:'./Parser.txt' flags:[read])}
    in
        {F read(list:Input size:all)}
        {System.show{List.map Execute {List.lines Input}}}
    end
    {Exit 0}
end
