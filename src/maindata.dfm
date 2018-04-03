object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 378
  Top = 174
  Height = 306
  Width = 435
  object idTranslationProvider: TidTlINIDataProvider
    DefaultLanguage = 'DE'
    Language = 'DE'
    IniFileName = 'liftoff'
    Left = 48
    Top = 16
  end
  object Translator: TidTranslator
    DataProvider = idTranslationProvider
    Left = 72
    Top = 136
  end
end
