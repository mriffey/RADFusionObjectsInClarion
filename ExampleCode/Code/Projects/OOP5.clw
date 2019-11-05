 !(C) 2002 RADFusion Inc.
 !Example 5 (Derivation)

  PROGRAM
  INCLUDE('EQUATES.CLW'),ONCE

  MAP
  END

Title      EQUATE('Example 5 (Derivation)')

               SECTION('OBJECTDEF')

TypeQue        QUEUE,TYPE
MyString         STRING(10)
               END

PlayWave       CLASS(),TYPE,MODULE('PLAYWAVE.CLW'),LINK('PLAYWAVE.CLW')
WaveName         CSTRING(FILE:MaxFileName)
Play             PROCEDURE ()
Play             PROCEDURE (STRING xWaveName)
               END

DerivedClass   CLASS(PlayWave),TYPE,MODULE('DERIVED.CLW'),LINK('DERIVED.CLW')
WorkQ             &TypeQue
FillQue           PROCEDURE (),LONG
Construct         PROCEDURE ()
Destruct          PROCEDURE ()
               END

               SECTION('RESTOFPROGRAM')

Work           DerivedClass

Window WINDOW('Title here'),AT(50,50,228,114),FONT('Verdana',10,COLOR:Navy,FONT:bold),ICON('Clarion.ico'), |
         GRAY,DOUBLE
       BOX,AT(0,-1,128,115),USE(?Box1),COLOR(COLOR:Black),FILL(0FEE6DEH)
       BOX,AT(128,-1,99,115),USE(?Box2),COLOR(COLOR:Black),FILL(0FB9D7DH)
       LIST,AT(134,22,88,74),USE(?List1),VSCROLL,FONT('Verdana',10,COLOR:Black,FONT:bold,CHARSET:ANSI), |
           COLOR(0FEF0BEH),FORMAT('20L(2)|M~Names~@s10@')
       BUTTON('OK'),AT(131,2,,14),USE(?OkButton),LEFT,ICON('wizok.ico'),DEFAULT
       STRING('Education Services'),AT(3,19),TRN
       STRING('Title here'),AT(3,28),USE(?TitleString),TRN
       BUTTON('Cancel'),AT(179,2,,14),USE(?CancelButton),LEFT,ICON('wizcncl.ico')
       STRING('Copyright (c) 2002  - RADFusion Inc.'),AT(3,100,,10),TRN
     END

  CODE
  OPEN(Window)
  TARGET{PROP:Text} = Title
  ?TitleString{PROP:Text} = Title
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      IF Work.FillQue()
        Work.WorkQ.Mystring = 'Greetings!'
        ADD(Work.WorkQ,5)
        ?List1{PROP:From} = Work.WorkQ
        SELECT(?List1,5)
      END
    OF EVENT:Accepted
      CASE FIELD()
      OF ?CancelButton
        POST(EVENT:CloseWindow)
      OF ?OkButton
        Work.WaveName = LONGPATH() & '\chatbeep.wav'
        Work.Play()
      END
    END
  END
  
