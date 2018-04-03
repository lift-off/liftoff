{*********************************************************************}
{ TAdvDirectoryEdit                                                   }
{ for Delphi & C++Builder                                             }
{ version 1.0                                                         }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright © 2002                                                   }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{                                                                     }
{ The source code is given as is. The author is not responsible       }
{ for any possible damage done due to the use of this code.           }
{ The component can be freely used in any application. The source     }
{ code remains property of the author and may not be distributed      }
{ freely as such.                                                     }
{*********************************************************************}

unit AdvDirectoryEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvEdBtn, AdvEdit;

{$I TMSDEFS.INC}  

type
  TAdvDirectoryEdit = class(TAdvEditBtn)
  private
    { Private declarations }
    FDummy: Byte;
    FOnClickBtn:TNotifyEvent;
    FOnValueValidate: TValueValidateEvent;
    FBrowseDialogText: string;
    FAllowNewFolder: Boolean;
  protected
    { Protected declarations }
    procedure BtnClick (Sender: TObject); override;
    procedure ValueValidate(Sender: TObject; Value: String; Var IsValid: Boolean); Virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function IsValidDirectory: Boolean;
  published
    property AutoThousandSeparator: Byte read FDummy;
    property AllowNewFolder: Boolean read FAllowNewFolder write FAllowNewFolder default True;
    property BrowseDialogText:string read FBrowseDialogText write FBrowseDialogText;
    property EditAlign: Byte read FDummy;
    property EditType: Byte read FDummy;
    property ExcelStyleDecimalSeparator: Byte read FDummy;
    property PasswordChar: Byte read FDummy;
    property Precision: Byte read FDummy;
    property Signed: Byte read FDummy;
    property ShowURL: Byte read FDummy;
    property URLColor: Byte read FDummy;

    property OnClickBtn: TNotifyEvent read FOnClickBtn;
    property OnValueValidate: TValueValidateEvent read fOnValueValidate;
  end;

implementation

uses
 {$WARNINGS OFF}
 // avoid platform specific warning 
  FileCtrl, ShlObj, ActiveX;
 {$WARNINGS ON}

const
  BIF_NONEWFOLDERBUTTON = $0200;

{$R *.RES}

constructor TAdvDirectoryEdit.Create(AOwner: TComponent);
begin
  Inherited;
  Glyph.LoadFromResourceName (HInstance, 'AdvDirectoryEdit');
  Button.OnClick := BtnClick;
  Inherited OnValueValidate := ValueValidate;
  ButtonWidth := 18;
  FBrowseDialogText := 'Select Directory';
  FAllowNewFolder := True;
end;

{$IFNDEF DELPHI5_LVL}
function ExcludeTrailingBackslash(DirName: string): string;
begin
  if Length(DirName) > 0 then
  begin
    if (DirName[Length(DirName)] in ['\','/']) then
      Delete(DirName,Length(DirName),1);
  end;
  Result := DirName;
end;
{$ENDIF}

function AdvDirectoryEditCallBack (Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
var
  Temp: String;
  pt: TPoint;
  r: TRect;
begin
  if uMsg = BFFM_INITIALIZED then
  begin
    with TAdvDirectoryEdit (lpData) Do
    begin
      {$WARNINGS OFF}
      // avoid platform specific warning
      if Text = '' then
        Temp := GetCurrentDir
      else
        Temp := ExcludeTrailingBackslash (Text);
      {WARNINGS ON}

      SendMessage (Wnd, BFFM_SETSELECTION, 1, Integer(PChar(Temp)));

      with TAdvDirectoryEdit(lpData) do
      begin
        pt := Point(0,Height);
        pt := ClientToScreen(pt);
        GetWindowRect(Wnd,r);

        if pt.X + (r.Right - r.Left) > Screen.Width then
          pt.X := pt.X - (r.Right - r.Left);

        if pt.Y + (r.Bottom - r.Top) < Screen.Height then
          SetWindowPos(wnd,HWND_NOTOPMOST,pt.X,pt.Y,0,0,SWP_NOSIZE or SWP_NOZORDER)
        else
          SetWindowPos(wnd,HWND_NOTOPMOST,pt.X,pt.Y-(r.Bottom - r.Top)-Height,0,0,SWP_NOSIZE or SWP_NOZORDER)
      end;
    end;
  end;
  Result := 0;
end;

procedure TAdvDirectoryEdit.BtnClick (Sender: TObject);
var
  bi: TBrowseInfo;
  iIdList: PItemIDList;
  ResStr: array[0..MAX_PATH] of char;
  MAlloc: IMalloc;

  // BIF_NONEWFOLDERBUTTON
begin
  FillChar(bi, sizeof(bi), #0);

  with bi do
  begin
    if Text <> '' then
      StrPCopy(ResStr,Text)
    else
      StrPCopy(ResStr,GetCurrentDir);

    hwndOwner := Application.Handle;
    pszDisplayName := ResStr;

    lpszTitle := PChar(FBrowseDialogText);

    ulFlags := BIF_RETURNONLYFSDIRS;
    
    if not FAllowNewFolder then
      ulFlags := ulFlags or BIF_NONEWFOLDERBUTTON;

    lpfn := AdvDirectoryEditCallBack;
    lParam := Integer(Self);
  end;

  iIdList := Nil;
  try
    iIdList := SHBrowseForFolder(bi);
  except
  end;

  if iIdList <> Nil then
  begin
    try
      FillChar(ResStr,sizeof(ResStr),#0);
      if SHGetPathFromIDList (iIdList, ResStr) then
      begin
        if Text <> StrPas(ResStr) then
        begin
          Text := StrPas(ResStr);
          Modified := True;
        end;
      end;
    finally
      SHGetMalloc(MAlloc);
      Malloc.Free(iIdList);
    end;
  end;
end;

procedure TAdvDirectoryEdit.ValueValidate(Sender: TObject; Value: String; Var IsValid: Boolean);
begin
  IsValid := DirectoryExists (Value);
end;

function TAdvDirectoryEdit.IsValidDirectory: Boolean;
begin
  Result := DirectoryExists (Text);
  IsError := not Result;

end;

end.
