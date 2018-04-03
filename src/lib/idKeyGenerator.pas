{-----------------------------------------------------------------------------
 Unit Name: idKeyGenerator
 Author:    marc
 Purpose:   This unit is used to generate standard iDev product keys
 History:
-----------------------------------------------------------------------------}

unit idKeyGenerator;

interface

{ Generate a key regarding name and emailaddress.
  Key-Format: xxxx-xxxx-xxxx-xxxx }
function GenerateKeyOnNameAndEmail( AName,
                                    AEmail: string;
                                    AProductID: integer ): string;

implementation

uses SysUtils, MaskUtils, id_string;

function GenerateKeyOnNameAndEmail( AName,
                                    AEmail: string;
                                    AProductID: integer ): string;
begin
  result:= FillStr( IntToStr( AProductID ), '0', 4, true ) + '-' +
           FillStr( IntToStr( CalcStrChecksum( AName, false )), '0', 4, true ) + '-' +
           FillStr( IntToStr( CalcStrChecksum( AEmail, false )), '0', 4, true );
  result:= result + '-' + FillStr( IntToStr(CalcStrChecksum( result, false )), '0', 4, true )
end;

end.
