!Copyright 2002 JaDu Technologies
! Grateful acknowledgement to Steve Bottomley for supplying this example.
!
  PROGRAM

  MAP
  END

                    ITEMIZE,PRE(PIE)
Crust                 EQUATE                         !The same as PIE:Crust EQUATE(1).
Filling               EQUATE                         !The same as PIE:Filling EQUATE(2).
                    END

IPieType             INTERFACE                       !Supply the specifics for making any type of pie.
GetType               PROCEDURE,STRING              
GetIngredients        PROCEDURE(BYTE bType),STRING   !One of the above EQUATES is passed as parameter.
GetMethod             PROCEDURE,STRING              
GetSuggestions        PROCEDURE,STRING              
                    END

IngredientQ         QUEUE,TYPE                      
Ingredient            CSTRING(101)                  
                    END                             

PieClass            CLASS,TYPE                      !The pie base class. 
CrustQ                &IngredientQ
FillingQ              &IngredientQ                  
Type                  &IPieType                     !Reference to the interface
Construct             PROCEDURE                     
Destruct              PROCEDURE                     
Init                  PROCEDURE(IPieType PT)         
Make                  PROCEDURE                     
ShowReceipe           PROCEDURE,VIRTUAL             
                    END                             

PieView             CLASS(PieClass)                 
GetViewType           PROCEDURE,BYTE                
ShowReceipe           PROCEDURE,DERIVED
                    END

PrettyPieClass      CLASS(PieClass),TYPE            
Make                  PROCEDURE                     
ShowReceipe           PROCEDURE,DERIVED
                    END

PrettyPie           &PrettyPieClass                 

ApplePieIngredientQ QUEUE,TYPE                      !Another TYPE queue for our pie type classes
Type                  BYTE                          !PIE:Crust or Filling
Ingredient            CSTRING(101)
                    END

ApplePie            CLASS,IMPLEMENTS(IPieType)       
ListCounter           LONG                          
IngredientQ           &ApplePieIngredientQ          
Construct             PROCEDURE                     
Destruct              PROCEDURE                     
                    END

AppleCheeseCake     CLASS,IMPLEMENTS(IPieType)       
ListCounter           LONG                          
IngredientQ           &ApplePieIngredientQ          
Construct             PROCEDURE                     
Destruct              PROCEDURE                     
                    END
                                                    !with a different pie type each time and the PrettyPie class once.

!**** Main Program Code                             !The main program code calls the pie viewer twice
  CODE                                              
  PieView.Init(ApplePie.IPieType)                   !Pass the Apple Pie interface into the PieView object.
  PieView.Make()
  PieView.Init(AppleCheeseCake.IPieType)            !Now let's see how to make an Apple Cheese Cake.
  PieView.Make()
  PrettyPie &= NEW PrettyPieClass                   !Here's where the PrettyPie is instantiated
  PrettyPie.Init(ApplePie.IPieType)                  
  PrettyPie.Make()                                  !Let's try the Pretty Pie viewer
  DISPOSE(PrettyPie)                                !Make sure we dispose a class instantiated using

!**** Pie class method code
PieClass.Construct                     PROCEDURE    
  CODE
  IF SELF.CrustQ &= NULL                            !If CrustQ not instantiated
    SELF.CrustQ &= NEW IngredientQ                  !Allocate memory for it.
!    CLEAR(SELF.CrustQ)                              !Init the Q to known values
  END
  IF SELF.FillingQ &= NULL                          !If FillingQ not instantiated
    SELF.FillingQ &= NEW IngredientQ                !Allocate memory for it.
!    CLEAR(SELF.FillingQ)                            !Init the Q to known values.
  END

PieClass.Destruct                      PROCEDURE    
  CODE                                              
  FREE(SELF.CrustQ)                                 !Empty the queues.
  FREE(SELF.FillingQ)
  DISPOSE(SELF.CrustQ)                              !Clear up memory created using NEW.
  DISPOSE(SELF.FillingQ)

PieClass.Init                          PROCEDURE(IPieType PT)
  CODE
  SELF.Type &= PT                                   !Remember the Interface for later use.
  FREE(SELF.CrustQ)                                 !Empty the queues.
  FREE(SELF.FillingQ)
  LOOP                                              !Get crust ingredients.
    SELF.CrustQ.Ingredient = SELF.Type.GetIngredients(PIE:Crust)
    IF ~SELF.CrustQ.Ingredient
      BREAK
    END
    ADD(SELF.CrustQ)
  END
  LOOP                                              !Get filling ingredients.
    SELF.FillingQ.Ingredient = SELF.Type.GetIngredients(PIE:Filling)
    IF ~SELF.FillingQ.Ingredient
      BREAK
    END
    ADD(SELF.FillingQ)
  END

PieClass.Make                          PROCEDURE    !Call the VIRTUAL ShowReceipe method.
  CODE                                              
  SELF.ShowReceipe()                                
                                                    
PieClass.ShowReceipe                   PROCEDURE    !The base class version of this method doesn't do 
  CODE                                              !anything but because it is VIRTUAL, the Make method
                                                    !(above) will call the ShowReceipe method implemented
                                                    !in whichever class is used for the current running instance.
!*** PieView method code
PieView.GetViewType                    PROCEDURE    !This method is not really needed except
  CODE                                              !to demonstrate polymorphism.
  RETURN(MESSAGE('View type?','Select Viewer',ICON:Question,'&3D|&Flat',1,0))

PieView.ShowReceipe                    PROCEDURE    !This is where it all happens
Method          CSTRING(5001)
Suggestions     CSTRING(5001)
TheWindow       &WINDOW
                            !Two possible windows to use.
ThreeDWindow WINDOW('Caption'),AT(,,360,214),FONT('Tahoma',10,,FONT:bold,CHARSET:ANSI),CENTER,SYSTEM, |
         GRAY,DOUBLE
       BUTTON('Close'),AT(311,0,,12),USE(?Close),LEFT,ICON('wizok.ico')
       PROMPT('Crust:'),AT(2,1),USE(?Prompt3)
       LIST,AT(2,13,103,72),USE(?ListCrust),VSCROLL,FROM(SELF.CrustQ)
       PROMPT('Method:'),AT(107,1),USE(?Prompt1)
       TEXT,AT(107,13,253,111),USE(Method),VSCROLL,READONLY
       PROMPT('Filling:'),AT(2,91),USE(?Prompt4)
       LIST,AT(2,103,103,106),USE(?ListFilling),VSCROLL,FROM(SELF.FillingQ)
       PROMPT('Serving Suggestions:'),AT(107,126,67,9),USE(?Prompt2)
       TEXT,AT(107,138,253,71),USE(Suggestions),VSCROLL,READONLY
     END

FlatWindow WINDOW('Caption'),AT(,,360,229),FONT('Tahoma',10,,FONT:bold),CENTER,SYSTEM
       BUTTON('Close'),AT(315,0,45,12),USE(?Close:2),FLAT,LEFT,ICON('wizok.ico')
       PROMPT('Crust:'),AT(2,1),USE(?Prompt3:2)
       LIST,AT(2,13,103,72),USE(?ListCrust:2),VSCROLL,FROM(SELF.CrustQ)
       PROMPT('Method:'),AT(107,1),USE(?Prompt1:2)
       TEXT,AT(107,13,253,111),USE(Method,,?Method:2),VSCROLL,READONLY
       PROMPT('Filling:'),AT(2,91),USE(?Prompt4:2)
       LIST,AT(2,103,103,122),USE(?ListFilling:2),VSCROLL,FROM(SELF.FillingQ)
       PROMPT('Serving Suggestions:'),AT(107,126,,9),USE(?Prompt2:2)
       TEXT,AT(107,138,253,88),USE(Suggestions,,?Suggestions:2),VSCROLL,READONLY
     END

  CODE
  EXECUTE(SELF.GetViewType())                       !Method returns 1 or 2.
    TheWindow &= ThreeDWindow                       !Reference assign if 1.
    TheWindow &= FlatWindow                         !Reference assign if 2.
  END
  Method = SELF.Type.GetMethod()                    !Get the cooking method information.
  Suggestions = SELF.Type.GetSuggestions()          !Get the serving suggestions.
  OPEN(TheWindow)                                   !Open chosen window
  TheWindow{PROP:Text} = 'Pie Viewer Class: ' & SELF.Type.GetType() !Set the window caption.
  ACCEPT                                            !And away we go.
    CASE FIELD()
    OF ?Close
      CASE EVENT()
      OF EVENT:Accepted
        POST(EVENT:CloseWindow)
      END
    END
  END
  CLOSE(TheWindow)

!*** PrettyPieClass method code
PrettyPieClass.Make                    PROCEDURE    !An alternate pie viewer
  CODE
  IF MESSAGE('Would you like me to call the PARENT Make method and display the receipe?','Pretty Pie Make Method.', |
             ICON:Question,BUTTON:Yes + BUTTON:No,BUTTON:Yes) = BUTTON:Yes
    PARENT.Make()                                   !Even though I over rode the base class method I can
                                                    !can still call it's version of Make using PARENT
  END

PrettyPieClass.ShowReceipe             PROCEDURE    !An alternate pie viewer
Process         BYTE,AUTO                           !State switch for timer
EllipseX        LONG,AUTO                           !Control the elipse position
EllipseY        LONG,AUTO
CentreX         LONG,AUTO                           !The centre of the window
CentreY         LONG,AUTO
PieSize         LONG,AUTO                           !The size of the pie
StringControl   LONG,AUTO                           !FEQ of CREATEed strings

Window WINDOW('Caption'),AT(,,239,224),FONT('Tahoma',8,,FONT:bold),VSCROLL,TIMER(5),SYSTEM,RESIZE
       BUTTON('Suggestions'),AT(193,0,45,14),USE(?ButtonSuggestions),FONT(,,,FONT:bold)
       BUTTON('Method'),AT(0,0,45,14),USE(?ButtonMethod),FONT(,,,FONT:bold)
     END

  CODE
  OPEN(WINDOW)
  WINDOW{PROP:Buffer} = 1
  CentreX = WINDOW{PROP:Width} / 2                  !Find the centre of the window.
  CentreY = WINDOW{PROP:Height} / 2
  EllipseX = CentreX                                !Set the starting position of the pie.
  EllipseY = CentreY
  PieSize = 0
  WINDOW{PROP:Text} = 'Making Crust'                !We'll make the crust first.
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      Process = PIE:Crust                               !Set the state switch to make the PIE:Crust
    OF EVENT:Timer
      CASE Process
      OF PIE:Crust                                      !Grow the PIE:Crust image.
        EllipseX -= 2
        EllipseY -= 2
        IF EllipseX < 0 OR EllipseY < 0             !We've made the PIE:Crust as large as we want
          Process = PIE:Filling                         !Set the state switch to make the filling
          EllipseX = CentreX                        !Re-set out control variables
          EllipseY = CentreY
          PieSize = 0
          WINDOW{PROP:Text} = 'Making Filling'      !Let 'em know what we're doing
          CYCLE
        END
        PieSize += 4
        ELLIPSE(EllipseX,EllipseY,PieSize,PieSize,COLOR:Yellow)
      OF PIE:Filling                                    !Grow the filling image.
        EllipseX -= 2
        EllipseY -= 2
        IF EllipseX < 6 OR EllipseY < 6             !We've made the filling as large as we want
          Process = 3                               !Set the state switch to bulding the ingredient list
        END
        PieSize += 4
        ELLIPSE(EllipseX,EllipseY,PieSize,PieSize,COLOR:Green)
      OF 3
        WINDOW{PROP:Text} = 'Pretty Pie Class: ' & SELF.Type.GetType()     !get the pie type.
        WINDOW{PROP:Width} = WINDOW{PROP:Width} + 15
        StringControl = 15
        CREATE(StringControl,CREATE:String)         !Create the PIE:Crust header.
        StringControl{PROP:Text} = 'CRUST'
        StringControl{PROP:Scroll} = True
        setposition(StringControl,1,StringControl)
        StringControl{PROP:FontColor} = COLOR:Red
        StringControl{PROP:FontStyle} = FONT:Bold
        StringControl{PROP:TRN} = True
        UNHIDE(StringControl)
        Process = 4                                 
      OF 4                                          !Create the PIE:Crust ingredient list.
        StringControl += 10
        CREATE(StringControl,CREATE:String)
        StringControl{PROP:Text} = SELF.Type.GetIngredients(PIE:Crust)
        IF StringControl{PROP:Text} = ''
          DESTROY(StringControl)
          Process = 5
          CYCLE
        END
        StringControl{PROP:Scroll} = True
        SetPosition(StringControl,1,StringControl)
        StringControl{PROP:TRN} = True
        StringControl{PROP:FontColor} = COLOR:Red
        UNHIDE(StringControl)
      OF 5                                          !Create the filling header.
        CREATE(StringControl,CREATE:String)
        StringControl{PROP:Text} = 'FILLING'
        StringControl{PROP:Scroll} = True
        StringControl{PROP:FontColor} = COLOR:Red
        StringControl{PROP:FontStyle} = FONT:Bold
        SetPosition(StringControl,1,StringControl)
        StringControl{PROP:TRN} = True
        UNHIDE(StringControl)
        Process = 6
      OF 6                                          !Create the filling ingredient list
        StringControl += 10
        CREATE(StringControl,CREATE:String)
        StringControl{PROP:Text} = SELF.Type.GetIngredients(PIE:Filling)
        IF StringControl{PROP:Text} = ''
          DESTROY(StringControl)
          Process = 0                               !Nothing more to process
          WINDOW{PROP:Timer} = 0                    !Turn the window timer off
          CYCLE
        END
        StringControl{PROP:Scroll} = True
        SetPosition(StringControl,1,StringControl)
        StringControl{PROP:TRN} = True
        StringControl{PROP:FontColor} = COLOR:Red
        UNHIDE(StringControl)
      END
    OF EVENT:Accepted
      CASE FIELD()                                  !Just a basic message to show the cooking method
      OF ?ButtonMethod
        MESSAGE(SELF.Type.GetMethod(),'Cooking Method...')
      OF ?ButtonSuggestions                         !Just a basic message to show the serving suggestion
        MESSAGE(SELF.Type.GetSuggestions(),'Serving Suggestions...')
      END
    END
  END
  CLOSE(WINDOW)

!*** Apple Pie type class method code
!*** Interface methods
ApplePie.IPieType.GetType               PROCEDURE
  CODE
  RETURN('How to make an Apple Pie')                !What is it we're making.

ApplePie.IPieType.GetIngredients        PROCEDURE(BYTE bType)
  CODE
  IF ~SELF.ListCounter                              !Queue is sorted so locate starting position.
    LOOP SELF.ListCounter = 1 TO RECORDS(SELF.IngredientQ)
      GET(SELF.IngredientQ,SELF.ListCounter)        !Get the ingredient in the queue
      IF SELF.IngredientQ.Type = bType              !Is it the type we are looking for?
        SELF.ListCounter -= 1                       !Yes, decrement the counter
        BREAK                                       !and break out of loop.
      END
    END
  END
  SELF.ListCounter += 1                             !Increment the counter
  IF SELF.ListCounter >  RECORDS(SELF.IngredientQ)  !No more ingredients
    SELF.ListCounter = 0                            !re-set our counter
    RETURN ''                                       !and scram.
  END
  GET(SELF.IngredientQ,SELF.ListCounter)            !Get the ingredient by pointer.
  IF SELF.IngredientQ.Type <> bType                 !Wrong type of ingredient
    SELF.ListCounter = 0                            !re-set our counter
    RETURN ''                                       !and scram.
  END
  RETURN(SELF.IngredientQ.Ingredient)               !Return the proper ingredient.


ApplePie.IPieType.GetMethod             PROCEDURE
  CODE                                              !The preparation and cooking method for an apple pie.
  RETURN('1<9>Preheat oven to 350 degrees F (175 degrees C).<13,10>' & |
         '2<9>To Make Crust: In a large bowl, mix together 1 1/2 cups flour, oil, milk, 1 1/2 teaspoons sugar and salt until evenly blended. Pat mixture into a 9 inch pie pan, spreading the dough evenly over the bottom and up sides. Crimp edges of the dough around the perimeter.<13,10>' & |
         '3<9>To Make Filling: Mix together 3/4 cup sugar, 3 tablespoons flour, cinnamon, and nutmeg. Sprinkle over apples and toss to coat. Spread evenly in unbaked pie shell.<13,10>' & |
         '4<9>To Make Topping: Using a pastry cutter, mix together 1/2 cup flour, 1/2 cup sugar and butter until evenly distributed and crumbly in texture. Sprinkle over apples.<13,10>' & |
         '5<9>Put pie in the oven on a cookie sheet to catch the juices that may spill over. Bake 45 minutes.')

ApplePie.IPieType.GetSuggestions        PROCEDURE
  CODE
  RETURN('On a plate would be a good idea')         !The serving suggestion

!*** Other Apple Pie class methods
ApplePie.Construct                     PROCEDURE    !Magic method called automatically when the class is instantiated.
  CODE                                              !What goes into an apple pie.
  SELF.IngredientQ &= NEW ApplePieIngredientQ       !Allocate memory for the queue.
  SELF.IngredientQ.Ingredient = '1 1/2 cups all-purpose flour'
  SELF.IngredientQ.Type = PIE:Crust
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 cup vegetable oil'
  SELF.IngredientQ.Type = PIE:Crust
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '2 tablespoons cold milk'
  SELF.IngredientQ.Type = PIE:Crust
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1 1/2 teaspoons white sugar'
  SELF.IngredientQ.Type = PIE:Crust
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1 teaspoon salt'
  SELF.IngredientQ.Type = PIE:Crust
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '6 Fuji apples, cored and sliced'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '3/4 cup white sugar'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '3 tablespoons all-purpose flour'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '3/4 teaspoon ground cinnamon'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 teaspoon ground nutmeg'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 cup all-purpose flour'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 cup white sugar'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 cup butter'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SORT(SELF.IngredientQ,+SELF.IngredientQ.Type)

ApplePie.Destruct                      PROCEDURE    !Magic method called automatically when the class is DISPOSEd.
  CODE
  FREE(SELF.IngredientQ)                            !Empty the queue.
  DISPOSE(SELF.IngredientQ)                         !Clear memory allocated by NEW.


!*** Apple Cheesecake
!*** Interface methods
AppleCheeseCake.IPieType.GetType        PROCEDURE
  CODE
  RETURN('How to make an Apple Cheese Cake')        !What is it we're making.

AppleCheeseCake.IPieType.GetIngredients PROCEDURE(BYTE bType)
  CODE
  IF ~SELF.ListCounter                           !Queue is sorted so locate starting position.
    LOOP SELF.ListCounter = 1 TO RECORDS(SELF.IngredientQ)
      GET(SELF.IngredientQ,SELF.ListCounter)
      IF SELF.IngredientQ.Type = bType
        SELF.ListCounter -= 1
        BREAK
      END
    END
  END
  SELF.ListCounter += 1
  IF SELF.ListCounter >  RECORDS(SELF.IngredientQ)  !No more ingredients.
    DO ReturnFalse
  END
  GET(SELF.IngredientQ,SELF.ListCounter)
  IF SELF.IngredientQ.Type <> bType                 !Wrong type of ingredient.
    DO ReturnFalse
  END
  RETURN(SELF.IngredientQ.Ingredient)

ReturnFalse     ROUTINE                             !If we've listed all the ingredients of the specified type
  SELF.ListCounter = 0                              !so re-set our counter
  RETURN('')                                        !and scram.

AppleCheeseCake.IPieType.GetMethod      PROCEDURE
  CODE                                              !The preparation and cooking method for an apple cheese cake.
  RETURN('1<9>Preheat oven to 325 degrees F. In a bowl combine cream cheese, sugar, lemon juice, vanilla, and salt. Mix until well blended. Add eggs, one at a time, mixing after each addition.<13,10>' & |
         '2<9>Place crust on baking sheet; pour in filling. Bake for 25 minutes, or until inserted knife comes out clean.<13,10>' & |
         '3<9>Topping: spread out apple pie filling evenly on top of cooked cheesecake. Garnish with toasted pecans.')

AppleCheeseCake.IPieType.GetSuggestions PROCEDURE
  CODE
  RETURN('Toasted Pecans:<13,10>Spread out pecans evenly on a baking sheet.<13,10>Place into a 375 degrees F oven for 3-5 minutes or until pecans are well toasted.')         !The serving suggestion

!*** Other Apple Cheese Cake class methods
AppleCheeseCake.Construct              PROCEDURE    !Magic method called automatically when the class is instantiated.
  CODE                                              !What goes into an apple cheese cake.
  SELF.IngredientQ &= NEW ApplePieIngredientQ       !Allocate memory for the queue.
  SELF.IngredientQ.Ingredient = '1 (6 ounce) READY CRUST® Graham Cracker Pie Crust'
  SELF.IngredientQ.Type = PIE:Crust
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1 (8 ounce) package cream cheese, softened '
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 cup sugar '
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1 tablespoon lemon juice'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1/2 teaspoon vanilla extract'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1 dash salt'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '2 eggs'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '  TOPPING'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '1 (21 ounce) can apple pie filling, chilled'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  SELF.IngredientQ.Ingredient = '2 tablespoons toasted, chopped pecans'
  SELF.IngredientQ.Type = PIE:Filling
  ADD(SELF.IngredientQ)
  sort(SELF.IngredientQ,+SELF.IngredientQ.Type)

AppleCheeseCake.Destruct               PROCEDURE    !Magic method called automatically when the class is instantiated.
  CODE
  FREE(SELF.IngredientQ)                            !Empty the queue.
  DISPOSE(SELF.IngredientQ)                         !Clear memory allocated by NEW.
