!(C) 2002 RADFusion, Inc.

   MODULE('MMSYSTEM')

   OMIT('***',_WIDTH32_)
      !This is a windows API procedure that plays a .WAV file.
SndPlaySound PROCEDURE(*CSTRING xSoundName, USHORT xFlags),LONG,PROC,RAW,PASCAL,NAME('SNDPLAYSOUND')
   ***

   COMPILE('***',_WIDTH32_)
      !This is a windows 32-bit API procedure that plays a .WAV file.
SndPlaySound PROCEDURE(*CSTRING xSoundName, UNSIGNED xFlags),UNSIGNED,PROC,RAW,PASCAL,NAME('SNDPLAYSOUNDA')
   ***

   END
