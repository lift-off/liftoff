unit configuration;

interface

type

  TConfiguration = class
  private
    FLanguage: string;
    FAutoCheckForUpdates: boolean;
  public
    constructor Create; virtual;

    procedure Load();
    procedure Save();

    property Language: string read FLanguage write FLanguage;
    property AutoCheckForUpdates: boolean read FAutoCheckForUpdates write FAutoCheckForUpdates;
  end;

var

  GlobalConfig: TConfiguration;

implementation

uses SysUtils, registry, windows;

const
  ConfigurationRegistryKey: string = 'Software\liftoff';

{ TConfiguration }

constructor TConfiguration.Create;

var 
  ID: LangID; 
  Language: array [0..100] of char;
begin
  ID := GetSystemDefaultLangID;

  { The following if checks if a german Windows version is used. If true
    the default language of Lift-Off is set to german; otherwise set to
    english. The langauge can be changed at any time in the Lift-Off
    main menu. }
  if ((ID = $0C07) or (ID = $407) or (ID = $1407) or (ID = $1007) or (ID = $807)) then begin
    FLanguage := 'DE';
  end else begin
    FLanguage := 'EN';
  end;

  FAutoCheckForUpdates := true;
end;

procedure TConfiguration.Load;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if (reg.OpenKeyReadOnly(ConfigurationRegistryKey)) then begin

      // Language
      if (reg.ValueExists('language')) then
        FLanguage := reg.ReadString('language');

      // AutoCheckForUpdates
      if (reg.ValueExists('AutoCheckForUpdates')) then
        FAutoCheckForUpdates := reg.ReadBool('AutoCheckForUpdates');

    end;
  finally
    FreeAndNil(reg);
  end;
end;

procedure TConfiguration.Save;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if (reg.OpenKey(ConfigurationRegistryKey, true)) then begin

      // Language
      reg.WriteString('language', FLanguage);

      // AutoCheckForUpdates
      reg.WriteBool('AutoCheckForUpdates', FAutoCheckForUpdates);

    end;
  finally
    FreeAndNil(reg);
  end;
end;

initialization
  GlobalConfig := TConfiguration.Create();
end.

