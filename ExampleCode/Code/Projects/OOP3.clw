!(C) 2002 RADFusion Inc.
 !Example 3 - Manually creating and destroying objects

 PROGRAM
 INCLUDE('EQUATES.CLW'),ONCE

 MAP
 END

Title        EQUATE('Example 3 - Manually creating and destroying objects')

PlayWave     CLASS(),TYPE,MODULE('PLAYWAVE.CLW'),LINK('PLAYWAVE.CLW')
WaveName       CSTRING(FILE:MaxFileName)
Play           PROCEDURE ()
Play           PROCEDURE (STRING xWaveName)
             END

             SECTION('OBJECTDEF')

TypeQue      QUEUE,TYPE
MyString       STRING(15)
             END

WorkClass    CLASS,TYPE,MODULE('WORKCLAS.CLW'),LINK('WORKCLAS.CLW')
WorkQ          &TypeQue
Noise          &PlayWave
FillQue        PROCEDURE (),LONG,PROC
             END

             SECTION('RESTOFPROGRAM')

Work         WorkClass                               !Create an instance of the WorkClass object.

Window WINDOW('Title here'),AT(50,50,228,171),FONT('Arial',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         GRAY,DOUBLE
       BOX,AT(0,23,137,148),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(137,23,90,147),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       LIST,AT(147,28,75,136),USE(?List1),VSCROLL,COLOR(0D1F7FEH),FORMAT('20L(2)|M~Names~@s20@')
       BUTTON('OK'),AT(123,4,50,14),USE(?OkButton),LEFT,ICON('wizok.ico'),DEFAULT
       STRING('Education Services'),AT(3,2),TRN,FONT(,,COLOR:Blue,)
       STRING('Title here'),AT(3,27,132,144),USE(?TitleString),TRN,FONT(,,COLOR:Blue,),ANGLE(450)
       BUTTON('Cancel'),AT(176,4,,14),USE(?CancelButton),LEFT,ICON('wizcncl.ico')
       BOX,AT(1,0,226,23),USE(?Box3),COLOR(COLOR:Black),FILL(0D6FECBH)
       STRING('Copyright (c) 2002  - RADFusion Inc.'),AT(3,12,116,10),TRN,LEFT
     END

  CODE
  OPEN(Window)
  TARGET{PROP:Text} = Title
  ?TitleString{PROP:Text} = Title
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      Work.WorkQ &= NEW TypeQue                            !Create an instance of the TypeQue queue
?     ASSERT (~Work.WorkQ &= NULL)
      Work.Noise &= NEW PlayWave                           !Create an instance of the PlayWave object
?     ASSERT (~Work.Noise &= NULL)
      IF Work.FillQue()
        ?List1{PROP:From} = Work.WorkQ
        SELECT(?List1,1)
      END
    OF EVENT:Accepted
      CASE ACCEPTED()
      OF ?CancelButton
        POST(EVENT:CloseWindow)
      OF ?OkButton
        Work.Noise.WaveName = 'sweet.wav'
        Work.Noise.Play()
      END
    END
  END
  IF ~Work.WorkQ &= NULL
    FREE(Work.WorkQ)                                      !Delete entries, de-allocate memory
    DISPOSE(Work.WorkQ)                                   !Destroy instance of TypeQue queue
  END
  IF ~Work.Noise &= NULL 
    DISPOSE(Work.Noise)                                   !Destroy instance of PlayWave
  END

