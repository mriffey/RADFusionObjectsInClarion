  !(C) 2002 RADFusion Inc.
  MEMBER ()

 MAP
  INCLUDE('SNDAPI.CLW'),ONCE
 END

 INCLUDE('OOP6.CLW','OBJECTDEF'),ONCE

OverrideClass.Init           PROCEDURE ()
  CODE
  SELF.WinRef{PROP:Timer} = SELF.FlashSpeed

OverrideClass.Play           PROCEDURE ()
  CODE
  SYSTEM{PROP:Font,1} = 'Verdana'
  SYSTEM{PROP:Font,2} = 8
  SYSTEM{PROP:Font,4} = FONT:Bold
  MESSAGE('Before parent call: |I am the "PLAY" method in override class!','Hello...',ICON:Exclamation)
  PARENT.Play()        !Call the play method in PlayWave (the PARENT) class
  SYSTEM{PROP:Font,4} = FONT:Italic
  SYSTEM{PROP:Font,2} = 10
  MESSAGE('After parent call: |I am the "PLAY" method in override class!','Hello...',ICON:Exclamation)
  RETURN

OverrideClass.Flash          PROCEDURE ()
  CODE
  SELF.Toggle = 1 - SELF.Toggle
  EXECUTE SELF.Toggle + 1
    UNHIDE(SELF.Control,SELF.Control + 1)
    HIDE(SELF.Control,SELF.Control + 1)
  END


  





