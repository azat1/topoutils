object fVedomost: TfVedomost
  Left = 377
  Top = 272
  Width = 547
  Height = 316
  Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074#1099#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1083#1086#1097#1072#1076#1077#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 82
    Height = 13
    Caption = #1055#1086#1083#1077' '#1079#1072#1075#1086#1083#1086#1074#1082#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 30
    Height = 13
    Caption = #1057#1090#1080#1083#1100
  end
  object Label3: TLabel
    Left = 8
    Top = 144
    Width = 98
    Height = 13
    Caption = #1055#1086#1083#1077' '#1085#1086#1084#1077#1088#1072' '#1090#1086#1095#1082#1080
  end
  object Button1: TButton
    Left = 400
    Top = 192
    Width = 105
    Height = 33
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 400
    Top = 240
    Width = 105
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button2Click
  end
  object cbTitleField: TComboBox
    Left = 8
    Top = 40
    Width = 369
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object cbUsePoints: TCheckBox
    Left = 8
    Top = 72
    Width = 281
    Height = 17
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1085#1086#1084#1077#1088#1072' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1093' '#1090#1086#1095#1077#1082
    TabOrder = 3
  end
  object eStyleName: TEdit
    Left = 8
    Top = 112
    Width = 369
    Height = 21
    TabOrder = 4
  end
  object cbPointField: TComboBox
    Left = 8
    Top = 160
    Width = 369
    Height = 21
    ItemHeight = 13
    TabOrder = 5
  end
  object Button3: TButton
    Left = 384
    Top = 112
    Width = 75
    Height = 17
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    TabOrder = 6
    OnClick = Button3Click
  end
end
