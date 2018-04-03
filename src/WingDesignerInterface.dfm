object dmWingDesigner: TdmWingDesigner
  OldCreateOrder = False
  Left = 189
  Height = 450
  Width = 577
  object dlgImport: TOpenDialog
    DefaultExt = 's4q'
    Filter = 'Wing Designer Fl'#228'chen|*.s4w'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 48
    Top = 48
  end
  object dlgExport: TSaveDialog
    DefaultExt = 's4w'
    Filter = 'Wing Designer Fl'#228'chen|*.s4w'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing, ofDontAddToRecent]
    Left = 160
    Top = 48
  end
end
