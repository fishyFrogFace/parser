functor
import
    Application(exit:Exit)
    System
    Open
    List at './List.ozf'
    Parser at './Parser.ozf'
    Shunting at './Shunting.ozf'
define
    fun {Infix Line}
        {Parser.interpret {Shunting.shunt {Parser.tokenize {Parser.lex Line}}}}
    end

    local
        Input
        RInput
        F = {New Open.file init(name:'./Infix.txt' flags:[read])}
        R = {New Open.file init(name:'./Parser.txt' flags:[read])}
    in
        {F read(list:Input size:all)}
        {R read(list:RInput size:all)}
        {System.show {List.map Parser.execute {List.lines RInput}}}
        {System.show {List.map Infix {List.lines Input}}}
    end
    {Exit 0}
end
