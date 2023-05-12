#Include Hot.ahk

Class Input {
	
	static Call(Length?, EndKeys?, Timeout?) {

		Options := IsSet(Length) ? "L" Length : unset
    
		static inputOpj := InputHook(Options?, EndKeys?)
		inputOpj.Start()
		inputOpj.Wait(Timeout?)
		
		return inputOpj.Input
	}

	static GetKey(Timeout?) {

		static inputOpj := InputHook("S")	
		inputOpj.VisibleNonText := false
		inputOpj.VisibleText := false

		inputOpj.KeyOpt("{All}", "E")

		inputOpj.Start()
		inputOpj.Wait(Timeout?)

		return inputOpj.EndKey
	}

	static GetKeyCombo(Options?, Timeout?)
	{
		static Modifiers := "{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}"
		
		static inputOpj := InputHook(Options?)
		inputOpj.VisibleNonText := false
		inputOpj.VisibleText := false

		inputOpj.KeyOpt("{All}", "E")
		inputOpj.KeyOpt(Modifiers, "-E")

		inputOpj.Start()
		inputOpj.Wait(Timeout?)
		
		return inputOpj.EndMods . inputOpj.EndKey
	}

	static Luck(logo := true, match := "unluck") {
		
		Hot.KeyWait(A_ThisHotkey)
		BlockInput(true)

		if logo {
			
			GuiObj := Gui("AlwaysOnTop -Caption +Owner", "Keyboard And Mouse Locked")
			GuiObj.Add("Picture", "w16 h16 Icon55", "imageres.dll")
			GuiObj.BackColor := "808080"
	
			CoordMode("Mouse", "static"), MouseGetPos(&X, &Y)
			
			GuiObj.Show("x" X " y" Y) ;" NoActivate"
			WinSetTransColor("808080  255", "ahk_id " GuiObj.HWnd)
		}

		KeyboardHook := InputHook("*",, match)
		KeyboardHook.Start()
		KeyboardHook.Wait()
		KeyboardHook.Stop()

		(logo) && GuiObj.Destroy()
		
		BlockInput(false)
	}
}
