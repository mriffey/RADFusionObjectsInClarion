  PROGRAM

  MAP
  END

ApplePie    CLASS
PreparePie      PROCEDURE
CreateCrust      PROCEDURE,VIRTUAL                    !Virtual Methods
MakeFilling      PROCEDURE,VIRTUAL
            END

Dutch      CLASS(ApplePie)
CreateCrust      PROCEDURE,DERIVED                    !Virtual Methods
MakeFilling      PROCEDURE,DERIVED
      END

  CODE                                                !Main body of code
  MESSAGE('Lets make a Dutch Apple Pie!')
  Dutch.PreparePie                                    !Call the Dutch object's Virtuals
  MESSAGE('Now lets make an Applie Pie!')
  ApplePie.PreparePie
                                                      !Code for all methods below
ApplePie.PreparePie    PROCEDURE
  CODE
  MESSAGE('In ApplePie Class - create the crust')
  SELF.CreateCrust                                    !What is SELF?
  MESSAGE('In ApplePie Class - make the filling')
  SELF.MakeFilling                                    ! and why?

ApplePie.CreateCrust  PROCEDURE
  CODE
  MESSAGE('Creating the Apple Pie crust.')

ApplePie.MakeFilling  PROCEDURE
  CODE
  MESSAGE('Making the Apple Pie filling - yum!')

Dutch.CreateCrust  PROCEDURE
  CODE
  MESSAGE('Creating the crust for Dutch Pie.')

Dutch.MakeFilling  PROCEDURE
  CODE
  MESSAGE('Making the Dutch filling - yum!')
