 !(C) 2002 RADFusion Inc.
 !Example 6 (Overriding)

 PROGRAM
 INCLUDE('EQUATES.CLW'),ONCE

 MAP
 END

Title      EQUATE('Example 6 (Overriding)')

               SECTION('OBJECTDEF')

PlayWave       CLASS(),TYPE,MODULE('PLAYWAVE.CLW'),LINK('PLAYWAVE.CLW')
WaveName         CSTRING(FILE:MaxFileName)
Play             PROCEDURE
Play             PROCEDURE(STRING xWaveName)
               END

OverrideClass  CLASS(PlayWave),TYPE,MODULE('OVERRIDE.CLW'),LINK('OVERRIDE.CLW')
WinRef           &WINDOW                     !Reference to a window
Control          LONG(0)
FlashSpeed       LONG(0)
Toggle           LONG,STATIC                 !Ensure value does not change
Flash            PROCEDURE
Play             PROCEDURE                   !Override the Play method in Parent class PlayWave
Init             PROCEDURE 
               END

               SECTION('RESTOFPROGRAM')

Work           OverrideClass                 !Instantiate the Work class

Window WINDOW('Title here'),AT(50,50,228,114),FONT('Verdana',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         GRAY,DOUBLE
       BOX,AT(0,-1,128,115),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(128,-1,99,115),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       BUTTON('OK'),AT(130,2,,14),USE(?OkButton),LEFT,ICON('wizok.ico'),DEFAULT
       BUTTON('Cancel'),AT(178,2,,14),USE(?CancelButton),LEFT,ICON('wizcncl.ico')
       STRING('Education Services'),AT(8,19),USE(?DevControl),TRN
       STRING('Title here'),AT(8,28),USE(?TitleString),TRN
       STRING('Copyright (c) 2002 RADFusion Inc.'),AT(8,98,,10),TRN
     END

  CODE
  OPEN(Window)
  TARGET{PROP:Text} = Title
  ?TitleString{PROP:Text} = Title
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      Work.WinRef     &= Window                       !Inherit the Window by reference assignment
      Work.FlashSpeed = 44                            !Assign a value to the FlashSpeed property
      Work.Control    = ?DevControl                   !Which control is affected?
      Work.Init()                                     !Call init method
    OF EVENT:Timer
      Work.Flash()                                    !When this event fires, call the flash method
    OF EVENT:Accepted
      CASE ACCEPTED()
      OF ?CancelButton
        POST(EVENT:CloseWindow)
      OF ?OkButton
        Work.WaveName = LONGPATH() & '\themic~1.wav'
        Work.Play()
      END
    END
  END
  
