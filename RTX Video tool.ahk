#Requires AutoHotkey v2.0
Persistent
DetectHiddenWindows true

; Create tray menu
A_TrayMenu.Delete()  ; Clear default menu
A_TrayMenu.Add("Toggle NVIDIA RTX Video", ToggleSuperResolution)
A_TrayMenu.Add("Toggle NVIDIA Control Panel visibility", ToggleHide)
A_TrayMenu.Add()  ; Add separator
A_TrayMenu.Default := "Toggle NVIDIA RTX Video"
A_TrayMenu.Add("Exit", (*) => Exit())

; Set a default status for the indicator
global rtxVideoStatus := "Unknown"
UpdateTrayTip()

; Set icons for different states
iconOff := "OFF.ico"
iconOn := "ON.ico"
iconIDOff := 0
iconIDOn := 0


!^r::ToggleSuperResolution


Run("explorer.exe shell:AppsFolder\NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel")
WinWait("NVIDIA Control Panel", , 10)  ; Wait up to 10 seconds
WinHide("NVIDIA Control Panel")
SetTimer(CheckSuperResolution, 5000) ; Refresh every 5 seconds
CheckSuperResolution()

; I really really want it to be hidden, and sometimes it is not, this will hopefully fix it
WinWait("NVIDIA Control Panel", , 10)
SetTimer(() => WinHide("NVIDIA Control Panel"), -500)
SetTimer(() => WinHide("NVIDIA Control Panel"), -1000)
SetTimer(() => WinHide("NVIDIA Control Panel"), -1500)
SetTimer(() => WinHide("NVIDIA Control Panel"), -2000)
SetTimer(() => WinHide("NVIDIA Control Panel"), -2500)
SetTimer(() => WinHide("NVIDIA Control Panel"), -3000)
SetTimer(() => WinHide("NVIDIA Control Panel"), -3500)
SetTimer(() => WinHide("NVIDIA Control Panel"), -4000)

Exit()
{
    DetectHiddenWindows true
    try {
        WinKill("NVIDIA Control Panel")
    }
    Exit
}

ToggleHide(*)
{
    DetectHiddenWindows false
    if WinExist("NVIDIA Control Panel") {
        WinHide("NVIDIA Control Panel")
    } else {
        WinShow("NVIDIA Control Panel")
    }
}

UpdateTrayTip()
{
	try {
		A_IconTip := "NVIDIA RTX video enhancements: " . rtxVideoStatus
	}
}

ToggleSuperResolution(*)
{
	; Scope the variable so we can access it in this function
	global rtxVideoStatus
    DetectHiddenWindows true
	
    if WinExist("NVIDIA Control Panel") {
        SetControlDelay -1
        
        ; Find and click the video settings tree item
        try {
            videoSettingsControl := ControlGetText("Adjust video image settings")
            ControlClick videoSettingsControl, "NVIDIA Control Panel"
            Sleep 400
        } catch {
            MsgBox("Could not find video settings control in NVIDIA Control Panel.")
            return
        }
        
        ; Find the Super resolution control and combo box
        try {
            superResButton := ControlGetText("Super resolution")
            comboBox := ControlGetClassNN("ComboBox1", "NVIDIA Control Panel")
            
            ; Toggle the setting
            if ControlGetChecked(superResButton) {
                ControlChooseIndex 0, comboBox, "NVIDIA Control Panel"
                rtxVideoStatus := "OFF"
                try {
                    TraySetIcon(iconOff, iconIDOff)
                }
            } else {
                ControlChooseIndex 5, comboBox, "NVIDIA Control Panel"
                rtxVideoStatus := "ON"
                try {
				    TraySetIcon(iconOn, iconIDOn)
                }
            }
            
            UpdateTrayTip()
        } catch {
            MsgBox("Could not toggle Super Resolution setting.")
        }
    } else {
        ; Open NVIDIA Control Panel if it's not already open
        try {
            Run("explorer.exe shell:AppsFolder\NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel")
            WinWait("NVIDIA Control Panel", , 10)  ; Wait up to 10 seconds
            WinMinimize("NVIDIA Control Panel")

            ; I really really want it to be hidden, and sometimes it is not, this will hopefully fix it
            WinWait("NVIDIA Control Panel", , 10)
            SetTimer(() => WinHide("NVIDIA Control Panel"), -500)
            SetTimer(() => WinHide("NVIDIA Control Panel"), -1000)
            SetTimer(() => WinHide("NVIDIA Control Panel"), -1500)
            SetTimer(() => WinHide("NVIDIA Control Panel"), -2000)
        } catch {
            MsgBox("Could not open NVIDIA Control Panel.")
        }
    }
}

CheckSuperResolution() {
    global rtxVideoStatus
    DetectHiddenWindows true

    if WinExist("NVIDIA Control Panel") {
        SetControlDelay -1
        
        ; Find and click the video settings tree item
        try {
            videoSettingsControl := ControlGetText("Adjust video image settings")
            ControlClick videoSettingsControl, "NVIDIA Control Panel"
            Sleep 400
        } catch {
            return
        }
        
        ; Find the Super resolution control and combo box
        try {
            superResButton := ControlGetText("Super resolution")
            comboBox := ControlGetClassNN("ComboBox1", "NVIDIA Control Panel")
            
            ; Toggle the setting
            if ControlGetChecked(superResButton) {
                rtxVideoStatus := "ON"
                try {
                    TraySetIcon(iconOn, iconIDOn)
                }
            } else {
                rtxVideoStatus := "OFF"
                try {
				    TraySetIcon(iconOff, iconIDOff)
                }
            }
            
            UpdateTrayTip()
        }

    }
}