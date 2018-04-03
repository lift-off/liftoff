{***************************************************************
 *
 * Unit Name: id_shell
 * Purpose  : Contains some shell wrapper funktion as well as
 *            Shell support functions.
 * Author   : Marc Dürst
 * History  :
 *
 ****************************************************************}

unit id_shell;

interface
uses
  classes, windows;

function GetInstalledMailClients(AList: TStrings): boolean;
function GetMailClientOpenCommand(AMailClient: string) : string;

implementation

uses
  registry;

const
  RegClientsRoot = '\SOFTWARE\Clients';
  RegClientsMail = '\Mail';
  RegClientsOpenCmd = '\shell\open\command';

function GetMailClientOpenCommand(AMailClient: string) : string;
var
  reg : TRegistry;
begin
  result := '';
  reg := TRegistry.Create;
  try
    with reg do begin
      CloseKey;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(RegClientsroot + RegClientsMail +
                         '\' + AMailClient +
                         RegClientsOpenCmd) then
        result := reg.ReadString('');
    end;
  finally
    if assigned(reg) then reg.Free;
  end;
end;

function GetInstalledMailClients(AList: TStrings): boolean;
var
  reg : TRegistry;
begin
  result := true;
  try
    AList.Clear;
    reg := TRegistry.Create;
    try
      with reg do begin
        CloseKey;
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKeyReadOnly(RegClientsroot + RegClientsMail) then
          if HasSubKeys then
            GetKeyNames(AList);
      end;
    finally
      if assigned(reg) then reg.free;
    end;
  except
    result := false;
  end;
end;

end.
