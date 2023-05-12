# Morse

An AutoHotkey library that allows you to map multiple actions to one key using a tap-and hold system  
Long press / Tap / Multi Tap / Tap and Hold / Multi Tap and Hold etc are all supported


With different hotkey press patterns many more actions can be triggered than just with a hotkey press itself. For example, the key "a" sends "a", two short presses sends "ä", a long press sends "á", and so on. Like Morse codes for different actions.



<!-- # Normal Usage
## Setup
1. Download a zip from the releases page
2. Extract the zip to a folder of your choice
3. Run the Example script -->

## Usage

Include the library
```Autohotkey
#include Lib\Morse.ahk
; or
#include <Morse>
```

The following Morse function determines the base key from the current hotkey, and starts monitoring it. If it is released after longer time than timeout (default to 300ms), "1" is appended to the Pattern variable. If the key is released sooner, "0" is appended.


Then the scripts waits for the key to be pressed down again. If it is not pressed within the timeout period, the 0-1 pattern of the last key presses are returned, otherwise the next key hold time will be appended to the Pattern


*example:*
------------

```Autohotkey
1:: {

    pattern := Morse(1)

    if (pattern = "0")
        ToolTip("Short press")

    else if (pattern = "00")
        ToolTip("Two Short press")

    else if (pattern = "01")
        ToolTip("Short+Long press")
    
    else 
        ToolTip("Press pattern" . Pattern)
}
```

# Press method
## Usage

It works exactly like the previous function, except that it returns the number of presses and there is no long hold, and this method returns the number of times you pressed the key with the specified interval (Default: 300)

```
^g:: {
    press := Morse.Press("g")
    ToolTip("you pressed 'g' " press " Times")
}
```
