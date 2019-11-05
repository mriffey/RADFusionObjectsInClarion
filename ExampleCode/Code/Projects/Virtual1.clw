  !(C) 2002 RADFusion Inc.
  MEMBER ()

  MAP
  END

  INCLUDE('OOP7.CLW','PLAYWAVE'),ONCE
  INCLUDE('OOP7.CLW','VIRTUAL1'),ONCE

Virtual1.Play                 PROCEDURE ()
  CODE
  PARENT.Play ()
  MESSAGE('Hi, I''m Virtual 1 ','Virtual 1...',ICON:Exclamation)
  RETURN

