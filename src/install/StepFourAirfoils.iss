#define MyAppName "Lift-Off Airfoil Database"
#define MyAppVer "1.0.0"

[_ISTool]
EnableISX=true
Use7zip=false

[Files]
Source: ..\airfoils\*.airfoil; DestDir: {app}

[Setup]
OutputDir=output
OutputBaseFilename=StepFourAirfoilSetup
Compression=zip/9
AppCopyright=© by iDev.ch
AppName={#MyAppName}
AppVerName={#MyAppName} Version {#MyAppVer}
DefaultDirName={cf}\STEPFOUR\airfoils
DisableStartupPrompt=true
AppPublisher=iDev.ch
AppPublisherURL=
AppSupportURL=
AppUpdatesURL=
ShowTasksTreeLines=false
WizardImageFile=InnoSetup\WizModernImage-IS.bmp
WizardSmallImageFile=InnoSetup\WizModernSmallImage-IS.bmp
AppID=StepFourAirfoilDatabase
ChangesAssociations=true
InternalCompressLevel=ultra
VersionInfoVersion=1.0.1
VersionInfoCompany=iDev.ch
VersionInfoDescription=Lift-Off Airfoil Database
VersionInfoCopyright=(c) 2013 by iDev.ch
DisableDirPage=true
DisableProgramGroupPage=true
UsePreviousGroup=false
DisableReadyMemo=true
AlwaysShowComponentsList=false
DisableReadyPage=true
UsePreviousSetupType=false
UsePreviousTasks=false
ShowLanguageDialog=no

[Languages]
Name: default; MessagesFile: compiler:default.isl
Name: german; MessagesFile: compiler:Languages\german.isl
