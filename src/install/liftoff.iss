#define MyAppName "Lift-Off"
#define MyAppVer GetFileVersion("..\bin\liftoff.exe")

[_ISTool]
EnableISX=true
Use7zip=false

[Files]
Source: ..\bin\liftoff.exe; DestDir: {app}; Components: core; Flags: overwritereadonly ignoreversion
Source: Tools\profconv.exe; DestDir: {app}; Components: core
Source: ..\translations\*.lng; DestDir: {app}; Components: core; Flags: overwritereadonly ignoreversion
Source: history.htm; DestDir: {app}; Flags: ignoreversion
Source: ..\samplemodels\*.mdl; DestDir: {app}\samplemodels\; Attribs: readonly; Flags: overwritereadonly ignoreversion replacesameversion
Source: output\StepFourAirfoilSetup.exe; DestDir: {tmp}; Flags: deleteafterinstall overwritereadonly replacesameversion; Tasks: 
Source: {app}\Modelle\*.*; DestDir: {userappdata}\LiftOff\models\; Flags: uninsneveruninstall external skipifsourcedoesntexist onlyifdoesntexist; Components: ; Languages: 
Source: ..\..\doc\LiftOffManual.pdf; DestDir: {app}
Source: ..\..\doc\LiftOffManualEN.pdf; DestDir: {app}

[Components]
Name: core; Description: {cm:ComponentCore}; Flags: fixed; Types: custom compact full
Name: airfoils; Description: {cm:ComponentAirfoilDatabase}; Types: custom full
Name: modelle; Description: {cm:ComponentSamples}; Types: custom full

[Setup]
OutputDir=.\output
OutputBaseFilename=liftoffsetup
Compression=zip/9
AppCopyright=© by iDev.ch
AppName={#MyAppName}
AppVerName={#MyAppName} Version {#MyAppVer}
DefaultGroupName=Liftoff
DefaultDirName={pf}\Liftoff
DisableStartupPrompt=true
AppPublisher=iDev.ch
AppPublisherURL=http://www.idev.ch/
AppSupportURL=https://github.com/mduu/liftoff/issues
AppUpdatesURL=http://www.idev.ch
ShowTasksTreeLines=false
WizardImageFile=..\images\wizard.bmp
WizardSmallImageFile=..\images\wizard_small.bmp
AppID=liftoff1
ChangesAssociations=true
ShowLanguageDialog=auto

[Dirs]
Name: {app}\samplemodels; Flags: uninsalwaysuninstall

[Run]
Filename: {app}\history.htm; Description: {cm:ShowChangelog}; Flags: nowait shellexec postinstall skipifsilent
Filename: {app}\liftoff.exe; WorkingDir: {app}; Description: {cm:StartLiftOff}; Flags: nowait postinstall
Filename: {tmp}\StepFourAirfoilSetup.exe; Parameters: /SILENT; WorkingDir: {tmp}; StatusMsg: {cm:InstallAirfoilDBStatus}; Flags: skipifdoesntexist; Components: airfoils
Filename: {app}\LiftOffManual.pdf; Description: {cm:ReadManual}; Flags: shellexec postinstall unchecked skipifsilent
Filename: {app}\LiftOffManualEN.pdf; Description: {cm:ReadManualEN}; Flags: shellexec postinstall unchecked skipifsilent

[Icons]
Name: {group}\Liftoff; Filename: {app}\liftoff.exe; WorkingDir: {app}; IconIndex: 0
Name: {group}\{cm:IconCaptionChangeLog}; Filename: {app}\history.htm; Comment: {cm:HintShowChangelog}
Name: {group}\{cm:IconCaptionManual}; Filename: {app}\LiftOffManual.pdf
Name: {group}\{cm:IconCaptionManualEN}; Filename: {app}\LiftOffManualEN.pdf

[Registry]
Root: HKLM; Subkey: Software\iDev\liftoff\; ValueType: string; ValueName: path; ValueData: {app}\; Flags: uninsdeletevalue; Components: core
Root: HKCR; Subkey: .mdl; ValueType: string; ValueName: ; ValueData: liftoff; Flags: uninsdeletevalue
Root: HKCR; Subkey: liftoff; ValueType: string; ValueName: ; ValueData: liftoff; Flags: uninsdeletekey
Root: HKCR; Subkey: liftoff\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\LIFTOFF.EXE,0
Root: HKCR; Subkey: liftoff\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\LIFTOFF.EXE"" ""%1"""
Root: HKCU; Subkey: Software\liftoff; ValueType: string; ValueName: stepfourupgradenotice; ValueData: 1; Flags: createvalueifdoesntexist

[InstallDelete]
Name: {app}\dbrtl60.bpl; Type: files
Name: {app}\vcl60.bpl; Type: files
Name: {app}\vclx60.bpl; Type: files
Name: {app}\vclshlctrls60.bpl; Type: files
Name: {app}\rtl60.bpl; Type: files
Name: {app}\dxExELD6.bpl; Type: files
Name: {app}\dxsbD6.bpl; Type: files
Name: {app}\dxBarD6.bpl; Type: files
Name: {app}\dxBarExtItemsD6.bpl; Type: files
Name: {app}\dxComnD6.bpl; Type: files
Name: {app}\dxEdtrD6.bpl; Type: files
Name: {app}\dxELibD6.bpl; Type: files
Name: {app}\EQTLD6.bpl; Type: files
Name: {app}\MATRIX32.DLL; Type: files
Name: {app}\crypt.dll; Type: files

[Languages]
Name: default; MessagesFile: compiler:default.isl
Name: de; MessagesFile: compiler:Languages\german.isl

[CustomMessages]
ComponentCore=Main Application
ComponentAirfoilDatabase=Airfoil database
ComponentSamples=Sample models
ShowChangelog=Show change log (German)
StartLiftOff=Start Lift-Off
InstallAirfoilDBStatus=Airfoil database get installed/updated ...
ReadManual=Read Manual (German)
ReadManualEN=Read Manual (English)
IconCaptionChangeLog=Changes and new features (German)
HintShowChangelog=Shows the history/changelog of Lift-Off (German).
IconCaptionManual=User Manual (German)
IconCaptionManual=User Manual (English)
StepFourUpgradeNotice=This update requires to buy a new licence (upgrade pricing). Read more about it at http://idev.ch/liftoff/upgrade. Are you sure you want to upgrade?

de.ComponentCore=Hauptprogramme
de.ComponentAirfoilDatabase=Profilesammlung
de.ComponentSamples=Beispielmodelle
de.ShowChangelog=Programmänderungen und -neuerungen anzeigen
de.StartLiftOff=Lift-Off starten
de.InstallAirfoilDBStatus=Profildatenbank wird installiert / aktualisiert ...
de.ReadManual=Deutsche Bedienungsanleitung lesen
de.ReadManualEN=Englische Bedienungsanleitung lesen
de.IconCaptionChangeLog=Änderungen und Neuerungen
de.HintShowChangelog=Zeigt die Programmänderungen / -history an.
de.IconCaptionManual=Bedienungsanleitung (englisch)
de.IconCaptionManualEN=Bedienungsanleitung (deutsch)
de.StepFourUpgradeNotice=Dieser Update benötigt eine neue, kostenpflichtige Lizenz (zu Spezialkonditionen). Lesen Sie mehr darüber unter http://idev.ch/liftoff/upgrade. Sind Sie sicher, dass Sie upgraden wollen?

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  oldModelDir: string;
begin
  if (CurStep = ssPostInstall) then begin

    // Delete the old directory ProgramFiles\LiftOff\Modelle\
    // The content of that directory is copied by the regular
    // setup as 'external' files.
    oldModelDir := ExpandConstant('{app}\Modelle');
    if (DirExists(oldModelDir)) then begin
      DelTree(oldModelDir, true, true, true);
    end;

  end;
end;
