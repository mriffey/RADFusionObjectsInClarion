  !(C) 2002 RADFusion Inc.
  PROGRAM

  INCLUDE('EQUATES'),ONCE

  MAP
  END

Title          EQUATE('Example 4 Contructors and Destructors')

               SECTION('OBJECTDEF')                                 !Section definition

TypeQue        QUEUE,TYPE                                           !Queue definition only
MyString         STRING(15)
               END

PlayWave       CLASS(),TYPE,MODULE('PLAYWAVE.CLW'),LINK('PLAYWAVE.CLW')
WaveName         CSTRING(FILE:MaxFileName)
Play             PROCEDURE()
Play             PROCEDURE(STRING xWaveName)
               END

ConstructClass CLASS,TYPE,MODULE('CNSTRUCT.CLW'),LINK('CNSTRUCT.CLW')
WorkQ           &TypeQue                                            !Reference to typed queue
Noise           &PlayWave                                           !Reference to typed class
FillQue         PROCEDURE,LONG,PROC
Construct       PROCEDURE
Destruct        PROCEDURE
               END

               SECTION('RESTOFPROGRAM')                             !End of the above section

Work           ConstructClass                                       !Declare a new class

Window WINDOW('Title here'),AT(50,50,228,114),FONT('Verdana',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         GRAY,DOUBLE
       BOX,AT(0,-1,128,115),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(128,-1,99,115),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       LIST,AT(135,24,86,77),USE(?List1),VSCROLL,COLOR(0FBD6C1H),FORMAT('20L(2)|M~Names~@s10@')
       BUTTON('OK'),AT(131,2,,14),USE(?OkButton),LEFT,ICON('wizok.ico'),DEFAULT
       STRING('Education Services'),AT(4,1),TRN
       STRING('Title here'),AT(4,10,120,94),USE(?TitleString),TRN,ANGLE(300)
       BUTTON('Cancel'),AT(178,2,46,14),USE(?CancelButton),LEFT,ICON('wizcncl.ico')
       STRING('Copyright (c) 2002  - RADFusion Inc.'),AT(4,104,,10),TRN
     END

  CODE                                                              !Work's constructor auto runs here
  OPEN(Window)
  TARGET{PROP:Text} = Title
  ?TitleString{PROP:Text} = Title
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      IF Work.FillQue()                                             !If FillQue method returns non-zero, there are entries
        ?List1{PROP:From} = Work.WorkQ                              !Inform the list where to get its data
        Work.WorkQ.Mystring = 'ETC 2002!'                           !Prime the key value in queue field
        GET(Work.WorkQ,Work.WorkQ.Mystring)                         !Get the matching value
        SELECT(?List1,POINTER(Work.WorkQ))                          !and select it.
      END
    OF EVENT:Accepted
      CASE ACCEPTED()
      OF ?CancelButton
        POST(EVENT:CloseWindow)                                     !Work's destructor auto runs here
      OF ?OkButton
        Work.Noise.WaveName = LONGPATH() & '\doh.wav'
        Work.Noise.Play()
      END
    END
   END

