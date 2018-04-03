{-----------------------------------------------------------------------------
 Unit Name: ad_utils
 Author:    marc
 Purpose:   Aerodesign Utilities and Helper Functions
 History:
-----------------------------------------------------------------------------}


unit ad_utils;

interface

uses
  classes, windows, sysutils, forms, controls, StdCtrls;

function ADStrToCurr(AStr: string; ADefCurr : currency = 0): currency;
function ADCurrToStr(ACurr: currency): string;

function UICurrToStr(ACurr: currency): string;
function UIStringToCurrDef(AString: string; ADefault: currency): currency;

function FilterLine(S: string) : string;

{ Validations }
procedure ValidateError( AMessage: string; AControl: TWinControl );
function ValidateInt( AName: string; AEdit: TEdit; AMin: integer = -1; AMax: integer = -1 ): boolean;
function ValidateCurr( AName: string; AEdit: TEdit; AMin: currency = -1; AMax: currency = -1 ): boolean;

{ Temp-File handling }

function GetTempBitmapPath() : string;

implementation

uses id_string, maindata;

type
  TCharSet = set of char;

const
   StdDecChar : char = '.';
   DecChars : TCharset = ['.', ','];
   NumChars : TCharset = ['-', '+', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

function ADCurrToStr(ACurr: currency): string;
var
  l, i : integer;
begin
  result := '';
  result := CurrToStr(ACurr);
  l := Length(result);
  if l > 0 then
    for i := 1 to l do
      if result[i] in DecChars then
        result[i] := StdDecChar;
end;

function ADStrToCurr(AStr: string; ADefCurr : currency = 0): currency;
var
  PreDec,
  PostDec : string;
  IsPostDec : boolean;
  l,i : integer;
begin
  IsPostDec := false;
  PreDec := '';
  PostDec := '';
  result := ADefCurr;

  l := Length(AStr);
  if l > 0 then begin
    if AStr[1] in DecChars then begin
      PreDec := '0';
      IsPostDec := true;
    end;

    for i := 1 to l do begin
      if AStr[i] in DecChars then
        IsPostDec := true
      else
      if AStr[i] in NumChars then
        if IsPostDec then
          PostDec := PostDec + AStr[i]
        else
          PreDec := PreDec + AStr[i];
    end;

    result := StrToCurr(PreDec + DecimalSeparator + PostDec);
  end;

end;

{ Konvertiert einen Currency für die Bildschirmausgabe in einen String }
function UICurrToStr(ACurr: currency): string;
begin
  result := CurrToStr(ACurr);
end;

{ Konvertiert einen String aus dem UI in einen Currency }
function UIStringToCurrDef(AString: string; ADefault: currency): currency;
begin
  result := StrToCurrDef(AString, ADefault);
end;

{ Funktion ersetzt alle TAB's durch Spaces und fasst mehrere Spaces
  hintereinander zu einem Space zusammen. }
function FilterLine(S: string) : string;
var
  iCh,
  len : integer;
begin
  result := '';
  s := Trim(s);
  len := Length(s);
  if len > 0 then
    for iCh := 1 to len do begin
      if s[iCh] = #9 then s[iCh] := #32;
      if  (iCh > 1)
      and (s[iCh] = #32)
      and (s[iCh - 1] = #32) then
        { Ignore this case }
      else
        result := result + s[iCh];
    end;
end;


{ Validation's }

procedure ValidateError( AMessage: string; AControl: TWinControl );
begin
  //if assigned( AControl ) then AControl.SetFocus;
  Application.MessageBox(
    PAnsiChar(AMessage),
    PAnsiChar(dmMain.Translator.GetLit('ValidationErrorCaption')),
    mb_IconStop + mb_Ok );
end;

function CalcValidationMsg( AEditText, AFieldName: string; AMin, AMax: currency ): string;
var
  s: string;
begin

  AFieldName:= Trim( AFieldName );
  if AFieldName[ Length( AFieldName ) ] = ':' then Delete( AFieldName, Length( AFieldName), 1 );

  s:= '';
  if (AMin <> -1) and (AMax <> -1) then s:= Format( dmMain.Translator.GetLit('ValidationErrorRangeMessage'), [ AMin, AMax ] )
  else
  if (AMin <> -1) then s:= Format( dmMain.Translator.GetLit('ValidationErrorGreaterMessage'), [AMin] )
  else
  if (AMax <> -1) then s:= Format( dmMain.Translator.GetLit('ValidationErrorLessMessage'), [AMax] );

  if s <> '' then begin
    s:= Format( dmMain.Translator.GetLit('ValidationErrorInvalidMessage'),
                [ AEditText, AFieldName, s ] )
  end else begin
    s:= Format( dmMain.Translator.GetLit('ValidationErrorInvalidEmptyMessage'),
                [ AEditText, AFieldName ] )
  end;

  result:= s;

end;

function ValidateInt( AName: string; AEdit: TEdit; AMin: integer = -1; AMax: integer = -1 ): boolean;
var
  i: integer;
  s: string;
begin
  result:= true;
  i:= StrToIntDef( AEdit.Text, -99999 );

  s:= CalcValidationMsg( AEdit.Text, AName, AMin, AMax );

  if i = -99999 then begin
    result:= false;
    ValidateError( s, AEdit );
  end else
  if (AMin <> -1) and (i < AMin) then begin
    result:= false;
    ValidateError( s, AEdit );
  end else
  if (AMax <> -1) and (i > AMax) then begin
    result:= false;
    ValidateError( s, AEdit );
  end;

end;

function ValidateCurr( AName: string; AEdit: TEdit; AMin: currency = -1; AMax: currency = -1 ): boolean;
var
  i: currency;
  s: string;
  fieldName: string;
  currencyFormat: string;
begin

  result:= true;
  i:= StrToCurrDef( AEdit.Text, -1 );

  fieldName:= Trim( AName );
  if fieldName[ Length( fieldName ) ] = ':' then Delete( fieldName, Length( fieldName), 1 );

  s:= '';
  if (AMin <> -1) and (AMax <> -1) then s:= Format( dmMain.Translator.GetLit('ValidationErrorRangeMessage'), [ AMin, AMax ] )
  else
  if (AMin <> -1) then s:= Format( dmMain.Translator.GetLit('ValidationErrorGreaterMessage'), [AMin] )
  else
  if (AMax <> -1) then s:= Format( dmMain.Translator.GetLit('ValidationErrorLessMessage'), [AMax] );

  if s <> '' then begin
    s:= Format( dmMain.Translator.GetLit('ValidationErrorInvalidMessage'),
                [ AEdit.Text, fieldName, s ] )
  end else begin
    s:= Format( dmMain.Translator.GetLit('ValidationErrorInvalidEmptyMessage'),
                [ AEdit.Text, fieldName ] )
  end;

  if i = -1 then begin
    result:= false;
    currencyFormat := '9' + DecimalSeparator + '9';
    ValidateError(
      Format(dmMain.Translator.GetLit('ValidationErrorInvalidNumberMessage'), [currencyFormat]),
      AEdit );
  end else
  if (AMin <> -1) and (i < AMin) then begin
    result:= false;
    ValidateError( s, AEdit );
  end else
  if (AMax <> -1) and (i > AMax) then begin
    result:= false;
    ValidateError( s, AEdit );
  end;

end;

function GetTempBitmapPath() : string;
const
  PATH_MAX_LENGTH: integer = 3000;
var
  buffer: array[0..3000] of Char;
begin
  GetTempPath(PATH_MAX_LENGTH, buffer);
  Result := AddBackslash(StrPas(buffer)) + 'temp.bmp';
end;

end.
