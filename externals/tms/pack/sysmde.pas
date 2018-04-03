{********************************************************************
TSYSMON design time editors
for Delphi 3.0, 4.0, 5.0 & C++Builder 3.0, 4.0
version 1.1

written by TMS Software
           copyright � 1999
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com
{********************************************************************}

unit sysmde;

interface
{$I TMSDEFS.INC}

uses
  SysMon, Classes, Registry, SysUtils, Wintypes,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


type
 TMonObjectProperty = class(TStringProperty)
                         public
                          function GetAttributes:TPropertyAttributes; override;
                          procedure GetValues(Proc:TGetStrProc); override;
                         end;

 TMonCounterProperty = class(TStringProperty)
                         public
                          function GetAttributes:TPropertyAttributes; override;
                          procedure GetValues(Proc:TGetStrProc); override;
                         end;


implementation

const
 subkey:string = 'System\CurrentControlSet\Control\PerfStats\Enum';


function TMonObjectProperty.GetAttributes: TPropertyAttributes;
begin
 result:=[paValueList,paSortList];
end;

procedure TMonObjectProperty.GetValues(Proc: TGetStrProc);
var
 keyhandle:hKey;
 objhandle:hkey;
 index:integer;
 subkeyname:array[0..255] of char;
 {$IFNDEF DELPHI4_LVL}
 dwSize:DWORD;
 {$ELSE}
 dwSize:cardinal;
 {$ENDIF}
begin
 if RegOpenKeyEx(HKEY_LOCAL_MACHINE,pchar(subkey),0,KEY_READ,KeyHandle)= ERROR_SUCCESS then
  begin
   index:=0;
   dwSize:=sizeof(subkeyname);
   while ( RegEnumKeyEx(Keyhandle,Index,subkeyname,dwSize,nil,nil,nil,nil) = ERROR_SUCCESS ) do
    begin
      if ( RegOpenKeyEx(KeyHandle,subkeyname,0,KEY_READ,objhandle)= ERROR_SUCCESS) then
       begin
        proc(strpas(subkeyname));
        RegCloseKey(ObjHandle);
       end;
     dwSize:=sizeof(subkeyname);
     inc(index);
    end;
   RegCloseKey(KeyHandle);
  end;

end;



{ TMonCounterProperty }

function TMonCounterProperty.GetAttributes: TPropertyAttributes;
begin
 result:=[paValueList,paSortList];
end;

procedure TMonCounterProperty.GetValues(Proc: TGetStrProc);
var
 objname:string;
 keyhandle:hKey;
 objhandle:hkey;
 counthandle:hKey;
 index:integer;
 subkeyname:array[0..255] of char;
 {$IFNDEF DELPHI4_LVL}
 dwSize:DWORD;
 {$ELSE}
 dwSize:cardinal;
 {$ENDIF}

begin
 objname:=(GetComponent(0) as TMonObject).SysObject;

 if (objname='') then exit;

 if RegOpenKeyEx(HKEY_LOCAL_MACHINE,pchar(subkey),0,KEY_READ,KeyHandle)= ERROR_SUCCESS then
  begin
   if (RegOpenKeyEx(KeyHandle,pchar(objname),0,KEY_READ,objhandle)= ERROR_SUCCESS) then
     begin
      index:=0;
      dwSize:=sizeof(subkeyname);
      while ( RegEnumKeyEx(Objhandle,Index,subkeyname,dwSize,nil,nil,nil,nil) = ERROR_SUCCESS ) do
       begin
        if (RegOpenKeyEx(objhandle,subkeyname,0,KEY_READ,counthandle)=ERROR_SUCCESS) then
         begin
          proc(strpas(subkeyname));
          RegCloseKey(CountHandle);
         end;
        dwSize:=sizeof(subkeyname);
        inc(index);
       end;
      RegCloseKey(ObjHandle);
    end;
   RegCloseKey(KeyHandle);
  end;

end;


end.
 
