{-----------------------------------------------------------------------------
 Unit Name: ad_consts
 Author:    marc
 Purpose:   Globale Konstanten und Variabeln
 History:
 -----------------------------------------------------------------------------}

unit ad_consts;

interface
uses
  classes, sysutils, windows;

const

  AppDataSubDir  = 'LiftOff';
  ModellFileExt  = '.mdl';
  ModellSubDir   = 'Models';
  SmpModellSubDir= 'samplemodels';

  KoordFileExt   = '.koo';     // Alte Koordinatenfiles
  PolareFileExt  = '.plr';     // Alte Polarenfiles
  ProfilFileExt  = '.airfoil'; // Neue Profilfiles
  PEFFileExt     = '.pef';     // Polaren-Austausch Dateiformat
  ProfilSubDir   = '\STEPFOUR\airfoils';  // Profilunterverzeichnis
  ProgramName    = 'LiftOff';  // Name des Programs für die Reports etc.

  WebSiteCompany = 'http://www.idev.ch';
  WebSiteProduct = 'http://www.idev.ch/';
  TheLiftoffUpdateURL = 'http://www.idev.ch/sites/default/files/downloads/liftoff/wupdate.ini';

  //ActivateMailAddress = 'activation@idev.ch';

var
  DataPath : string;
  ModellPath : string;
  SmpModellPath : string;
  ProfilPath : string;
  ProgPath : string;
  ProgVersion : string;
  ProgVersionLong : string;
  DaysUntilExpiration: integer;

implementation

uses
  idShellFolder, id_tools;


initialization
  ProgPath := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  DataPath := IncludeTrailingBackslash(GetShellFolder(CSIDL_APPDATA)) + AppDataSubDir;
  ModellPath :=  IncludeTrailingBackslash(DataPath) + ModellSubDir + PathDelim;
  if not DirectoryExists(ModellPath) then begin
    ForceDirectories(ModellPath);
  end;
  SmpModellPath := ProgPath + SmpModellSubDir + PathDelim;
  ProfilPath := GetShellFolder(CSIDL_PROGRAM_FILES_COMMON) + ProfilSubDir + PathDelim;
end.
