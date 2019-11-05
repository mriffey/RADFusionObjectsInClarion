  MEMBER

  MAP
  END
  
  INCLUDE('CBTree.inc'),ONCE
  
RelationTree.Construct               PROCEDURE
  CODE                                                              !Automatic constructor
  IF SELF.QRT &= NULL                                               !If no reference exists
    SELF.QRT &= NEW QRelTree                                        !Instantiate Data Queue
?   ASSERT(~SELF.QRT &= NULL,'Cannot instantiate QRelTree')         !Assert the reference assignment did take place
  END                                                               ! end IF SELF.QRT &= NULL
  IF SELF.LDQ &= NULL                                               !If no reference exists
    SELF.LDQ &= NEW LoadedQ                                         !Instantiate Loaded Queue
?   ASSERT(~SELF.LDQ &= NULL,'Cannot instantiate LoadedQ')          !Assert the reference assignment did take place
  END                                                               ! end IF SELF.LDQ &= NULL

RelationTree.Destruct                PROCEDURE 
  CODE                                                              !Automatic destructor - undoes constructor
  IF ~SELF.QRT &= NULL                                              !If property is not null
    FREE(SELF.QRT)                                                  !Free queue's resources
    DISPOSE(SELF.QRT)                                               !and dispose of it
  END                                                               ! end IF ~SELF.QRT &= NULL
  IF ~SELF.LDQ &= NULL                                              !If property is not null
    FREE(SELF.LDQ)                                                  !Free queue's resources
    DISPOSE(SELF.LDQ)                                               !and dispose of it
  END                                                               ! end IF ~SELF.LDQ &= NULL
  IF ~SELF.WinRef &= NULL                                           !Reference to window still valid
    SELF.WinRef &= NULL                                             !Remove the reference
  END                                                               ! end IF ~SELF.WinRef &= NULL

RelationTree.InitTree                PROCEDURE(*WINDOW xWin, SIGNED xList, *FILE xFile)
RetVal    LONG,AUTO

  CODE
  RetVal = False                                                    !Set return value
  SELF.WinRef &= xWin                                               !Reference to window
  IF SELF.WinRef &= NULL                                            !If for some reason the reference failed
    RetVal = True                                                   !Set return value
    RETURN RetVal                                                   !and quit this method
  END                                                               ! end NULL test
  SELF.LC = xList                                                   !Store the FEQ
  SELF.BaseFile &= xFile                                            !Set the primary file
  IF SELF.BaseFile &= NULL                                          !If for some reason the reference failed
    RetVal = True                                                   !Set return value
    RETURN RetVal                                                   !and quit this method
  END                                                               ! end NULL test
  SELF.WinRef $ SELF.LC{PROP:From} = SELF.QRT                       !Re-assign QUEUE data source
  SELF.RefreshTree()                                                !and populate it with data
  RETURN RetVal                                                     !Return success (false)

RelationTree.RefreshTree             PROCEDURE()                    !Virtual stub method
  CODE

RelationTree.FormatFile              PROCEDURE(*FILE xFile)         !Virtual stub method
  CODE
 
RelationTree.LoadLevel               PROCEDURE()                    !Virtual stub method
  CODE

RelationTree.UnloadLevel             PROCEDURE()                    !Virtual stub method
  CODE
 
RelationTree.NextParent              PROCEDURE()
  CODE
  IF ~SELF.WinRef{PROP:Active}                                      !If the current window is not active
    SELF.WinRef{PROP:Active} = True                                 !make it so
  END                                                               ! end IF ~SELF.WinRef{PROP:Active}
  GET(SELF.QRT,CHOICE(SELF.LC))                                     !Get queue record by highlighted row pointer
  IF ABS(SELF.QRT.Level) > 1                                        !If a tree child
    SELF.SaveLevel = ABS(SELF.QRT.Level) - 1                        !Set save level property
    SELF.NextSavedLevel()                                           !Call method
  END

RelationTree.PreviousParent          PROCEDURE()
  CODE
  IF ~SELF.WinRef{PROP:Active}                                      !If the current window is not active
    SELF.WinRef{PROP:Active} = True                                 !make it so
  END                                                               ! end IF ~SELF.WinRef{PROP:Active}
  GET(SELF.QRT,CHOICE(SELF.LC))                                     !Get queue record by highlighted row pointer
  IF ABS(SELF.QRT.Level) > 1                                        !If a tree child
    SELF.SaveLevel = ABS(SELF.QRT.Level) - 1                        !Set save level property
    SELF.PreviousSavedLevel()                                       !Call method
  END

RelationTree.NextLevel               PROCEDURE()
  CODE
  IF ~SELF.WinRef{PROP:Active}                                      !If the current window is not active
    SELF.WinRef{PROP:Active} = True                                 !make it so
  END                                                               ! end IF ~SELF.WinRef{PROP:Active}
  GET(SELF.QRT,CHOICE(SELF.LC))                                     !Get queue data by key value
  SELF.SaveLevel = ABS(SELF.QRT.Level)                              !Set level value, despite collapse or expand state
  SELF.NextSavedLevel()                                             !Call method

RelationTree.NextSavedLevel          PROCEDURE()
SavePointer   LONG,AUTO

  CODE
  LOOP                                                              !Outer LOOP
    LOOP                                                            !Inner LOOP - WHILE ABS(SELF.QRT.Level) > SELF.SaveLevel
      GET(SELF.QRT,POINTER(SELF.QRT) + 1)                           !Get queue record by key value
      IF ErrorCode()                                                !If no queue record
        RETURN                                                      !Unable to find another record on similar level, so quit method
      END                                                           ! end IF ErrorCode()
    WHILE ABS(SELF.QRT.Level) > SELF.SaveLevel                      !loop as long as queue level is greater than save level value
    IF ABS(SELF.QRT.Level) = SELF.SaveLevel                         !If retrieve queue record equals save level value
      SELECT(SELF.LC,POINTER(SELF.QRT))                             !Move highlight to that record
      RETURN                                                        !and exit this method
    END                                                             ! end IF ABS(SELF.QRT.Level) = SELF.SaveLevel
    SavePointer = POINTER(SELF.QRT)                                 !Save current value of queue pointer
    SELF.LC{PROPLIST:MouseDownRow} = SavePointer                    !Set row to pointer value
    SELF.LoadLevel()                                                !Call method to load that level
    GET(SELF.QRT,SavePointer)                                       !Get the queue record by pointer in case method call changed it
  END                                                               ! end outer LOOP

RelationTree.PreviousSavedLevel      PROCEDURE()
SaveRecords   LONG,AUTO
SavePointer   LONG,AUTO

  CODE
  LOOP                                                              !Outer LOOP
    LOOP                                                            !Inner LOOP - WHILE ABS(SELF.QRT.Level) > SELF.SaveLevel
      GET(SELF.QRT,POINTER(SELF.QRT) - 1)                           !Get queue record by key value
      IF ERRORCODE()                                                !If no queue record
        RETURN                                                      !Unable to find another record on similar level, so quit method
      END                                                           ! end IF ErrorCode()
    WHILE ABS(SELF.QRT.Level) > SELF.SaveLevel                      !loop as long as queue level is greater than save level value
    IF ABS(SELF.QRT.Level) = SELF.SaveLevel                         !If retrieve queue record equals save level value
      SELECT(SELF.LC,POINTER(SELF.QRT))                             !Move highlight to that record
      RETURN                                                        !and exit this method
    END                                                             ! end IF ABS(SELF.QRT.Level) = SELF.SaveLevel
    SavePointer = POINTER(SELF.QRT)                                 !Save current value of queue pointer
    SaveRecords = RECORDS(SELF.QRT)                                 !Save number of records in queue
    SELF.LC{PROPLIST:MouseDownRow} = SavePointer                    !Set row to pointer value
    SELF.LoadLevel()                                                !Call method to load that level
    IF RECORDS(SELF.QRT) <> SaveRecords                             !If the number of records changed (added or deleted)
      SavePointer += 1 + RECORDS(SELF.QRT) - SaveRecords            !Calculate current pointer
    END                                                             ! end IF RECORDS(SELF.QRT) <> SaveRecords
    GET(SELF.QRT,SavePointer)                                       !Get the queue record by pointer in case method call changed it
  END                                                               ! end outer LOOP

RelationTree.PreviousLevel           PROCEDURE()
  CODE
  IF ~SELF.WinRef{PROP:Active}                                      !If the current window is not active
    SELF.WinRef{PROP:Active} = True                                 !make it so
  END                                                               ! end IF ~SELF.WinRef{PROP:Active}
  GET(SELF.QRT,CHOICE(SELF.LC))                                     !Get queue data by key value
  SELF.SaveLevel = ABS(SELF.QRT.Level)                              !Set level value, despite collapse or expand state
  SELF.PreviousSavedLevel()                                         !Call method

RelationTree.NextRecord              PROCEDURE()
  CODE
  IF ~SELF.WinRef{PROP:Active}                                      !If the current window is not active
    SELF.WinRef{PROP:Active} = True                                 !make it so
  END                                                               ! end IF ~SELF.WinRef{PROP:Active}
  SELF.LoadLevel()                                                  !Call method to load that level
  IF CHOICE(SELF.LC) < RECORDS(SELF.QRT)                            !If current choice is not last item in list
    SELECT(SELF.LC,CHOICE(SELF.LC) + 1)                             !Move pointer down one row
  END                                                               ! end IF CHOICE(SELF.LC) < RECORDS(SELF.QRT)

RelationTree.PreviousRecord          PROCEDURE()
SaveRecords   LONG,AUTO
SavePointer   LONG,AUTO

  CODE
  IF ~SELF.WinRef{PROP:Active}                                      !If the current window is not active
    SELF.WinRef{PROP:Active} = True                                 !make it so
  END                                                               ! end IF ~SELF.WinRef{PROP:Active}
  SavePointer = CHOICE(SELF.LC) - 1                                 !Save predicted previous row
  LOOP                                                              !Loop
    SaveRecords = RECORDS(SELF.QRT)                                 !Save number of records in queue
    SELF.LC{PROPLIST:MouseDownRow} = SavePointer                    !Set highlight to predicted row
    SELF.LoadLevel()                                                !Call method
    IF RECORDS(SELF.QRT) = SaveRecords                              !If number of records changed after method call
      BREAK                                                         !Break out of loop
    END                                                             ! end IF RECORDS(SELF.QRT) = SaveRecords
    SavePointer += RECORDS(SELF.QRT) - SaveRecords                  !Re-calculate pointer value
  END                                                               ! end LOOP
  SELECT(SELF.LC,SavePointer)                                       !Position highlight to current row

RelationTree.AssignButtons           PROCEDURE()                    !Virtual stub method
  CODE
  
RelationTree.AddEntryServer          PROCEDURE()                    !Virtual stub method
  CODE
  
RelationTree.EditEntryServer         PROCEDURE()                    !Virtual stub method
  CODE
  
RelationTree.RemoveEntryServer       PROCEDURE()                    !Virtual stub method
  CODE
  
RelationTree.ContractAll             PROCEDURE()
  CODE
  FREE(SELF.QRT)                                                    !Free queue
  FREE(SELF.LDQ)                                                    !Free queue

RelationTree.ExpandAll               PROCEDURE()
  CODE
  FREE(SELF.QRT)                                                    !Free queue
  FREE(SELF.LDQ)                                                    !Free queue
  SELF.LoadAll = True                                               !Set flag to load all files

RelationTree.AddEntry                PROCEDURE()
  CODE
  SELF.Action = InsertRecord                                        !Set action property to insert mode
  SELF.UpdateLoop()                                                 !Call method to process action

RelationTree.EditEntry               PROCEDURE()
  CODE
  SELF.Action = ChangeRecord                                        !Set action property to change mode
  SELF.UpdateLoop()                                                 !Call method to process action

RelationTree.DeleteEntry             PROCEDURE()
  CODE
  SELF.Action = DeleteRecord                                        !Set action property to delete mode
  SELF.UpdateLoop()                                                 !Call method to process action

RelationTree.UpdateLoop               PROCEDURE()
  CODE
  LOOP
    SELF.VCRRequest = VCR:None                                      !Clear VCR request
    SELF.LC{PROPLIST:MouseDownRow} = CHOICE(SELF.LC)                !Set current highlighted row
    CASE SELF.Action                                                !Process action message
    OF InsertRecord                                                 !If insert
      SELF.AddEntryServer()                                         !Call insert method
    OF DeleteRecord                                                 !If delete
      SELF.RemoveEntryServer()                                      !Call delete method
    OF ChangeRecord                                                 !If change
      SELF.EditEntryServer()                                        !Call edit method
    END                                                             ! end CASE SELF.Action
    CASE SELF.VCRRequest                                            !If a VCR request
    OF VCR:Forward                                                  !If move down one record
      SELF.NextRecord()                                             !Call method to do so
    OF VCR:Backward                                                 !If move up one record
      SELF.PreviousRecord()                                         !Call method to do so
    OF VCR:PageForward                                              !If page down
      SELF.NextLevel()                                              !Call method to do so
    OF VCR:PageBackward                                             !If page up
      SELF.PreviousLevel()                                          !Call method to do so
    OF VCR:First                                                    !If go to top of list
      SELF.PreviousParent()                                         !Call method to do so
    OF VCR:Last                                                     !If go to bottom of list
      SELF.NextParent()                                             !Call method to do so
    OF VCR:Insert                                                   !If inserting new record
      SELF.PreviousParent()                                         !Set previous row and then
      SELF.Action = InsertRecord                                    !Set action request
    OF VCR:None                                                     !If no action requested
      BREAK                                                         !Break out of this loop.
    END                                                             ! end CASE SELF.VCRRequest
  END                                                               ! end LOOP

