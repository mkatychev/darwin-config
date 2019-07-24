; Ender 3 Custom End G-code
G1 F1800 E-4 ; Retract filament 4 mm to prevent oozing
G1 F3000 Z20 ; Move Z Axis up 20 mm to allow filament ooze freely
G4 ; Wait
M220 S100 ; Reset Speed factor override percentage to default (100%)
M221 S100 ; Reset Extrude factor override percentage to default (100%)
G91 ; Set coordinates to relative
G1 X0 Y{machine_depth} F1000 ; Move Heat Bed to the front for easy print removal
M84 ; Disable stepper motors
G91 ;relative position set
G1 F1800 E-3 ; Retract 3 mm to prevent oozing on startup
G1 F3000 Z10 ; Move up 10 mm to clear the print
G90 ;absolute position set
G28 X0 Y0 ; home x and y axis to clear the print
M106 S0 ; turn off part cooling fan
M104 S0 ; turn off extruder
M140 S0 ; turn off bed
M84 ; disable motors
; End of custom end GCode

