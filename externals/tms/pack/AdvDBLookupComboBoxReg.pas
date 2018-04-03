unit AdvDBLookupComboBoxReg;

interface

{$I TMSDEFS.INC}

uses
  Classes, AdvDBLookupComboBox, AdvDBLookupComboBoxDE
  {$IFDEF DELPHI6_LVL}
  , DesignIntf, DesignEditors
  {$ELSE}
  , DsgnIntf
  {$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TAdvDBLookupComboBox]);
  RegisterPropertyEditor(TypeInfo(string),TDBColumnItem,'ListField',TAdvDBComboFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TAdvDBLookupComboBox,'KeyField',TAdvDBComboFieldNameProperty);  

  RegisterPropertyEditor(TypeInfo(string),TAdvDBLookupComboBox,'FilterField',TAdvDBComboFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string),TAdvDBLookupComboBox,'LabelField',TAdvDBComboFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string),TAdvDBLookupComboBox,'SortColumn',TAdvDBComboColumnNameProperty);

  RegisterComponentEditor(TAdvDBLookupComboBox,TAdvDBLookupComboBoxEditor);

end;


end.
