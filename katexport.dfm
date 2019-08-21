object fKatExport: TfKatExport
  Left = 330
  Top = 264
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' '#1092#1086#1088#1084#1072#1090' KAT'
  ClientHeight = 110
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = #1055#1086#1083#1077' '#1074#1099#1089#1086#1090#1099
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 67
    Height = 13
    Caption = #1055#1086#1083#1077' '#1085#1086#1084#1077#1088#1072
  end
  object cbZ: TComboBox
    Left = 120
    Top = 8
    Width = 345
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object cbName: TComboBox
    Left = 120
    Top = 32
    Width = 345
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 392
    Top = 72
    Width = 75
    Height = 25
    Caption = #1069#1082#1089#1087#1086#1088#1090
    TabOrder = 2
    OnClick = Button1Click
  end
  object cbHZero: TCheckBox
    Left = 8
    Top = 76
    Width = 97
    Height = 17
    Caption = #1042#1099#1089#1086#1090#1072' =0 '
    TabOrder = 3
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'KAT'
    Filter = #1050#1040#1058' '#1092#1072#1081#1083#1099'|*.KAT'
    Left = 288
    Top = 72
  end
end
