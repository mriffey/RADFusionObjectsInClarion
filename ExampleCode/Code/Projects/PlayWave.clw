  !(C) 2002 RADFusion, Inc.
  MEMBER()

  MAP
   INCLUDE('SNDAPI.CLW'),ONCE
  END

  INCLUDE('PLAYWAVE.INC'),ONCE

PlayWave.Play                PROCEDURE ()
! Play a .WAV file.

  CODE
  SndPlaySound(SELF.WaveName,1)
  RETURN

PlayWave.Play                PROCEDURE (STRING xWaveName)
! Play a .WAV file.

  CODE
  SELF.WaveName = xWaveName
  SndPlaySound(SELF.WaveName,1)
  RETURN


