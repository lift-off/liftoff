{***************************************************************************}
{ TvCalendar component                                                      }
{ for Delphi 2.0,3.0,4.0,5.0 & C++Builder 1.0,3.0,4.0,5.0                   }
{ version 1.0 - rel. March 2001                                             }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit vCal;

interface

{$I TMSDEFS.INC}

uses
  Classes, SysUtils;

type
  TvCalendar = class;

  TvEventStatus = (esAccepted,esNeedsAction,esSent,esTentative,
                   esConfirmed,esDeclined,esCompleted,esDelegated);

  TvEventTransp = (etFree,etNotFree,etOther);

  TvEventClass = (ecPublic, ecPrivate, ecConfidential);

  TvEventCategory = (caAppointment,caBusiness,caEducation,caHoliday,
                     caMeeting,caMiscellaneous,caPersonal,caPhonecall,
                     caSickDay,caSpecialOccasion,caTravel,caVacation);

  TEventProperty = (epDTStart,epDTEnd,epStatus,epPriority,epSummary,epTransp,epDescription,
                    epURL,epUID,epLocation,epClass,epCategories,epResources);

  TvEventCategories = set of TvEventCategory;

  TvEvent = class(TCollectionItem)
  private
    FDTEnd: TDateTime;
    FDTStart: TDateTime;
    FPriority: Integer;
    FStatus: TvEventStatus;
    FSummary: string;
    FTrans: TvEventTransp;
    FDescription: TStrings;
    FURL: string;
    FUID: string;
    FLocation: string;
    FClass: TvEventClass;
    FCategories: TvEventCategories;
    FResources: TStrings;
    procedure SetDTEnd(const Value: TDateTime);
    procedure SetDTStart(const Value: TDateTime);
    procedure SetPriority(const Value: Integer);
    procedure SetStatus(const Value: TvEventStatus);
    procedure SetSummary(const Value: string);
    procedure SetTransp(const Value: TvEventTransp);
    procedure SetDescription(const Value: TStrings);
    procedure SetUID(const Value: string);
    procedure SetURL(const Value: string);
    procedure SetLocation(const Value: string);
    procedure SetClass(const Value: TvEventClass);
    procedure SetCategories(const Value: TvEventCategories);
    procedure SetResources(const Value: TStrings);
  protected

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Categories: TvEventCategories read FCategories write SetCategories;
    property Classification: TvEventClass read FClass write SetClass;
    property Description: TStrings read FDescription write SetDescription;
    property DTEnd: TDateTime read FDTEnd write SetDTEnd;
    property DTStart: TDateTime read FDTStart write SetDTStart;
    property Location: string read FLocation write SetLocation;
    property Priority: Integer read FPriority write SetPriority;
    property Resources: TStrings read FResources write SetResources;
    property Status: TvEventStatus read FStatus write SetStatus;
    property Summary: string read FSummary write SetSummary;
    property Transp: TvEventTransp read FTrans write SetTransp;
    property URL: string read FURL write SetURL;
    property UID: string read FUID write SetUID;
  end;


  TvEventCollection = class(TCollection)
  private
    FOwner: TvCalendar;
    function GetvEvent(Index: Integer): TvEvent;
    procedure SetvEvent(Index: Integer; const Value: TvEvent);

  public
    constructor Create(AOwner: TvCalendar);
    function Add:TvEvent;
    function Insert(Index: Integer): TvEvent;
    property Items[Index: Integer]: TvEvent read GetvEvent write SetvEvent; default;
    function GetOwner: TPersistent; override;
  end;


  TvCalendar = class(TComponent)
  private
    FvEvents: TvEventCollection;
    FProdID: string;
    FTimeZone: string;
    function GetvEvents: TvEventCollection;
    procedure SetvEvents(const Value: TvEventCollection);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string);
    procedure InsertFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
  published
    property vEvents: TvEventCollection read GetvEvents write SetvEvents;
    property ProdID: string read FProdID write FProdID;
    property TimeZone: string read FTimeZone write FTimeZone;
  end;

function StatusToStr(AStatus: TvEventStatus):string;





implementation

{ Utility functions }

function IntToZStr(i,l: Integer):string;
var
  Res: string;
begin
  Res := IntToStr(i);
  while Length(Res)<l do
    Res := '0' + Res;

  Result := Res;
end;

function IsoToDateTime(s: string):TDateTime;
var
  da,mo,ye,ho,mi,se: Word;
  err: Integer;
begin
  Val(Copy(s,1,4),ye,err);
  Val(Copy(s,5,2),mo,err);
  Val(Copy(s,7,2),da,err);
  Val(Copy(s,10,2),ho,err);
  Val(Copy(s,12,2),mi,err);
  Val(Copy(s,14,2),se,err);
  Result := EncodeDate(ye,mo,da) + EncodeTime(ho,mi,se,0);
end;

function DateTimeToIso(dt: TDateTime):string;
var
  da,mo,ye,ho,mi,se,ms:word;
begin
  DecodeDate(dt,ye,mo,da);
  DecodeTime(dt,ho,mi,se,ms);
  Result := IntToStr(ye) + IntToZStr(mo,2) + IntToZStr(da,2) + 'T' +
            IntToZStr(ho,2) + IntToZStr(mi,2) + IntToZStr(se,2);
end;

function StatusToStr(AStatus: TvEventStatus):string;
begin
  case AStatus of
  esAccepted: result := 'ACCEPTED';
  esNeedsAction: result := 'NEEDS ACTION';
  esSent: result := 'SENT';
  esTentative: result := 'TENTATIVE';
  esConfirmed: result := 'CONFIRMED';
  esDeclined: result := 'DECLINED';
  esCompleted: result := 'COMPLETED';
  esDelegated: result := 'DELEGATED';
  end;

end;

function StrToStatus(Value: string):TvEventStatus;
begin
  Result := esNeedsAction; //defined default value

  if UpperCase(Value) = 'ACCEPTED' then
    Result := esAccepted;
  if UpperCase(Value) = 'NEEDS ACTIONS' then
    Result := esNeedsAction;
  if UpperCase(Value) = 'SENT' then
    Result := esSent;
  if UpperCase(Value) = 'TENTATIVE' then
    Result := esTentative;
  if UpperCase(Value) = 'CONFIRMED' then
    Result := esConfirmed;
  if UpperCase(Value) = 'DECLINED' then
    Result := esDeclined;
  if UpperCase(Value) = 'COMPLETED' then
    Result := esCompleted;
  if UpperCase(Value) = 'DELEGATED' then
    Result := esDelegated;
end;

function StrToClass(Value: string):TvEventClass;
begin
  Result := ecPublic;
  if Uppercase(Value) = 'PUBLIC' then
    Result := ecPublic;
  if Uppercase(Value) = 'PRIVATE' then
    Result := ecPrivate;
  if Uppercase(Value) = 'CONFIDENTIAL' then
    Result := ecConfidential;
end;

function StrToCat(Value: string):TvEventCategories;
begin
  Result := [];
  Value := Uppercase(Value);

  if Pos('APPOINTMENT',Value) > 0 then
    Result := Result + [caAppointment];

  if Pos('BUSINESS',Value) > 0 then
    Result := Result + [caBusiness];

  if Pos('EDUCATION',Value) > 0 then
    Result := Result + [caEducation];

  if Pos('HOLIDAY',Value) > 0 then
    Result := Result + [caHoliday];

  if Pos('MEETING',Value) > 0 then
    Result := Result + [caMeeting];

  if Pos('MISCELLANEOUS',Value) > 0 then
    Result := Result + [caMiscellaneous];

  if Pos('PERSONAL',Value) > 0 then
    Result := Result + [caPersonal];

  if Pos('PHONE CALL',Value) > 0 then
    Result := Result + [caPhonecall];

  if Pos('SICK DAY',Value) > 0 then
    Result := Result + [caSickDay];

  if Pos('SPECIAL OCCASION',Value) > 0 then
    Result := Result + [caSpecialOccasion];

  if Pos('TRAVEL',Value) > 0 then
    Result := Result + [caTravel];

  if Pos('VACATION',Value) > 0 then
    Result := Result + [caVacation];

end;

function ClassToStr(Value: TvEventClass):string;
begin
  case Value of
  ecPublic: Result := 'PUBLIC';
  ecPrivate: Result := 'PRIVATE';
  ecConfidential: Result := 'CONFIDENTIAL';
  else
    Result := 'PUBLIC';
  end;
end;

function ReplaceString(const srch,repl:string;str:string):string;
var
  i: Integer;
begin
  Result := str;

  repeat
    i := Pos(Uppercase(srch),Uppercase(str));

    if i > 0 then
    begin
      Delete(str,i,Length(srch));
      Result := Copy(str,1,i-1) + repl + Copy(str,i,255);
    end;

    str := Result;

  until (i = 0);

end;

function ConvertFromCRLF(s:string):string;
begin
  s := ReplaceString('=0D',#10,s);
  s := ReplaceString('=0A',#13,s);
  s := ReplaceString('=3D','=',s);  
  Result := s;
end;

function ConvertToCRLF(s:string):string;
begin
  s := ReplaceString('=','=3D',s);
  s := ReplaceString(#10,'=0D',s);
  s := ReplaceString(#13,'=0A',s);

  Result := s;
end;

function DelSpaces(s:string):string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] <> ' ' then Result := Result + s[i];
end;

function GetPropVal(s:string):string;
begin
  Result := '';
  if Pos(':',s) > 0 then
  begin
    Delete(s,1,pos(':',s));
    Result := Trim(s);
  end;
end;

function LastChar(s:string):char;
begin
  Result := #0;
  if Length(s) > 0 then
    Result := s[Length(s)];
end;

function TrimFolding(s:string):string;
begin
  if LastChar(s) = '=' then
    Delete(s,Length(s),1);
  Result := s;
end;


{ TvCalendar }

constructor TvCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FvEvents := TvEventCollection.Create(Self);
end;

destructor TvCalendar.Destroy;
begin
  FvEvents.Free;
  inherited;
end;

function TvCalendar.GetvEvents: TvEventCollection;
begin
  Result := FvEvents;
end;

procedure TvCalendar.LoadFromFile(const FileName: string);
begin
  vEvents.Clear;
  InsertFromFile(FileName);
end;

procedure TvCalendar.InsertFromFile(const FileName: string);
var
  tf: Text;
  s: string;
  vEvent: TvEvent;
  Err, V: Integer;
  LastProp: TEventProperty;
  Folded, FoldingChar: boolean;

begin
  vEvent := Nil;
  FoldingChar := False;
  LastProp := epUID;

  AssignFile(tf, Filename);
  {$i-}
  Reset(tf);
  {$i+}
  if IOResult = 0 then
  while not Eof(tf) do
  begin
    Readln(tf,s);

    Folded := (Pos(' ',s) = 1) or FoldingChar;

    FoldingChar := False;

    s := ConvertFromCRLF(s);

    if Pos('BEGIN:VEVENT',DelSpaces(s)) = 1 then
    begin
      vEvent := vEvents.Add;
    end;

    if Pos('END:VEVENT',DelSpaces(s)) = 1 then
    begin
      vEvent := Nil;
    end;

    if (Pos('DTSTART',s) = 1) and Assigned(vEvent) then
    begin
      vEvent.DTStart := IsoToDateTime(GetPropVal(s));
      LastProp := epDTStart;
    end;

    if (Pos('DTEND',s) = 1) and Assigned(vEvent) then
    begin
      vEvent.DTEnd := IsoToDateTime(GetPropVal(s));
      LastProp := epDTEnd;
    end;

    if (Pos('STATUS',s) = 1) and Assigned(vEvent) then
    begin
      vEvent.Status := StrToStatus(GetPropVal(s));
      LastProp := epStatus;
    end;

    if (Pos('PRIORITY',s) = 1) and Assigned(vEvent) then
    begin
      s := GetPropVal(s);
      val(s, V, Err);
      vEvent.Priority := V;
      LastProp := epPriority;
    end;

    if ((Pos('SUMMARY',s) = 1) or
       (Folded and (LastProp = epSummary))) and Assigned(vEvent) then
    begin
      FoldingChar := LastChar(s) = '=';
      s := TrimFolding(s);

      if Folded then
        vEvent.Summary := vEvent.Summary + ' '+Trim(s)
      else
        vEvent.Summary := GetPropVal(s);

      LastProp := epSummary;
    end;

    if (Pos('TRANSP',s) = 1) and Assigned(vEvent) then
    begin
      s := GetPropVal(s);
      val(s, V, Err);
      case V of
      0: vEvent.Transp := etFree;
      1: vEvent.Transp := etNotFree;
      else
        vEvent.Transp := etOther;
      end;
      LastProp := epTransp;
    end;

    if ((Pos('DESCRIPTION',s) = 1) or
       (Folded and (LastProp = epDescription))) and Assigned(vEvent) then
    begin
      FoldingChar := LastChar(s) = '=';
      s := TrimFolding(s);

      if Folded then
        vEvent.Description.Strings[0] := vEvent.Description.Strings[0] + Trim(s)
      else
        vEvent.Description.Add(GetPropVal(s));

      LastProp := epDescription;
    end;

    if (Pos('URL',s) = 1) and Assigned(vEvent) then
    begin
      vEvent.URL := GetPropVal(s);
      LastProp := epURL;
    end;

    if (Pos('UID',s) = 1) and Assigned(vEvent) then
    begin
      vEvent.UID := GetPropVal(s);
      LastProp := epUID;
    end;

    if (Pos('LOCATION',s) = 1) and Assigned(vEvent) then
    begin
      vEvent.Location := GetPropVal(s);
      LastProp := epLocation;
    end;

    if (Pos('CLASS',s) = 1) and Assigned(vEvent) then
    begin
      s := GetPropVal(s);
      vEvent.Classification := StrToClass(s);
      LastProp := epClass;
    end;

    if (Pos('CATEGORIES',s) = 1) and Assigned(vEvent) then
    begin
      s := GetPropVal(s);
      vEvent.Categories := StrToCat(s);
      LastProp := epCategories;
    end;

    if (Pos('RESOURCES',s) = 1) and Assigned(vEvent) then
    begin
      s := GetPropVal(s);
      while Pos(';',s) > 0 do
      begin
        vEvent.Resources.Add(Copy(s,1,Pos(';',s)-1));
        Delete(s,1,Pos(';',s));
      end;
      if s <> '' then vEvent.Resources.Add(s);
      LastProp := epResources;
    end;

  end;
  CloseFile(tf);
end;

procedure TvCalendar.SaveToFile(const FileName: string);
var
  tf: Text;
  i,j: Integer;
  Cat,Res: string;
begin
  AssignFile(tf, FileName);
  {$i-}
  Rewrite(tf);
  {$i+}
  if IOResult = 0 then
  begin
    writeln(tf,'BEGIN:VCALENDAR');
    if FProdID <> '' then
      writeln(tf,'PRODID:' + FProdID);
    if FTimeZone <> '' then
      writeln(tf,'TZ:' + FTimeZone);
    writeln(tf,'VERSION:1.0');

    for i := 1 to vEvents.Count do
      with vEvents.Items[i - 1] do
      begin
        writeln(tf,'BEGIN:VEVENT');
        writeln(tf,'DTSTART:' + DateTimeToIso(DTStart));
        writeln(tf,'DTEND:' + DateTimeToIso(DTEnd));
        writeln(tf,'PRIORITY:' + IntToStr(Priority));
        writeln(tf,'STATUS:' + StatusToStr(Status));
        writeln(tf,'CLASS:' + ClassToStr(Classification));
        writeln(tf,'SUMMARY:',ConvertToCRLF(Summary));
        writeln(tf,'TRANSP:',Ord(Transp));
        if UID <> '' then
          writeln(tf,'UID:' + UID);
        if URL <> '' then
          writeln(tf,'URL:' + URL);
        if Location <> '' then
          writeln(tf,'LOCATION:' + Location);

        Cat := '';
        if caAppointment in Categories then
          Cat := 'APPOINTMENT';
        if caBusiness in Categories then
          Cat := Cat + ';BUSINESS';
        if caEducation in Categories then
          Cat := Cat + ';EDUCATION';
        if caHoliday in Categories then
          Cat := Cat + ';HOLIDAY';
        if caMeeting in Categories then
          Cat := Cat + ';MEETING';
        if caMiscellaneous in Categories then
          Cat := Cat + ';MISCELLANEOUS';
        if caPersonal in Categories then
          Cat := Cat + ';PERSONAL';
        if caPhonecall in Categories then
          Cat := Cat + ';PHONE CALL';
        if caSickDay in Categories then
          Cat := Cat + ';SICK DAY';
        if caSpecialOccasion in Categories then
          Cat := Cat + ';SPECIAL OCCASION';
        if caTravel in Categories then
          Cat := Cat + ';TRAVEL';
        if caVacation in Categories then
          Cat := Cat + ';VACATION';

        if Pos(';',Cat) = 1 then Delete(Cat,1,1);
        if Cat <> '' then
          writeln(tf,'CATEGORIES:' + Cat);

        if Resources.Count > 0 then
        begin
          Res := '';
          for j := 1 to Resources.Count do
            if Res = '' then
              Res := Resources.Strings[j - 1]
            else
              Res := Res + ';' + Resources.Strings[j - 1];
          writeln(tf,'RESOURCES:'+Res);
        end;

        for j := 1 to Description.Count do
        begin
          Res := '';
          if j = 1 then
            Res := 'DESCRIPTION;ENCODING=QUOTED-PRINTABLE:'+ConvertToCRLF(Description.Strings[j - 1])
          else
            Res := ' '+ConvertToCRLF(Description.Strings[j - 1]);

          if j < Description.Count then
            Res := Res + '=0D=0A=';

          writeln(tf,Res);

        end;

        writeln(tf,'END:VEVENT');
      end;

    writeln(tf,'END:VCALENDAR');
    CloseFile(tf);
  end;

end;

procedure TvCalendar.SetvEvents(const Value: TvEventCollection);
begin
  FvEvents.Assign(Value);
end;

{ TvEventCollection }

function TvEventCollection.Add: TvEvent;
begin
  Result := TvEvent(inherited Add);
end;

constructor TvEventCollection.Create(AOwner: TvCalendar);
begin
  inherited Create(TvEvent);
  FOwner := AOwner;
end;

function TvEventCollection.GetOwner: TPersistent;
begin
  Result := TPersistent(FOwner);
end;

function TvEventCollection.GetvEvent(Index: Integer): TvEvent;
begin
  Result := TvEvent(inherited Items[Index]);
end;

function TvEventCollection.Insert(Index: Integer): TvEvent;
begin
{$IFDEF DELPHI4_LVL}
  Result := TvEvent(inherited Insert(Index));
{$ELSE}
  Result := TvEvent(inherited Add);
{$ENDIF} 
end;

procedure TvEventCollection.SetvEvent(Index: Integer;
  const Value: TvEvent);
begin
  inherited SetItem(Index,Value);
end;

{ TvEvent }

constructor TvEvent.Create(Collection: TCollection);
begin
  inherited;
  FDescription := TStringList.Create;
  FResources := TStringList.Create;
  FStatus := esNeedsAction;
end;

destructor TvEvent.Destroy;
begin
  FResources.Free;
  FDescription.Free;
  inherited;
end;

procedure TvEvent.SetCategories(const Value: TvEventCategories);
begin
  FCategories := Value;
end;

procedure TvEvent.SetClass(const Value: TvEventClass);
begin
  FClass := Value;
end;

procedure TvEvent.SetDescription(const Value: TStrings);
begin
  FDescription.Assign(Value);
end;

procedure TvEvent.SetDTEnd(const Value: TDateTime);
begin
  FDTEnd := Value;
end;

procedure TvEvent.SetDTStart(const Value: TDateTime);
begin
  FDTStart := Value;
end;

procedure TvEvent.SetLocation(const Value: string);
begin
  FLocation := Value;
end;

procedure TvEvent.SetPriority(const Value: Integer);
begin
  FPriority := Value;
end;

procedure TvEvent.SetResources(const Value: TStrings);
begin
  FResources.Assign(Value);
end;

procedure TvEvent.SetStatus(const Value: TvEventStatus);
begin
  FStatus := Value;
end;

procedure TvEvent.SetSummary(const Value: string);
begin
  FSummary := Value;
end;

procedure TvEvent.SetTransp(const Value: TvEventTransp);
begin
  FTrans := Value;
end;

procedure TvEvent.SetUID(const Value: string);
begin
  FUID := Value;
end;

procedure TvEvent.SetURL(const Value: string);
begin
  FURL := Value;
end;

end.
