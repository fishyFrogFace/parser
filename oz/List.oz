functor
import
    Application(exit:Exit)
    System
define
    fun {Length List}
        case List of H|T then
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
            [] H|T then {Drop T Count-1}
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

    {Exit 0}
end
