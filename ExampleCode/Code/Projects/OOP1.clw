 !(C) 2002 RADFusion, Inc.
 !Example 1 - Declaring a CLASS

  PROGRAM
  INCLUDE('EQUATES.CLW'),ONCE

Title     EQUATE('Example 1 - Declaring a CLASS')

  MAP
    INCLUDE('SNDAPI.CLW'),ONCE                    !Include the API definition for playing a WAV file.
  END

PlayWave  CLASS,TYPE
WaveName      CSTRING(FILE:MaxFileName)
Play          PROCEDURE
Play          PROCEDURE(STRING xWaveName)
           END

MakeNoise   PlayWave       !Instantiate the PlayWave CLASS

Window WINDOW('Title here'),AT(50,50,228,113),FONT('Verdana',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         GRAY,DOUBLE
       BOX,AT(0,0,137,115),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(136,0,91,115),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       BUTTON('Play'),AT(142,2,35,14),USE(?PlayButton),LEFT,ICON('Wizok.ico'),DEFAULT
       BUTTON('Play It Again'),AT(142,21,75,14),USE(?PlayTooButton),LEFT,ICON('Wizok.ico'),DEFAULT
       STRING('Education Services'),AT(8,19),TRN
       STRING('Title here'),AT(8,28),USE(?TitleString),TRN
       BUTTON('Cancel'),AT(181,2,43,14),USE(?CancelButton),LEFT,ICON('Wizcncl.ico')
       STRING('Copyright (c) 2002  - RADFusion Inc.'),AT(9,91,209,10),TRN
     END

   CODE                                             !Main code logic
   OPEN(Window)
   TARGET{PROP:Text} = Title
   ?TitleString{PROP:Text} = Title
   ACCEPT
     CASE ACCEPTED()
     OF ?CancelButton
        POST(EVENT:CloseWindow)
     OF ?PlayButton
        MakeNoise.WaveName = LONGPATH() & '\halle.wav'
        MakeNoise.Play()
     OF ?PlayTooButton
        MakeNoise.Play(LONGPATH() & '\halle.wav')
     END
   END

!Method code follows main code logic

PlayWave.Play               PROCEDURE 

   CODE
   SndPlaySound(SELF.WaveName,1)
   RETURN


PlayWave.Play               PROCEDURE(STRING xWaveName)

   CODE
   SELF.WaveName = xWaveName
   SndPlaySound(SELF.WaveName,1)
   RETURN















