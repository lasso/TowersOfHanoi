object NewHiScoreForm: TNewHiScoreForm
  Left = 0
  Top = 0
  Caption = 'NewHiScoreForm'
  ClientHeight = 78
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object InfoText: TLabel
    Left = 16
    Top = 16
    Width = 3
    Height = 13
  end
  object EditInitials: TEdit
    Left = 8
    Top = 49
    Width = 145
    Height = 21
    MaxLength = 3
    TabOrder = 0
  end
  object SaveHiScoreButton: TButton
    Left = 408
    Top = 45
    Width = 75
    Height = 25
    Caption = 'Save Hiscore'
    TabOrder = 1
    OnClick = SaveHiScoreButtonClick
  end
  object Conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\lasso\Documents\Embarcadero\Studio\Projects\To' +
        'H\hiscores.db'
      'DriverID=SQLite')
    Left = 16
    Top = 24
  end
end
