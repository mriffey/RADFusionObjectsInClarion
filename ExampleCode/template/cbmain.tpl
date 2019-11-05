#TEMPLATE(CBook,'Clarion Book Template'),FAMILY('ABC')                  #!The "root" template
#SYSTEM                                                                 #!Put this dialog on Setup / Application options dialog
#TAB('Clarion Book')
  #BOXED('About this template'),AT(5)
    #DISPLAY('')
    #DISPLAY('This is the template from the Clarion Book.  The primary goal of')
    #DISPLAY('this template is simply to show how to code class wrappers.')
    #DISPLAY('')
    #DISPLAY('Suggested use for templates like this one is so that one ')
    #DISPLAY('can "hang" other templates.  This ensures that future releases ')
    #DISPLAY('of other templates do not step on any custom templates you may use.')
    #DISPLAY('')
    #DISPLAY('This template is the wrapper for the Relation Tree object.  The')
    #DISPLAY('Clarion and ABC templates does not use classes for these controls.')
    #DISPLAY('Thus, this template provides the same functionality as those')
    #DISPLAY('templates, but from a class.')
    #DISPLAY('')
  #ENDBOXED
  #PROMPT('Default column number for template generated comments: ',SPIN(@N2,50,99)),%ColumnPos,DEFAULT(75),AT(205,,25)
#ENDTAB
#!The following comment is for Clarion 6, new attribute for #DISPLAY (and #PROMPT)
#!#DISPLAY('This is the template from the Clarion Book.  The primary goal of'),PROP(PROP:FontName,'Verdana'),PROP(PROP:FontColor,000FFFFH),PROP(PROP:FontStyle,07FFH),PROP(PROP:Color,0FF0000H)
#! End of root template
#!-------------------------------------------------------------------------
#EXTENSION(GlobalTree,'Global extension for DLL/LIB use only'),APPLICATION
#PREPARE                                                                        #!Set class name in case developers never edits the name
  #CALL(%ReadABCFiles(ABC))                                                     #!Read ABC class headers if needed
  #CALL(%SetClassDefaults(ABC),'RTree' & %ActiveTemplateInstance,'RTree' & %ActiveTemplateInstance,'RelationTree')  #!Set local name from libsrc class name
#ENDPREPARE                                                                     #! end #PREPARE
#ATSTART                                                                        #!Execute this code before #CODE template generates its code
  #CALL(%ReadABCFiles(ABC))                                                     #!Read ABC class headers if needed
  #CALL(%SetClassDefaults(ABC),'RTree' & %ActiveTemplateInstance,'RTree' & %ActiveTemplateInstance,'RelationTree')   #!Set local name from libsrc class name
#ENDAT                                                                          #! end #ATSTART
#INSERT(%OOPPrompts(ABC))
#!-------------------------------------------------------------------------
#TAB('Global &Objects')                                                         #!Global object dialog
  #BUTTON('&Relation Tree Class'),AT(,,170)                                     #!Display a button
    #WITH(%ClassItem,'RTree' & %ActiveTemplateInstance)                         #!Show the local relation tree instance name
      #INSERT(%GlobalClassPrompts(ABC))                                         #!Add the class prompt dialog.
    #ENDWITH                                                                    #! end #WITH(%ClassItem,'RTree')
  #ENDBUTTON                                                                    #! end #BUTTON('&Relation Tree')
#ENDTAB                                                                         #! end #TAB('Local &Objects')
#!-------------------------------------------------------------------------
#TAB('C&lasses')                                                                #!Global class dialog
  #PROMPT('&Tree default class:',FROM(%pClassName)),%ClassName,DEFAULT('RelationTree'),REQ
  #DISPLAY()
  #BOXED(' Usage ')
    #DISPLAY()
    #DISPLAY('If you have another class you wish to use instead, ')
    #DISPLAY('select it from the list or use the default shown.')
    #DISPLAY()
    #DISPLAY('This extension is for use in a global or root DLL/LIB ')
    #DISPLAY('ONLY.  Its sole purpose is to ensure the underlying')
    #DISPLAY('class is exported.  Do NOT add this global')
    #DISPLAY('extension twice!  Once added to one project/application')
    #DISPLAY('there is nothing else you need to do.')
    #DISPLAY()
  #ENDBOXED
#ENDTAB                                                                         #! end #TAB('C&lasses')
#!-------------------------------------------------------------------------
#AT(%BeforeGenerateApplication)                                                 #!For exporting the class
  #CALL(%AddCategory(ABC),'CB')                                                 #!The parameter in the !ABCIncludeFile comment in the INC file
  #CALL(%SetCategoryLocation(ABC),'CB','CB')                                    #!Used for DLLMode_ and LinkMode_ pragmas (see defines tab in project editor)
#ENDAT                                                                          #! end #AT(%BeforeGenerateApplication)
#!-------------------------------------------------------------------------
#INCLUDE('CBGroups.tpw')                                                #!Include group definitions
#INCLUDE('CBCtrl.tpw')                                                  #!Include control templates
