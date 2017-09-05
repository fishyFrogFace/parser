functor
export
    length:Length
    take:Take
    drop:Drop
    append:Append
    member:Member
    position:Position
    dropWhile:DropWhile
    split:Split
    map:Map
    reverse:Reverse
define
    fun {Length List}
        case List of _|T then
            1 + {Length T}
        else
            0
        end
    end

    fun {Take List Count}
        if Count > 0 then
            case List of H|T then
                H | {Take T Count-1}
            else
                nil
            end
        else Count = 0
            nil
        end
    end

    fun {Drop List Count}
        if Count > 0 then
            case List of nil then
                nil
            [] _|T then {Drop T Count-1}
            end
        else
            List
        end
    end

    fun {Append List1 List2}
        case List1 of nil then
            List2
        [] H|T then H|{Append T List2}
        end
    end
    
    fun {Member List Element}
        case List of nil then
            false
        [] H|T then
            if H == Element then
                true
            else
                {Member T Element}
            end
        end
    end

    fun {Position List Element}
        case List of H|T then
            if H == Element then
                0
            else
                1+{Position T Element}
            end
        end
    end

    fun {DropWhile Condition List}
        case List of
            nil then nil
            [] H|T then
                if {Condition H} then
                    {DropWhile Condition T}
                else
                    List
                end
        end
    end
    
    /* how to send in negative of Condition from another function? */
    fun {Break Condition List}
        case List of
            nil then nil#nil
            [] H|T then
                local N B in
                    N#B = {Break Condition T}
                    if {Condition H} then
                        (H|N)#B
                    else
                        nil#T
                    end 
                end 
         end     
    end 

    fun {NotSpace Ch}
        if Ch == 32 then
            false
        else
            true
        end 
    end 
 
 
    fun {Split List}
        local N B in
            N#B = {Break NotSpace List}
            case {DropWhile Char.isSpace List} of
                nil then nil
                [] _|_ then N|{Split B}
            end
        end
    end

    fun {Map Func List}
        case List of
            nil then nil
            [] H|T then {Func H}|{Map Func T}
        end
    end

    fun {Reverse List}
        fun {RevList Acc List}
            case List of
                nil then Acc
                [] H|T then {RevList H|Acc T}
            end
        end
        in
        {RevList nil List}
    end

end
