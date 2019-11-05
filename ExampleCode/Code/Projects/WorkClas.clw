!(C) 2002 RADFusion Inc.
  MEMBER ()

  MAP
    INCLUDE('SNDAPI.CLW'),ONCE
  END

  INCLUDE('OOP3.CLW','OBJECTDEF')

!This method fills a queue with random characters. When done
!it returns the number of records in the queue.
WorkClass.FillQue         PROCEDURE ()
Ndx USHORT,AUTO

  CODE
  FREE(SELF.WorkQ)                                  !Ensure the Queue is empty
  LOOP 100 TIMES
    CLEAR(SELF.WorkQ.Mystring)
    LOOP Ndx = 1 TO RANDOM(5,15)
      SELF.WorkQ.Mystring[Ndx] = CHR(RANDOM(65,90)) !Notice how the QUEUE is named here
    END
    ADD(SELF.WorkQ)
  END
  SELF.WorkQ.MyString = 'Hello there!'
  ADD(SELF.WorkQ,1)
  GET(SELF.WorkQ,1)
  RETURN RECORDS(SELF.WorkQ)

