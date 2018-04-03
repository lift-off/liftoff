{*************************************************************************}
{ THotSpotImage component                                                 }
{ for Delphi 4.0,5.0,6.0 & C++Builder 4.0,5.0,6.0                         }
{ version 1.0 - rel. March, 2002                                          }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2002                                              }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit HotSpotEditorDE;

interface
{$I TMSDEFS.INC}
uses
  Classes, HotSpotEditor, HotSpotImage, Controls,
{$IFDEF DELPHI6_LVL}
  DesignIntf  , DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


type
  THotSpotImageEditor = class(TDefaultEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): String; override;
    procedure ExecuteVerb(Index: Integer); override;
   {$IFNDEF DELPHI6_LVL}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
   {$ELSE}
    procedure EditProperty(const PropertyEditor: IProperty; var Continue: Boolean); override;
   {$ENDIF}
  end;

  THotSpotEditor = class(TPropertyEditor)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;

    procedure TransferToHotSpotImage;
    procedure TransferFromHotSpotImage;
  end;


implementation
uses
  SysUtils,Dialogs;
{ THotSpotEditor }

//------------------------------------------------------------------------------
procedure THotSpotEditor.Edit;
var frmEditor: TfrmHSIEditor;
    s:string;
begin
  TransferFromHotSpotImage;      
  frmEditor := TfrmHSIEditor.Create(nil);
  s := PrivateDirectory;
  {$WARNINGS OFF}
  s := IncludeTrailingBackslash(s);
  {$WARNINGS ON}
  frmEditor.LoadSettings(s+'hotspotedit.ini');
  try
    if frmEditor.ShowModal = mrOK then
    begin
      TransferToHotSpotImage;
      Modified;
    end;
    frmEditor.SaveSettings(s+'hotspotedit.ini');
  finally
    frmEditor.Free;
  end;
end;

//------------------------------------------------------------------------------
function THotSpotEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

//------------------------------------------------------------------------------
function THotSpotEditor.GetValue: String;
begin
  Result := '(THotSpots)';
end;

{ THotSpotImageEditor }

//------------------------------------------------------------------------------

{$IFDEF DELPHI6_LVL}
procedure THotSpotImageEditor.EditProperty(const PropertyEditor: IProperty; var Continue: Boolean);
{$ELSE}
procedure THotSpotImageEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
{$ENDIF}
begin
  if PropertyEditor.GetName = 'HotSpots' then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end
  else inherited;
end;

//------------------------------------------------------------------------------
procedure THotSpotImageEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

//------------------------------------------------------------------------------
function THotSpotImageEditor.GetVerb(Index: Integer): String;
begin
  Result := 'Edit hotspots...';
end;

//------------------------------------------------------------------------------
function THotSpotImageEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

//------------------------------------------------------------------------------
procedure THotSpotEditor.TransferFromHotSpotImage;
var Comp: THotSpotImage;
begin
  if propCount=0 then exit;
  Comp := THotSpotImage(GetComponent(0));
  if Comp=nil then exit;
  if FHotSpots_org=nil then exit;
  if FPicture=nil then exit;
  if FHotSpots=nil then exit;
  FHotSpots_org.Assign(Comp.HotSpots);
  FPicture.Assign(Comp.Picture);
  if Comp.Stretch then
    FHotSpots_org.ReScale(FPicture.Width,FPicture.Height);
  FHotSpots.Assign(FHotSpots_org);
  HotSpotsChanged:=false;
end;

//------------------------------------------------------------------------------
procedure THotSpotEditor.TransferToHotSpotImage;
var Comp: THotSpotImage;
begin
  Comp := THotSpotImage(GetComponent(0));
  Comp.HotSpots.Assign(FHotSpots);
  if Comp.Stretch then
    Comp.HotSpots.ReScale(Comp.Width,Comp.Height)
  else
    Comp.HotSpots.ReScale(Comp.Picture.Width,Comp.Picture.Height);
  Comp.Picture.Assign(FPicture);
  Comp.RePaint;
end;

end.
