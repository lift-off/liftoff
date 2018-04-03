unit idTranslatorDataProviderINI;

interface

uses
  classes, inifiles, SyncObjs, idTranslatorDataProvider;

type

  { Specialiced translation data provider for use with XML files }
  TidTlINIDataProvider = class(TidTlCustomDataProvider)
  private
    FIniFileName: string;
    FINI: TMemIniFile;
    FMonitor: TCriticalSection;
    FBiDiMode: TBiDiMode;
    procedure SetIniFileName(const Value: string);
    procedure CheckIniFile;
  protected
    procedure SetLanguage(const Value: string); override;
    function GetBiDiMode: TBiDiMode; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetPropTranslation(ALocatorNode: TidTlLocatorNode;
                                APropName: string): string; override;

    { Writer-Methods to generate default datafile }
    function WriteBegin: boolean; override;
    function WriteProperty(ALocatorNode: TidTlLocatorNode; APropName, APropValue: string): boolean; override;
    function WriteEnd: boolean; override;

  published
    property IniFileName: string read FIniFileName write SetIniFileName;
  end;

procedure Register;

implementation

uses
  SysUtils, forms, idTranslator;

procedure Register;
begin
  RegisterComponents('iDev', [TidTlINIDataProvider]);
end;

{ TidTlINIDataProvider }

constructor TidTlINIDataProvider.Create(AOwner: TComponent);
begin
  inherited;
  FMonitor:= TCriticalSection.Create;
end;

destructor TidTlINIDataProvider.Destroy;
begin
  try
    FreeAndNil( FINI );
  finally
    FreeAndNil( FMonitor );
    inherited;
  end;
end;

function TidTlINIDataProvider.GetPropTranslation(
  ALocatorNode: TidTlLocatorNode; APropName: string): string;
begin
  result := '';
  FMonitor.Enter;
  try
    CheckIniFile;
    result:= FINI.ReadString( 'strings', ALocatorNode.AsText+'.'+APropName, '' );
  finally
    FMonitor.Leave;
  end;
end;

procedure TidTlINIDataProvider.SetINIFileName(const Value: string);
begin
  if FINIFileName <> Value then begin
    FINIFileName := Value;
    FMonitor.Enter;
    try
      FreeAndNil( FINI );
    finally
      FMonitor.Leave;
    end;
  end;
end;

procedure TidTlINIDataProvider.SetLanguage(const Value: string);
begin
  FMonitor.Enter;
  try
    FreeAndNil( FIni );
  finally
    FMonitor.Leave;
  end;
  inherited;
end;

function TidTlINIDataProvider.GetBiDiMode: TBiDiMode;
begin
  FMonitor.Enter;
  try
    CheckIniFile;
    result:= FBiDiMode;
  finally
    FMonitor.Leave;
  end;
end;

procedure TidTlINIDataProvider.CheckIniFile;
var
  filePath: string;
  fileName: string;
  fileExt: string;
  fn: string;
  bidiString: string;
begin
  if not assigned( FIni ) then begin
    assert( FiniFileName <> '', 'Property INIFileName not yet set!' );
    filePath:= ExtractFilePath( FIniFileName );
    fileName:= ExtractFileName( FIniFileName );
    fileExt:= ExtractFileExt( FIniFileName );
    fileName:= Copy( fileName, 1, Pos( fileExt, fileName ) - 1);
    fn:= filePath + fileName + Language + fileExt;
    FIni:= TMemIniFile.Create( fn );

    { Get BiDiMode and cache it }
    bidiString:= FINI.ReadString( 'Strings', 'bidirectionalMode', 'LeftToRight' );
    if SameText( bidiString, 'lefttoright' ) then
      FBiDiMode:= bdLeftToRight
    else
    if SameText( bidiString, 'righttoleft' ) then
      FBiDiMode:= bdRightToLeft
    else
    if SameText( bidiString, 'RightToLeftNoAlign' ) then
      FBiDiMode:= bdRightToLeftNoAlign
    else
    if SameText( bidiString, 'RightToLeftReadingOnly' ) then
      FBiDiMode:= bdRightToLeftReadingOnly
    else
      raise Exception.CreateFmt( 'Unknown bidirectional mode definied in translation file: %s !',
                                 [ bidiString ] );

  end;
end;

function TidTlINIDataProvider.WriteBegin: boolean;
begin
  result := true;
end;

function TidTlINIDataProvider.WriteEnd: boolean;
begin
  FINI.UpdateFile;
  result := true;
end;

{$HINTS OFF}
function TidTlINIDataProvider.WriteProperty(ALocatorNode: TidTlLocatorNode;
  APropName, APropValue: string): boolean;
begin
  result := false;
  FMonitor.Enter;
  try
    CheckIniFile;
    FINI.WriteString( 'strings', ALocatorNode.AsText+'.'+APropName, APropValue );
  finally
    FMonitor.Leave;
  end;
  result := true;
end;
{$HINTS ON}

end.
