 !(C) 2002 RADFusion Inc.
 !Example 2 - Instantiation and Inheritance

 PROGRAM
 INCLUDE('EQUATES.CLW'),ONCE

 MAP
 END

Title     EQUATE('Example 2 - Instantiation and Inheritance')

PlayWave  CLASS,TYPE,MODULE('PLAYWAVE.CLW'),LINK('PLAYWAVE.CLW')
WaveName     CSTRING(FILE:MaxFileName)
Play         PROCEDURE ()
Play         PROCEDURE (STRING xWaveName)
           END

Noise1   PlayWave     !Instantiate new object of PlayWave type
Noise2   PlayWave
Noise3   PlayWave

Window WINDOW('Title here'),AT(50,50,228,114),FONT('Verdana',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         GRAY,DOUBLE
       BOX,AT(0,-1,146,115),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(146,-1,82,115),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       BUTTON('OK'),AT(153,3,35,14),USE(?OkButton),DEFAULT
       BUTTON('OK(2)'),AT(153,20,35,14),USE(?OkButton2),DEFAULT
       BUTTON('OK(3)'),AT(153,37,35,14),USE(?OkButton3),DEFAULT
       STRING('Education Services'),AT(8,19),TRN
       STRING('Title here'),AT(8,28),USE(?TitleString),TRN
       BUTTON('Cancel'),AT(191,3,36,14),USE(?CancelButton)
       STRING('Copyright (c) 2002 - RADFusion Inc.'),AT(9,91,209,10),TRN
     END

  CODE
  OPEN(Window)
  TARGET{PROP:Text} = Title
  ?TitleString{PROP:Text} = Title
  ACCEPT
    CASE ACCEPTED()
    OF ?CancelButton
      POST(EVENT:CloseWindow)
    OF ?OkButton
      Noise1.WaveName = LONGPATH() & '\f22.wav'
      Noise1.Play()
    OF ?OkButton2
      Noise2.WaveName = LONGPATH() & '\train.wav'
      Noise2.Play()
    OF ?OkButton3
      Noise3.WaveName = LONGPATH() & '\a10flyby.wav'
      Noise3.Play()
    END
  END

