; If the library files are in a subfolder called Lib next to the script, use this
#include <Morse>
; https://www.autohotkey.com/docs/v2/Scripts.htm#lib

; These directives are required to use morse function
#MaxThreadsPerHotkey 1
#MaxThreadsBuffer false 

F1::{
    pattern := Morse()

    if (pattern = "0")
        ToolTip("Short press")

    else if (pattern = "00")
        ToolTip("Two Short press")

    else if (pattern = "01")
        ToolTip("Short+Long press")
    
    else 
        ToolTip("Press pattern" . Pattern)
}

^F2::{
    press := Morse.Press("F2")
    ToolTip("you pressed 'g' " press " Times")
}

F3::{
    choosed := Morse.PressTip("arg1", "arg2", "arg3")
    ToolTip("you Choose " choosed)    
}


^Esc::ExitApp()
