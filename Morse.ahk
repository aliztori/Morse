#Include <Utils\Hot>
#Include <Abstractions\Input>


class Morse {

	/**
	 * @param {string} inputKey 
	 * @param {number} pressTimeout 
	 * @param {number} holdTimeOut 
	 * @param {boolean} tips 
	 * @returns {string} 
	 */
	static Call(Key := Hot.Raw(A_ThisHotkey), pressTimeout := 300, holdTimeOut := 3000, tips := true) {

		;Press interval
		p_TimeOut := Round(Abs(PressTimeOut) / 1000, 2) 
		;Long holding interval
		h_TimeOut := Round(Abs(HoldTimeOut) / 1000) 	

		Hold := Press := 0, Pattern := ''
		tipsTxt := (Key = A_ThisHotkey) ? (A_ThisHotkey " : ") : (A_ThisHotkey " ―> " Key " : ")

		if (Key ~= "(?i:LButton|MButton|RButton)")
		{
			(Tips) && ToolTip(A_ThisHotkey " : Press " key " Please")

			;Doesnt Block key & And Doesnt Support Sign Shift Number
			if !KeyWait(key, "D T" holdTimeOut) 
				return (ToolTip(), "")
		}

		else if !RegExMatch(A_ThisHotkey, "i)^[#^!+<>~*$]*" key "(?:\s+up)?$")
			return this.Input(key, PressTimeOut, HoldTimeOut, Tips)

		loop {

			Tc := A_TickCount
			KeyWait(Key, "T" h_TimeOut)

			(A_TickCount - Tc > PressTimeOut) 
				? (Pattern .= "1", Hold++, Pattern_Tip .= "▬")
				: (Pattern .= "0", Press++, Pattern_Tip .= "●")
			

			; (Tips) && (
			; 	key = A_ThisHotkey
			; 		? ToolTip(A_ThisHotkey " : " Hold Press " " Pattern_Tip)
			; 		: ToolTip(A_ThisHotkey " ―> " Key " : " Hold Press " " Pattern_Tip)
			; )

			(Tips) && ToolTip(tipsTxt Hold Press " " Pattern_Tip)
			
			if KeyWait(key, "D T" p_TimeOut)
				continue

			ToolTip()
			return Pattern
		}
	}

	/**
	 * 
	 * @param {string} inputKey 
	 * @param {number} PressTimeOut 
	 * @param {number} HoldTimeOut 
	 * @param {number} Tips 
	 * @returns {string} 
	 * 
	 * if we use for main function input is not blocked
	 * @example ^g::Morse("m")
	 */
	static Input(inputKey, PressTimeOut := 200, HoldTimeOut := 3000, Tips := true)
	{
		PTout := Round(Abs(PressTimeOut) / 1000, 2)
		HTout := Round(Abs(HoldTimeOut) / 1000)
		Hold := Press := 0, Pattern := ""

		(Tips) && ToolTip(A_ThisHotkey " : Press " inputKey " Please")

		key := input.GetKey(1)
		if key != inputKey
			return ToolTip()

		loop {

			Tc := A_TickCount
			KeyWait(inputKey, "T" HTout)

			(A_TickCount - Tc > PressTimeOut) 
				? (Hold++, Pattern .= "1", Pattern_Tip .= '▬')
				: (Press++, Pattern .= "0", Pattern_Tip .= '●')

			(Tips) && ToolTip(A_ThisHotkey " ―> " inputKey " : " Hold Press " " Pattern_Tip)

			key := input.GetKey(PTout)
			if key = inputKey
				continue

			ToolTip()
			return Pattern
		}
	}

	/**
	 * if you Pass anything except A_thishotkey, it prees and send it in real
	 * @param {string} inputKey 
	 * @param {number} timeOut 
	 * @param {number} cycleLimit 
	 * @param {number} tips 
	 * @returns {number} 
	 */
	static Press(Key := Hot.Raw(A_ThisHotkey), timeOut := 300, cycleLimit := -1, tips := true)
	{
		tout := Round(Abs(timeOut) / 1000, 2), press := 0

		tipsTxt := (key = A_ThisHotkey) ? A_ThisHotkey : (A_ThisHotkey " ―> " Key)

		while KeyWait(Key) {

			if press = CycleLimit
				press := 0

			press += A_PriorHotkey = "" Or A_TimeSincePriorHotkey > Timeout
			(Tips) && ToolTip(tipsTxt " : " press)
			
			if !KeyWait(Key, "D T" tout)
				return (ToolTip(), press)
		}
	}

	static PressTip(args*) {
	
		key := Hot.Raw(A_ThisHotkey), press := 0
		
		while KeyWait(Key) {

			(press = args.Length) && press := 1

			(A_PriorHotkey = "" Or A_TimeSincePriorHotkey > 300) && press++

			ToolTip(args[press])

			if !KeyWait(Key, "D T0.3")
				return (ToolTip(), args[press])
		}
	}

	/**
	 * Figure out whether you held or tapped the current hotkey.
	 * @param howLong *Float* How much time in seconds is considered a hold
	 * @returns {Boolean} True if you held the key, false if you tapped it
	 */
	static Hold(key, howLong) => !KeyWait(key, "T" howLong)
}
