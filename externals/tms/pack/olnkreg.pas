{********************************************************************
TODBCLINK component
for Delphi 3.0,4.0,5.0 & C++Builder 3.0,4.0
version 0.4b

written by
  TMS Software
  copyright © 1996-1999
  Email : info@tmssoftware.com
  Web : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The complete
source code remains property of the author and may not be distributed,
published, given or sold in any form as such. No parts of the source
code can be included in any other component or application without
written authorization of the author.
********************************************************************}

unit olnkreg;

interface
{$I TMSDEFS.INC}
uses
  Classes,odbclink,odbcde,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('TMS',[TODBCLink]);
 RegisterPropertyEditor(TypeInfo(string),TODBCLink,'DataSource',TODBCDataSourceProperty);
 RegisterPropertyEditor(TypeInfo(string),TODBCLink,'Driver',TODBCDriverProperty);
 RegisterPropertyEditor(TypeInfo(string),TODBCLink,'Table',TODBCTableProperty);
 RegisterPropertyEditor(TypeInfo(integer),TODBCField,'Datatype',TODBCFieldProperty);
 RegisterPropertyEditor(TypeInfo(string),TODBCField,'FieldName',TODBCFieldNameProperty);
end;


end.
