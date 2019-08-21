object fCoordSystem: TfCoordSystem
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1074#1086#1076' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  ClientHeight = 365
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 92
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1072#1103' '#1089#1080#1089#1090#1077#1084#1072
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 97
    Height = 13
    Caption = #1058#1088#1077#1073#1091#1077#1084#1072#1103' '#1089#1080#1089#1090#1077#1084#1072
  end
  object cbSource: TComboBox
    Left = 16
    Top = 27
    Width = 393
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object cbDest: TComboBox
    Left = 16
    Top = 83
    Width = 393
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object rgWhat: TRadioGroup
    Left = 16
    Top = 110
    Width = 193
    Height = 139
    Caption = #1054#1073#1098#1077#1082#1090#1099
    Items.Strings = (
      #1042#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1086#1073#1098#1077#1082#1090#1099
      #1042#1089#1077' '#1086#1073#1098#1077#1082#1090#1099
      #1042#1089#1077' '#1086#1073#1098#1077#1082#1090#1099' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1089#1083#1086#1103
      #1042#1089#1077' '#1086#1073#1098#1077#1082#1090#1099' '#1090#1077#1082#1091#1097#1077#1081' '#1082#1072#1088#1090#1099)
    TabOrder = 2
  end
  object Button1: TButton
    Left = 272
    Top = 172
    Width = 137
    Height = 37
    Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 272
    Top = 120
    Width = 137
    Height = 25
    Caption = #1057#1080#1089#1090#1077#1084#1099' '#1082#1086#1086#1088#1076#1080#1085#1072#1090'...'
    TabOrder = 4
    OnClick = Button2Click
  end
  object lbErrs: TListBox
    Left = 8
    Top = 276
    Width = 401
    Height = 81
    ItemHeight = 13
    TabOrder = 5
  end
end
