{********************************************************************}
{ TSHADER component                                                  }
{ for Delphi 3.0,4.0,5.0,6.0 C++Builder 3.0,4.0,5.0                  }
{ version 1.0                                                        }
{                                                                    }
{ written by                                                         }
{       TMS Software                                                 }
{       copyright © 1998-2001                                        }
{       Email : info@tmssoftware.com                                 }
{       Web : http://www.tmssoftware.com                             }
{********************************************************************}

unit Shader;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
  TShader = class(TPanel)
  private
    TFromColor:TColor;
    TToColor:TColor;
    TSteps:word;
    TDirection:boolean;
    procedure SetFromColor(Color:TColor);
    procedure SetToColor(Color:TColor);
    procedure SetSteps(w:word);
    procedure SetDirection(b:boolean);
  protected
    procedure Paint; override;
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    { Public declarations }
  published
    property FromColor:TColor read TFromColor write SetFromCOlor default clBlue;
    property ToColor:TColor read TToColor write SetToColor default clBlack;
    property Steps:word read TSteps write SetSteps default 20;
    property Direction:boolean read TDirection write SetDirection;
    { Published declarations }
  end;

procedure Register;

implementation

constructor TShader.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  TSteps := 20;
  TDirection := False;
  TFromColor := clBlue;
  TToColor := clBlack;
end;

procedure TShader.SetFromColor(Color:TColor);
begin
  TFromColor := ColorToRGB(Color);
  Invalidate;
end;

procedure TShader.SetToColor(Color:TColor);
begin
  TToColor := ColorToRGB(Color);
  Invalidate;
end;

procedure TShader.SetSteps(w:word);
begin
  TSteps := w;
  Invalidate;
end;

procedure TShader.SetDirection(b:boolean);
begin
  TDirection := b;
  Invalidate;
end;

procedure TShader.Paint;
var
  diffr,startr,endr:longint;
  diffg,startg,endg:longint;
  diffb,startb,endb:longint;
  rstepr:real;
  rstepg:real;
  rstepb:real;
  rstepw:real;
  i,stepw:word;

begin
  if TSteps=0 then TSteps := 1;
  startr := (TFromColor and $0000ff);
  startg := (TFromColor and $00ff00) shr 8;
  startb := (TFromColor and $ff0000) shr 16;
  endr := (TToColor and $0000ff);
  endg := (TToColor and $00ff00) shr 8;
  endb := (TToColor and $ff0000) shr 16;

  diffr := endr-startr;
  diffg := endg-startg;
  diffb := endb-startb;

  rstepr := diffr/Tsteps;
  rstepg := diffg/Tsteps;
  rstepb := diffb/Tsteps;

  if TDirection then
    rstepw := width/TSteps
  else
    rstepw := height/TSteps;

  with Canvas do
  begin
    for i := 0 to Tsteps-1 do
    begin
      endr := startr+round(rstepr*i);
      endg := startg+round(rstepg*i);
      endb := startb+round(rstepb*i);
      stepw := round(i*rstepw);

      pen.color := endr + (endg shl 8) + (endb shl 16);

      brush.color := pen.color;
      if TDirection then
        rectangle(stepw,0,stepw+round(rstepw)+1,height)
      else
        rectangle(0,stepw,width,stepw+round(rstepw)+1);
    end;
  end;
end;


procedure Register;
begin
  RegisterComponents('TMS', [TShader]);
end;

end.
