object HiScoreForm: THiScoreForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Hi Score List'
  ClientHeight = 272
  ClientWidth = 152
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object HiScoreGrid: TStringGrid
    Left = 7
    Top = 8
    Width = 137
    Height = 257
    ColCount = 2
    Enabled = False
    RowCount = 10
    TabOrder = 0
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object Conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\lasso\Documents\Embarcadero\Studio\Projects\To' +
        'H\hiscores.db'
      'DriverID=SQLite')
    Left = 8
    Top = 16
  end
end
