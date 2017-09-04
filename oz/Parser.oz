functor
import
    Application(exit:Exit)
    System
    List at './List.ozf'
define
    fun {Lex Input}
        {List.split Input}
    end
    
    {System.show {Lex "h oi"}}
    {Exit 0}
end
