object fSmartPointMaker: TfSmartPointMaker
  Left = 0
  Top = 0
  Caption = #1053#1091#1084#1077#1088#1072#1094#1080#1103' '#1090#1086#1095#1077#1082
  ClientHeight = 308
  ClientWidth = 679
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 13
    Caption = #1057#1090#1080#1083#1100' '#1090#1086#1095#1077#1082
  end
  object Label2: TLabel
    Left = 12
    Top = 160
    Width = 38
    Height = 13
    Caption = #1060#1086#1088#1084#1072#1090
  end
  object Label3: TLabel
    Left = 12
    Top = 104
    Width = 81
    Height = 13
    Caption = #1055#1086#1083#1077' '#1089#1077#1084#1072#1085#1090#1080#1082#1080
  end
  object Label4: TLabel
    Left = 12
    Top = 203
    Width = 45
    Height = 13
    Caption = #1053#1072#1095#1072#1090#1100' '#1089
  end
  object Label5: TLabel
    Left = 8
    Top = 51
    Width = 82
    Height = 13
    Caption = #1057#1090#1080#1083#1100' '#1087#1086#1076#1087#1080#1089#1077#1081
  end
  object Label6: TLabel
    Left = 12
    Top = 232
    Width = 121
    Height = 13
    Caption = #1057#1084#1077#1097#1077#1085#1080#1077' '#1085#1072#1076#1087#1080#1089#1080' '#1087#1086' X'
  end
  object Label7: TLabel
    Left = 12
    Top = 259
    Width = 121
    Height = 13
    Caption = #1057#1084#1077#1097#1077#1085#1080#1077' '#1085#1072#1076#1087#1080#1089#1080' '#1087#1086' Y'
  end
  object eSelStyle: TEdit
    Left = 8
    Top = 24
    Width = 561
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 576
    Top = 24
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object cbDeleteOld: TCheckBox
    Left = 12
    Top = 136
    Width = 137
    Height = 17
    Caption = #1059#1076#1072#1083#1103#1090#1100' '#1089#1090#1072#1088#1099#1077
    TabOrder = 4
  end
  object eFormat: TEdit
    Left = 68
    Top = 160
    Width = 249
    Height = 21
    TabOrder = 6
    Text = '%d'
  end
  object Button2: TButton
    Left = 586
    Top = 239
    Width = 85
    Height = 42
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 10
    OnClick = Button2Click
  end
  object cbField: TComboBox
    Left = 108
    Top = 104
    Width = 465
    Height = 21
    ItemHeight = 13
    TabOrder = 3
  end
  object cbNoRepeat: TCheckBox
    Left = 164
    Top = 136
    Width = 329
    Height = 17
    Caption = #1053#1077' '#1089#1086#1079#1076#1072#1074#1072#1090#1100' '#1087#1086#1074#1077#1088#1093' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1093
    TabOrder = 5
  end
  object eStartN: TEdit
    Left = 68
    Top = 200
    Width = 49
    Height = 21
    TabOrder = 7
    Text = '1'
  end
  object cbTextStyle: TComboBox
    Left = 8
    Top = 70
    Width = 449
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object eDX: TEdit
    Left = 160
    Top = 229
    Width = 121
    Height = 21
    TabOrder = 8
    Text = '1'
  end
  object eDY: TEdit
    Left = 160
    Top = 256
    Width = 121
    Height = 21
    TabOrder = 9
    Text = '1'
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 291
    Width = 679
    Height = 17
    Align = alBottom
    TabOrder = 11
    ExplicitLeft = 264
    ExplicitTop = 288
    ExplicitWidth = 150
  end
end
