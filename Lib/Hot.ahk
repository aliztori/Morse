
class Hot {

	static First(HotKey)  => RegExReplace(HotKey, "&.*$|\s")
	static Second(HotKey) => RegExReplace(HotKey, "^.*&|\s|(?i:up$)")
	static Both(HotKey)   => [this.First(Hotkey), this.Second(Hotkey)]

	static Raw(HotKey := A_ThisHotkey, Which?) {

		Hotkey := RegExReplace(Hotkey, "i)\s+up$")
		Hotkey := RegExReplace(Hotkey, "^[#^!+<>~*$]+(.+)", "$1")
		; Hotkey := RegExReplace(Hotkey, "^[#^!+<>~*$]+(\w{0,}(?!\sup)?)", "$1")
		; Hotkey := RegExReplace(Hotkey, "^[#^!+<>~*$]+(\w*)(?=up)?", "$1")
		
		if InStr(Hotkey, " & ")
		{
			switch (Which ?? 2) 
			{		
				case 0: return this.Raw(HotKey, 1) " & " this.Raw(HotKey, 2)
				case 1: return this.First(Hotkey)
				case 2: return this.Second(Hotkey)				
				case 3: return this.Both(Hotkey)
			}	
		}

		return Hotkey 		
	}

	static Keys(Hotkey := A_ThisHotkey) {

		KeyNames := []

		; Regex := RegExMatchAll(Hotkey, "i)(?:[*$~])?(?'LeftRight'[<>RL])?(?'Symbol'[#!^+])")

		; loop Regex.Length
		; {
		; 	Key := ""
		; 	Match := Regex[A_Index]
		; 	; MsgBox Match[1]

		; 	Switch Match['LeftRight'] {
		; 		Case "<": Key .= "L"
		; 		Case ">": Key .= "R"
		; 	}
	
		; 	Switch Match['Symbol'] {
		; 		Case "#": Key .= "Win"
		; 		Case "!": Key .= "Alt"
		; 		Case "^": Key .= "Ctrl"
		; 		Case "+": Key .= "Shift"
		; 	}

		; 	if key = "Win"
		; 		key := "Lwin"

		; 	if Key != "" && !KeyNames.HasVal(Key)
		; 		KeyNames.Push(Key)
		; }

		

		; Ctrl 
		InStr(Hotkey, "<^") && KeyNames.Push("LCtrl")
		
		if InStr(Hotkey, ">^")
			KeyNames.Push("RCtrl")

		else {
			RegExMatch(Hotkey, "([<>]?+\^)[^\s]?", &Match)
			(Match[1] = "^") && KeyNames.Push("Ctrl")
		}


		; Alt 
		InStr(Hotkey, "<!") && KeyNames.Push("LAlt")
			
		if InStr(Hotkey, ">!")
			KeyNames.Push("RAlt")

		else {
			RegExMatch(Hotkey, "([<>]?!)[^\s]?", &Match)
			(Match[1] = "!") && KeyNames.Push("Alt")
				
		} 
		
		; Shift 
		if InStr(Hotkey, "<+")
			KeyNames.Push("LShift")

		if InStr(Hotkey, ">+")
			KeyNames.Push("RShift")
		
		else {
			RegExMatch(Hotkey, "([<>]?\+)[^\s]?", &Match)
			(Match[1] = "+") && KeyNames.Push("Shift")
		} 

		; Win
		if InStr(Hotkey, "<#")
			KeyNames.Push("LWin")

		if InStr(Hotkey, ">#")
			KeyNames.Push("RWin")

		else {
			RegExMatch(Hotkey, "([<>]?#)[^\s]?", &Match)
			(Match[1] = "#") && KeyNames.Push("LWin")
		}

		Key := this.Raw(Hotkey, 3)
		(Key is Array) ? KeyNames.Push(Key*) : KeyNames.Push(Key)
		return KeyNames
	}
	
	static KeyWait(Hotkey, Options?) {
		
		for KeyName in this.Keys(Hotkey)
			if !KeyWait(KeyName, Options?)
				return false	

		return true
	}

	static KeyState(Hotkey, Mode := "P") {	

		for KeyName in this.Keys(Hotkey)
			if !Getkeystate(KeyName, Mode)
				return false	

		return true
	}
}
