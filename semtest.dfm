object fSemTest: TfSemTest
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088#1082#1072' '#1089#1077#1084#1072#1085#1090#1080#1082#1080
  ClientHeight = 216
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 343
    Top = 8
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 256
    Top = 8
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object sgSem: TStringGrid
    Left = 0
    Top = 60
    Width = 426
    Height = 156
    Align = alBottom
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 36
    Top = 20
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
end
