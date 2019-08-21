object fCSVExport: TfCSVExport
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1082#1086#1086#1088#1076#1080#1085#1072#1090' '#1074' CSV'
  ClientHeight = 99
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 296
    Top = 56
    Width = 75
    Height = 25
    Caption = #1069#1082#1089#1087#1086#1088#1090'...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'CSV'
    Filter = #1060#1072#1081#1083#1099' CSV|*.CSV'
    Left = 176
    Top = 32
  end
end
