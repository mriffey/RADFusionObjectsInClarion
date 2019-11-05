 !(C) 2002 RADFusion Inc.
 !Example 7 (Virtual Methods)

 PROGRAM

 INCLUDE('EQUATES.CLW'),ONCE

 MAP
 END

Title     EQUATE('Example 7 (Virtual Methods)')

          SECTION('PLAYWAVE')

PlayWave  CLASS,TYPE,MODULE('PLAYWAV2.CLW'),LINK('PLAYWAV2.CLW')
WaveName     CSTRING(FILE:MaxFileName)
Play         PROCEDURE (),VIRTUAL
CallVirtual  PROCEDURE ()
          END

          SECTION('VIRTUAL1')

Virtual1  CLASS(PlayWave),TYPE,MODULE('VIRTUAL1.CLW'),LINK('VIRTUAL1.CLW')
Play         PROCEDURE (),DERIVED
          END

          SECTION('VIRTUAL2')

Virtual2  CLASS(PlayWave),TYPE,MODULE('VIRTUAL2.CLW'),LINK('VIRTUAL2.CLW')
Play         PROCEDURE (),DERIVED
          END

          SECTION('RESTOFPROGRAM')

V1        Virtual1
V2        Virtual2

Window WINDOW('Title here'),AT(50,50,228,114),FONT('Verdana',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         TILED,GRAY,DOUBLE
       BOX,AT(0,-1,128,115),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(128,-1,99,115),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       BUTTON('OK (V1)'),AT(65,2,,14),USE(?OkButtonV1),LEFT,ICON('wizok.ico'),DEFAULT
       BUTTON('OK (V2)'),AT(121,2,,14),USE(?OkButtonV2),LEFT,ICON('wizok.ico')
       BUTTON('Cancel'),AT(177,2,,14),USE(?CancelButton),LEFT,ICON('wizcncl.ico')
       STRING('Education Services'),AT(9,20),USE(?DevControl),TRN
       STRING('Title here'),AT(9,29),USE(?TitleString),TRN
       STRING('Copyright (c) 2002 RADFusion Inc.'),AT(6,95,,10),TRN
     END

  CODE
  OPEN(Window)
  TARGET{PROP:Text} = Title
  ?TitleString{PROP:Text} = Title
  ACCEPT
    CASE ACCEPTED()
    OF ?CancelButton
      POST(EVENT:CloseWindow)
    OF ?OkButtonV1
      V1.WaveName = LONGPATH() & '\email.wav'
      V1.CallVirtual()
    OF ?OkButtonV2
      V2.WaveName = LONGPATH() & '\chimes.wav'
      V2.CallVirtual()
    END
  END
  












