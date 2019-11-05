!(C) 2002 RADFusion, Inc.

!ABCIncludeFile (RADFusion)

PlayWave  CLASS(),TYPE,MODULE('PLAYWAVE.CLW'),LINK('PLAYWAVE.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
WaveName    CSTRING (FILE:MaxFileName)             !This is a property (variable)
Play        PROCEDURE (),VIRTUAL                   !These are methods (procedures)
Play        PROCEDURE (STRING xWaveName),VIRTUAL
          END

