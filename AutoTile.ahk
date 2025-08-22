#Requires AutoHotkey v2
#SingleInstance Force
Persistent True

; AutoTiling
; Adapted from felyp333's script transposed to AHK V2 by uname
; https://www.autohotkey.com/boards/viewtopic.php?style=1&f=94&t=137304
DllCall("RegisterShellHookWindow", "uint", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), ShellEvent)

ShellEvent(wParam, lParam, msg, *) {

    conditional := false
    conditional := wParam=32772 or conditional

    if conditional
    {
        Try {
            Sleep 100
            WinGetPos(, , &windowWidth, &windowHeight, lParam)
            MonitorGetWorkArea(FocusedMonitor(), &Left, &Top, &Right, &Bottom)

            ; TLDR of this math:
            ; From lower to higher aspect ratio monitors (16:9 up to 32:9 default),
            ; we linearly reset the ideal window aspect ratio up from 1 to 1.5.
            Scalar := 1.5
            AspRatio_Standard := 16/9   ; Monitor aspect ratio at which we aim for square windows.
            AspRatio_UltraWide := 32/9  ; Super wide monitor aspect ratio at which we limit the target aspect ratio.
            AspRatio_Current := (Right - Left)/(Bottom - Top)

            ; Our ideal apsect ratio is the window aspect ratio above which we shall tile horizontally, and any
            ; taller / narrower we shall tile vertically.
            IdealAspectRatio := 1 + ( Scalar - 1 ) * ( AspRatio_Current - AspRatio_Standard ) / AspRatio_Standard

            ; Split ratio ought to have a lower limit of 1 (1:1) to better support portrait monitor orientation.
            IdealAspectRatio := Min(IdealAspectRatio, 1.5)

            ; Split ratio needs an upper limit, or else ultrawide monitors will
            ; have windows that are way too hamburger-style to be practical.
            IdealAspectRatio := Max(IdealAspectRatio, 1)

            ; Tile vertically if the window is wide enough
            direction := windowWidth / 1.5 < windowHeight ? "vertical" : "horizontal"
            RunWait( EnvGet("LocalAppData") "\glzr.io\glazewm\cli\glazewm.exe command set-tiling-direction " direction ,,"Hide")
        }
    }
}

; Picking up the coordinates of each monitor will allow us to
; account for extreme widescreen monitors
global MonitorXCoords := Array()
MonitorXPositioning()
FocusedMonitor()
{
    global MonitorXCoords
    CoordMode("Mouse","Screen")
    MouseGetPos(&X, &Y)
    loop MonitorXCoords.Length {
        if X < Float(MonitorXCoords[A_Index]) {
            Return A_Index
        }
    }
}
MonitorXPositioning()
{
    global MonitorXCoords
    XCoords := ""
    loop MonitorGetCount()
    {
        MonitorGet(A_Index, , , &Right)
        XCoords .= Right "`n"
    }
    XCoords := Sort(RTrim(XCoords,'`n'),'N')
    Return MonitorXCoords := StrSplit(Sort(XCoords,"N"),"`n")
}