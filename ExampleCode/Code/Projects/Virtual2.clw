  !(C) 2002 RADFusion Inc.
  MEMBER ()

  MAP
  END

  INCLUDE('OOP7.CLW','PLAYWAVE'),ONCE
  INCLUDE('OOP7.CLW','VIRTUAL2'),ONCE

!--------------------------------------------------------------------
Virtual2.Play                PROCEDURE ()
!--------------------------------------------------------------------
  CODE
  PARENT.Play()
  MESSAGE('Hi, I''m Virtual 2','Virtual 2...',ICON:Exclamation)
  RETURN
