+================================================
+
+    Vectric machine output configuration file
+
+================================================
+
+ History
+
+ Who      When       What
+ ======== ========== ===========================
+ Tony M   13/09/2010 Written
+ Mark     16/07/2015 Added New Segment section.
+ Garrett  02/11/2024 Removed all arc related settings cuz Snapmaker's slow at arcs.
+ Garrett  20/12/2024 Added support for Laser. POWER=
+ ================================================

POST_NAME = "Snapmaker CNC - Garrett (mm) (*.cnc)"

+---------------------------------------------------
+ Mark postprocessor as laser aware.
+  Dec-20-2024 - garrett - Added
+---------------------------------------------------
LASER_SUPPORT = "YES"


FILE_EXTENSION = "cnc"

UNITS = "MM"

+------------------------------------------------
+    Line terminating characters
+------------------------------------------------

LINE_ENDING = "[13][10]"

+------------------------------------------------
+    Block numbering
+------------------------------------------------

LINE_NUMBER_START     = 0
LINE_NUMBER_INCREMENT = 10
LINE_NUMBER_MAXIMUM = 9999999

+================================================
+
+    Formating for variables
+
+================================================

VAR LINE_NUMBER = [N|A| N|1.0]
VAR SPINDLE_SPEED = [S|A| S|1.0]
VAR FEED_RATE = [F|C| F|1.1]
VAR X_POSITION = [X|C| X|1.3]
VAR Y_POSITION = [Y|C| Y|1.3]
VAR Z_POSITION = [Z|C| Z|1.3]
VAR X_HOME_POSITION = [XH|A| X|1.3]
VAR Y_HOME_POSITION = [YH|A| Y|1.3]
VAR Z_HOME_POSITION = [ZH|A| Z|1.3]


+---------------------------------------------------
+ Laser Support. In experimenting with Luban, the
+ Laser seems to have a power setting between 0-250
+ Vectric uses 0-100. 
+
+ To break this entry down in plain English, 
+ saying that the POWER output from our toolpath
+ should be used everywhere in our subsequent post
+ definition file where we have the the variable 
+ [P]. But we should only only output a command as
+ the POWER value changes (C). We will replace the 
+ [P] variable locations in our our toolpath output
+ with the command 'P' (so put out a P before the
+ number). The power value should be
+ formatted as a whole number with no decimal points 
+ (1.0) and should be multiplied from its default 
+ by 2.5 (so I have a range from 0-250). 
+---------------------------------------------------
VAR POWER = [P|C|P|1.0|2.5]

+---------------------------------------------------
+ Commands output when the jet (laser) is turned on
+ This uses the POWER command defined above [P]
+---------------------------------------------------

begin JET_TOOL_ON

"M4 [P]"

+---------------------------------------------------
+ Commands output when the jet (laser) is turned off
+ Snapmaker uses M5.
+---------------------------------------------------

begin JET_TOOL_OFF

"M5"

+---------------------------------------------------
+ Commands output when the jet (laser) power is changed
+ There example just showed a GBRL output of "[P]"
+---------------------------------------------------

begin JET_TOOL_POWER

"M4 [P]"



+================================================
+
+    Block definitions for toolpath output
+
+================================================

+---------------------------------------------------
+  Commands output at the start of the file
+  Dec-20-24 - garrett - I added M2003/M2004, as
+  Luban seemed to add (it says it's for cross
+  hair calibration). M2000 W1 P100 - enclosure
+  light on. M2000 W2 P100 - enclosure fan.
+  M4 S0 laser off. M8 - coolant air on.
+. M2000 L23 P0, turns the laser half diode on.
+---------------------------------------------------

begin HEADER

"G90"
"G0 Z10.00 F600"
"G21"
"M3 [S]"
"M2003"
"M2004"
"M2000 W1 P100"
"M2000 W2 P100"
"M4 S0"
"M8"
"M2000 L23 P0"


+---------------------------------------------------
+  Commands output for rapid moves
+  Dec-20-2024 - garrett - Added [P] for laser
+---------------------------------------------------

begin RAPID_MOVE

"G0 [X] [Y] [Z] [P]"


+---------------------------------------------------
+  Commands output for the first feed rate move
+  Dec-20-2024 - garrett - Added [P] for laser
+---------------------------------------------------

begin FIRST_FEED_MOVE

"G1 [X] [Y] [Z] [F] [P]"


+---------------------------------------------------
+  Commands output for feed rate moves
+  Dec-20-2024 - garrett - Added [P] for laser
+---------------------------------------------------

begin FEED_MOVE

"G1 [X] [Y] [Z] [P]"


+---------------------------------------------------
+ Command output after the header to switch spindle on
+  Dec-20-2024 - garrett - Added this for laser support.
+                don't want laser on during plunge.
+                Snapmaker M3 sets laser power to last power.
+---------------------------------------------------
begin SPINDLE_ON

"[S]M3"

+---------------------------------------------------
+ Commands output for the plunge move
+  Dec-20-2024 - garrett - Added this for laser support.
+                don't want laser on during plunge.
+---------------------------------------------------
begin PLUNGE_MOVE

"G1[X][Y][Z][F]"



+---------------------------------------------------
+  Commands output at the end of the file
+  Dec-20-2024 - garrett - Add S0 to M5 to turn
+  laser off. M9 - coolant air off.
+. M2000 L23 P1 - turn back on laser diode full power.
+---------------------------------------------------

begin FOOTER

"M5 S0"
"M9"
"M2000 L23 P1"



