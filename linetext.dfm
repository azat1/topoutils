object fLineText: TfLineText
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1087#1080#1089#1099#1074#1072#1085#1080#1077' '#1083#1080#1085#1080#1081
  ClientHeight = 286
  ClientWidth = 428
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
    Top = 16
    Width = 100
    Height = 13
    Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1086#1076#1087#1080#1089#1077#1081
  end
  object Label2: TLabel
    Left = 18
    Top = 69
    Width = 143
    Height = 13
    Caption = #1057#1090#1080#1083#1100' '#1076#1083#1103' '#1074#1077#1088#1093#1085#1077#1081' '#1085#1072#1076#1087#1080#1089#1080
  end
  object Label3: TLabel
    Left = 18
    Top = 151
    Width = 139
    Height = 13
    Caption = #1057#1090#1080#1083#1100' '#1076#1083#1103' '#1085#1080#1078#1085#1077#1081' '#1085#1072#1076#1087#1080#1089#1080
  end
  object Label4: TLabel
    Left = 200
    Top = 200
    Width = 75
    Height = 13
    Caption = #1054#1090#1089#1090#1091#1087' '#1089#1074#1077#1088#1093#1091
  end
  object Label5: TLabel
    Left = 8
    Top = 200
    Width = 68
    Height = 13
    Caption = #1054#1090#1089#1090#1091#1087' '#1089#1085#1080#1079#1091
  end
  object cbInterval: TComboBox
    Left = 144
    Top = 13
    Width = 73
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = '150'
    Items.Strings = (
      '50'
      '100'
      '150'
      '200'
      '250'
      '500')
  end
  object cbUpStyle: TComboBox
    Left = 18
    Top = 88
    Width = 402
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object cbDownStyle: TComboBox
    Left = 18
    Top = 170
    Width = 402
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object Button1: TButton
    Left = 314
    Top = 238
    Width = 106
    Height = 40
    Caption = #1055#1086#1076#1087#1080#1089#1072#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 138
    Top = 238
    Width = 97
    Height = 40
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 4
    OnClick = Button2Click
  end
  object cbUpIndent: TComboBox
    Left = 288
    Top = 197
    Width = 73
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = '5'
    Items.Strings = (
      '0'
      '0,5'
      '1'
      '1,5'
      '2'
      '2,5'
      '3'
      '3,5'
      '4'
      '4,5'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '12'
      '14'
      '16'
      '18'
      '20')
  end
  object cbdownIndent: TComboBox
    Left = 96
    Top = 197
    Width = 73
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = '5'
    Items.Strings = (
      '0'
      '0,5'
      '1'
      '1,5'
      '2'
      '2,5'
      '3'
      '3,5'
      '4'
      '4,5'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '12'
      '14'
      '16'
      '18'
      '20')
  end
  object cbEnableUpStyle: TCheckBox
    Left = 18
    Top = 46
    Width = 159
    Height = 17
    Caption = #1053#1072#1076#1087#1080#1089#1100' '#1089#1074#1077#1088#1093#1091
    TabOrder = 7
  end
  object cbeNableDownStyle: TCheckBox
    Left = 18
    Top = 128
    Width = 159
    Height = 17
    Caption = #1053#1072#1076#1087#1080#1089#1100' '#1089#1085#1080#1079#1091
    TabOrder = 8
  end
end
