{***************************************************************************}
{ TFormSize component                                                       }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0,6.0                   }
{ version 1.1 - rel. February, 2002                                         }
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

unit FormSize;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Forms, ShellAPI;

type
  EFormSizeError = class(Exception);
  TFormSize = class(TComponent)
  private
    { Private declarations }
    OldWndProc: TFarProc;
    NewWndProc: Pointer;
    FSaveMachine: boolean;
    FSaveUser: boolean;
    FSavePosition: boolean;
    FSaveSize: boolean;
    FSaveName: string;
    FSaveKey: string;
    FDragAlways: boolean;
    FMagnet: boolean;
    FMagnetDistance: integer;
    function CreateKey:string;
  protected
    { Protected declarations }
    procedure HookWndProc(var Msg: TMessage);
    procedure LoadPlacement;
    procedure DoSavePlacement;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure SaveFormSettings;
    procedure LoadFormSettings;
  published
    { Published declarations }
    property DragAlways: boolean read FDragAlways write FDragAlways default False;
    property Magnet: boolean read FMagnet write FMagnet default False;
    property MagnetDistance: integer read FMagnetDistance write FMagnetDistance;
    property SavePosition: boolean read FSavePosition write FSavePosition default True;
    property SaveSize: boolean read FSaveSize write FSaveSize default True;
    property SaveUser: boolean read FSaveUser write FSaveUser;
    property SaveMachine: boolean read fSaveMachine write fSaveMachine;
    property SaveName: string read FSaveName write FSaveName;
    property SaveKey: string read FSaveKey write FSaveKey;
  end;


implementation

uses
 INIFiles;

constructor TFormSize.Create(AOwner:TComponent);
var
  I, Instances: Integer;
begin
  inherited Create(AOwner);
  if not (Owner is TForm) then
    raise EFormSizeError.Create('Control parent must be a form!');
  Instances := 0;
  for I := 0 to Owner.ComponentCount - 1 do
    if (Owner.Components[I] is TFormSize) then
      Inc(Instances);
  if (Instances > 1) then
    raise EFormSizeError.Create('The form already contains a TFormSize component');

  FSavePosition := True;
  FSaveSize := True;
  FSaveName := '.\FORM.INI';
  FSaveKey := owner.Name;
  FMagnetDistance := 32;
  { Hook parent }
  OldWndProc := TFarProc(GetWindowLong((Owner as TForm).Handle, GWL_WNDPROC));
  {$WARNINGS OFF} 
  NewWndProc := MakeObjectInstance(HookWndProc);
  SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, LongInt(NewWndProc));
  {$WARNINGS ON}
end;  { TFormSize.Create }

procedure TFormSize.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) and FSavePosition then
    LoadPlacement;
end;  { TFormSize.Loaded }

destructor TFormSize.Destroy;
begin
  { Unhook parent }
  if (Owner <> nil) and Assigned(OldWndProc) then
    SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, LongInt(OldWndProc));
  {$WARNINGS OFF} 
  if Assigned(NewWndProc) then
    FreeObjectInstance(NewWndProc);
  {$WARNINGS ON}
  { Clean up }
  inherited Destroy;
end;  { TFormSize.Destroy }

procedure TFormSize.LoadPlacement;
var
  Rect: TRect;
  Maximize: Boolean;
  Settings: TIniFile;
  Key:string;

begin
  if (FSaveName = '') or (FSaveKey = '') then Exit;
  Settings := TIniFile.Create(FSaveName);
  try
    Rect := (Owner as TForm).BoundsRect;
    Key := CreateKey;

    with Settings, Rect do
      begin
       if FSavePosition then
       begin
         Left := ReadInteger(Key, 'Left', Left);
         Top := ReadInteger(Key, 'Top', Top);
       end;

       if FSaveSize then
       begin
         Right := ReadInteger(Key, 'Right', Right);
         Bottom := ReadInteger(Key, 'Bottom', Bottom);
       end
       else
       begin
         Right := Left+(Owner as TForm).Width;
         Bottom := Top+(Owner as TForm).Height;
       end;

       Maximize := ReadBool(Key, 'Maximized',
         (Owner as TForm).WindowState = wsMaximized);
       { Make sure the window is entirely visible on the screen }
       if (Right > Screen.Width) then
       begin
         Dec(Left, (Right - Screen.Width));
         Right := Screen.Width;
       end;
       if (Bottom > Screen.Height) then
       begin
         Dec(Top, (Bottom - Screen.Height));
         Bottom := Screen.Height;
       end;
    end;
    (Owner as TForm).BoundsRect := Rect;
    if Maximize then
      (Owner as TForm).WindowState := wsMaximized;
  finally
    Settings.Free;
  end;
end;  { TFormSize.LoadPlacement }

procedure TFormSize.DoSavePlacement;
var
  Placement: TWindowPlacement;
  Settings: TIniFile;
  Key:string;
begin
  if (FSaveName = '') or (FSaveKey = '') then Exit;
  Settings := TIniFile.Create(FSaveName);
  try
    Key := CreateKey;
    Placement.length := SizeOf(Placement);
    GetWindowPlacement((Owner as TForm).Handle, @Placement);
    with Settings, Placement, rcNormalPosition do
    begin
      if FSavePosition then
      begin
        WriteInteger(Key, 'Left', Left);
        WriteInteger(Key, 'Top', Top);
      end;
      if FSaveSize then
      begin
        WriteInteger(Key, 'Right', Right);
        WriteInteger(Key, 'Bottom', Bottom);
        WriteBool(Key, 'Maximized', showCmd = SW_SHOWMAXIMIZED);
      end;
    end;
  finally
    Settings.Free;
  end;
end;  { TFormSize.DoSavePlacement }

procedure TFormSize.HookWndProc(var Msg: TMessage);
var
 xpos,ypos:word;
 pt: TPoint;
 wp: PWindowPos;
 R: TRect;
 AD : TAppBarData;
 lim_left,lim_top,lim_right,lim_bottom : integer;

begin
 with Msg do
  begin
  case Msg of
  WM_WINDOWPOSCHANGING:begin
                        if FMagnet then
                         begin
                          fillchar(AD,sizeof(AD),0);
                          AD.cbSize := sizeof(AD);
                          SHAppBarMessage(ABM_GETTASKBARPOS,AD);

                          lim_left := 0;
                          lim_right := GetSystemMetrics(SM_CXSCREEN);
                          lim_top := 0;
                          lim_bottom := GetSystemMetrics(SM_CYSCREEN);

                          case AD.uEdge of
                          ABE_BOTTOM: lim_bottom := lim_bottom - (AD.rc.Bottom -AD.rc.Top);
                          ABE_TOP: lim_top := lim_top + (AD.rc.Bottom -AD.rc.Top);
                          ABE_LEFT: lim_left := lim_left + (AD.rc.Right -AD.rc.Left);
                          ABE_RIGHT: lim_right := lim_right - (AD.rc.Right -AD.rc.Left);
                          end;

                          wp:=PWindowPos(lparam);

                          R := (Owner as TForm).BoundsRect;

                          if (wp^.x<lim_left + FMagnetDistance) or (wp^.x<lim_left) then wp^.x := 0;
                          if (wp^.y<lim_top + FMagnetDistance) or (wp^.y<lim_top) then wp^.y := 0;

                          if (wp^.y + (R.Bottom-R.Top) > lim_bottom-FMagnetDistance) then
                             wp^.y := lim_bottom - (R.Bottom-R.Top);

                          if (wp^.x + (R.Right-R.Left) > lim_right-FMagnetDistance) then
                             wp^.x := lim_right - (R.Right-R.Left);

                         end;


                       end;
  end;

  Result := CallWindowProc(OldWndProc, (Owner as TForm).Handle, Msg,
                              wParam, lParam);

  case Msg of
  WM_DESTROY: if not (csDesigning in ComponentState) and FSavePosition then
              DoSavePlacement;
  WM_NCHITTEST:begin
                if FDragAlways and not (csDesigning in ComponentState) then
                 begin
                  xpos:=loword(lParam);
                  ypos:=hiword(lParam);
                  pt := (Owner as TForm).ScreenToClient(point(xpos,ypos));
                  if PtInRect((Owner as TForm).ClientRect,pt) then Result := htCaption;
                 end;
               end;
  end;
 end;
end;  { TFormSize.HookWndProc }

function TFormSize.CreateKey: string;
var
 buf:array[0..255] of char;
 bufsize:dword;
begin
 result:=SaveKey;
 bufsize:=sizeof(buf);
 GetUserName(buf,bufsize);
 if fSaveUser then result:=result+'-'+strpas(buf);
 bufsize:=sizeof(buf);
 GetComputerName(buf,bufsize);
 if fSaveMachine then result:=result+'-'+strpas(buf);
end;

procedure TFormSize.LoadFormSettings;
var
  osavepos,osavesize: Boolean;
begin
  osavesize := FSaveSize;
  osavepos := FSavePosition;
  FSaveSize := True;
  FSavePosition := True;
  LoadPlacement;
  FSaveSize := osavesize;
  FSavePosition := osavepos;
end;

procedure TFormSize.SaveFormSettings;
var
  osavepos,osavesize: Boolean;
begin
  osavesize := FSaveSize;
  osavepos := FSavePosition;
  FSaveSize := True;
  FSavePosition := True;
  DoSavePlacement;
  FSaveSize := osavesize;
  FSavePosition := osavepos;
end;

end.
