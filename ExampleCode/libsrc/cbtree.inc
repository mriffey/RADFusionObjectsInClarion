!ABCIncludeFile(CB)

  INCLUDE('EQUATES.CLW'),ONCE
  INCLUDE('ABTOOLBA.INC'),ONCE

QRelTree        QUEUE,PRE(),TYPE                        ! Queue for Relation Tree
Display           STRING(200)                           ! Queue display string
NormalFG          LONG                                  ! Normal foreground color
NormalBG          LONG                                  ! Normal background color
SelectedFG        LONG                                  ! Selected foreground color
SelectedBG        LONG                                  ! Selected background color
Icon              SHORT                                 ! Icon image
Level             LONG                                  ! Flag to indicate if this node is expanded (positive) or contracted (negative)
Loaded            SHORT                                 ! File level is loaded in tree or not
Position          STRING(1024)                          ! Record POSITION 
                END

LoadedQ         QUEUE,PRE(),TYPE                        ! Status Queue (is a  file loaded?)
LoadedLevel       LONG                                  ! Record level
LoadedPosition    STRING(1024)                          ! Record POSITION 
                END
      
RelationTree          CLASS,TYPE,MODULE('CBTree.clw'),LINK('CBTree.clw',_CBLinkMode_),DLL(_CBDLLMode_)
SaveLevel               BYTE,AUTO                       ! Current level
BaseLoaded              BYTE,AUTO                       ! Is the base file loaded?
Action                  LONG,AUTO                       ! Edit action
CurrentLevel            LONG                            ! Current loaded level
CurrentChoice           LONG                            ! Current highlighted record
NewItemLevel            LONG                            ! Level for a new record
NewItemPosition         STRING(1024)                    ! POSITION of a new record
LoadAll                 LONG                            ! Flag to load all tree items
QRT                     &QRelTree                       ! Reference to the QRelTree type
LDQ                     &LoadedQ                        ! Reference to the LoadedQ type
LC                      SIGNED,PROTECTED                ! Field equate for list control
BaseFile                &FILE,PROTECTED                 ! Base file in table schematic
WinRef                  &WINDOW,PROTECTED               ! Reference to current window
VCRRequest              LONG(0)                         ! VCR action
InsertButton            SIGNED                          ! FEQ for Insert Button
ChangeButton            SIGNED                          ! FEQ for Change Button
DeleteButton            SIGNED                          ! FEQ for Delete Button
Construct               PROCEDURE()                     ! Automatic method
Destruct                PROCEDURE()                     ! Automatic method
InitTree                PROCEDURE(*WINDOW xWin, SIGNED xList,*FILE xFile),LONG,PROC,VIRTUAL   !MUST be called before any other method 
NextParent              PROCEDURE(),VIRTUAL             ! Navigation methods
PreviousParent          PROCEDURE(),VIRTUAL
NextLevel               PROCEDURE(),VIRTUAL
NextSavedLevel          PROCEDURE(),VIRTUAL
PreviousSavedLevel      PROCEDURE(),VIRTUAL
PreviousLevel           PROCEDURE(),VIRTUAL
NextRecord              PROCEDURE(),VIRTUAL
PreviousRecord          PROCEDURE(),VIRTUAL
AssignButtons           PROCEDURE(),VIRTUAL             ! Stub method
FormatFile              PROCEDURE(*FILE xFile),VIRTUAL  ! Stub method, template driven
LoadLevel               PROCEDURE(),VIRTUAL             ! Stub method
UnloadLevel             PROCEDURE(),VIRTUAL             ! Stub method
AddEntryServer          PROCEDURE(),VIRTUAL             ! Stub method
EditEntryServer         PROCEDURE(),VIRTUAL             ! Stub method
RemoveEntryServer       PROCEDURE(),VIRTUAL             ! Stub method
RefreshTree             PROCEDURE(),VIRTUAL               
ContractAll             PROCEDURE(),VIRTUAL
ExpandAll               PROCEDURE(),VIRTUAL
AddEntry                PROCEDURE(),VIRTUAL             ! Edit methods (if needed)
EditEntry               PROCEDURE(),VIRTUAL
DeleteEntry             PROCEDURE(),VIRTUAL
UpdateLoop              PROCEDURE(),VIRTUAL             ! Combines edit calls with toolbar  and mouse navigation
                      END