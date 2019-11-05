!(C) 2002 RADFusion Inc.
  MEMBER ()

  MAP
    INCLUDE('SNDAPI.CLW')
  END

  INCLUDE('OOP4.CLW','OBJECTDEF')                                   !Include only the class definition

ConstructClass.FillQue   PROCEDURE ()
Ndx   USHORT,AUTO

  CODE
  FREE(SELF.WorkQ)                                                  !Ensure Queue is freed
  LOOP 100 TIMES                                                    !Write 100 entries
    CLEAR(SELF.WorkQ.Mystring)                                      !Clear the queue field
    LOOP Ndx = 1 TO RANDOM(5,15)                                    !Generate a randon character
       SELF.WorkQ.Mystring[Ndx] = CHR(RANDOM(65,90))                ! in each character position
    END
    ADD(SELF.WorkQ,SELF.WorkQ.MyString)                             !Add the sorted entry to the queue
  END
  SELF.WorkQ.Mystring = ' Peekaboo!'                                !Add one more entry
  ADD(SELF.WorkQ,SELF.WorkQ.Mystring)                               ! in sort order
  RETURN(RECORDS(SELF.WorkQ))                                       !Return the number of records in the queue

ConstructClass.Construct   PROCEDURE ()
  CODE
  SELF.WorkQ &= NEW(TypeQue)                                        !Instantiate the queue
? ASSERT(~SELF.WorkQ &= NULL)                                       !Assert that it is not null
  SELF.Noise &= NEW(PlayWave)                                       !Instantiate the Playwave object
? ASSERT (~SELF.Noise &= NULL)                                      !Asser that it is not null

ConstructClass.Destruct      PROCEDURE ()
  CODE
  FREE(SELF.WorkQ)                                                  !Free the queue
  IF ~SELF.WorkQ &= NULL                                            !If the queue is not null
     DISPOSE(SELF.WorkQ)                                            !destroy the queue
  END
  IF ~SELF.Noise &= NULL                                            !If the Noise object is not null
     DISPOSE(SELF.Noise)                                            !destroy the Noise object
  END











