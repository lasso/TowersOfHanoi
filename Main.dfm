object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Towers of Hanoi'
  ClientHeight = 467
  ClientWidth = 776
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 16
    Width = 200
    Height = 200
    Stretch = True
  end
  object Image2: TImage
    Left = 288
    Top = 16
    Width = 200
    Height = 200
    Stretch = True
  end
  object Image3: TImage
    Left = 560
    Top = 16
    Width = 200
    Height = 200
    Stretch = True
  end
  object Button1: TButton
    Left = 72
    Top = 232
    Width = 75
    Height = 25
    Caption = '>'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 72
    Top = 263
    Width = 75
    Height = 25
    Caption = '>>'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 344
    Top = 232
    Width = 75
    Height = 25
    Caption = '<'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 344
    Top = 263
    Width = 75
    Height = 25
    Caption = '>'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 624
    Top = 232
    Width = 75
    Height = 25
    Caption = '<'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 624
    Top = 263
    Width = 75
    Height = 25
    Caption = '<<'
    TabOrder = 5
    OnClick = Button6Click
  end
  object InfoBox: TMemo
    Left = 24
    Top = 312
    Width = 744
    Height = 105
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object HiScoreButton: TButton
    Left = 288
    Top = 434
    Width = 200
    Height = 25
    Caption = 'Show Hi Scores'
    TabOrder = 7
    OnClick = HiScoreButtonClick
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
