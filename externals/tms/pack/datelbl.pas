{********************************************************************
TDateLabel component
for Delphi 3.0,4.0,5.0,6.0,7.0 & C++Builder 3.0,4.0,5.0,6.0
version 1.1

written by
  TMS Software
  Copyright © 1999-2002
  Email : info@tmssoftware.com
  Web : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application.
********************************************************************}

unit datelbl;

interface

uses
 stdctrls,messages,classes,sysutils;

type
  TDateLabel = class(TLabel)
               private
                FDateTimeFormat:string;
                procedure SetFormat(const Value:string);
               protected
                procedure loaded; override;
               public
                constructor Create(AOwner: TComponent); override;
               published
                property DateTimeFormat:string read FDateTimeFormat write SetFormat;
               end;

procedure Register;

implementation

constructor tdatelabel.Create(AOwner: TComponent);
begin
 inherited Create(aOwner);
 caption:=datetostr(Now);
 fdatetimeformat:='d/m/yyyy';
end;

procedure TDateLabel.Loaded;
begin
 inherited;
 if (csDesigning in ComponentState) then
   self.caption:=formatdatetime(fdatetimeformat,now);
end;

procedure tdatelabel.SetFormat(const Value: string);
begin
 fDatetimeformat:=value;
 if (csDesigning in ComponentState) then
   self.caption:=formatdatetime(fdatetimeformat,now);
end;

procedure Register;
begin
 RegisterComponents('TMS', [TDateLabel]);
end;


end.
