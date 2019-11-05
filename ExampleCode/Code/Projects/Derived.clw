 !(C) 2002 RADFusion Inc.
  MEMBER

  MAP
    INCLUDE('SNDAPI.CLW')
  END

  INCLUDE('OOP5.CLW','OBJECTDEF')

!-----------------------------------------------------------------------------
DerivedClass.FillQue          PROCEDURE ()
!-----------------------------------------------------------------------------
Ndx USHORT,AUTO

  CODE
  FREE(SELF.WorkQ)
  LOOP 100 Times
    CLEAR(SELF.WorkQ.Mystring)
    LOOP Ndx = 1 TO RANDOM(5,10)
      SELF.WorkQ.Mystring[Ndx] = CHR(RANDOM(65,90))
    END
    ADD(SELF.WorkQ,SELF.WorkQ.MyString)
  END
  GET(SELF.WorkQ,1)
  RETURN RECORDS(SELF.WorkQ)

!-----------------------------------------------------------------------------
DerivedClass.Construct       PROCEDURE ()
!-----------------------------------------------------------------------------

  CODE
  SELF.WorkQ &= NEW(TypeQue)
? ASSERT(~SELF.WorkQ &= NULL)

!-----------------------------------------------------------------------------
DerivedClass.Destruct        PROCEDURE ()
!-----------------------------------------------------------------------------

  CODE
  FREE(SELF.WorkQ)
  IF ~SELF.WorkQ &= NULL 
    DISPOSE(SELF.WorkQ)
  END



