functor
import
    Application(exit:Exit)
    System
    List at './List.ozf'
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
            [] H|T then
                if {CheckInts Lexeme} then
                    number(String.toInt Lexeme)
                elseif {List.member ["+" "-" "/" "*"] Lexeme} then
                    case Lexeme of
                        "+" then operator(type:plus)
                        [] "-" then operator(type:minus)
                        [] "/" then operator(type:divide)
                        [] "*" then operator(type:multiply)
                    end
                else
                    {System.show "Parse error, invalid character"} 
                end
        end
    end

    fun {Tokenize Lexemes}
        {List.map OneToken Lexemes}
    end
end
