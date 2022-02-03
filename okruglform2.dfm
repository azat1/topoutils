object fOkruglForm2: TfOkruglForm2
  Left = 0
  Top = 0
  Caption = #1054#1082#1088#1091#1075#1083#1077#1085#1080#1077' '#1091#1083#1091#1095#1096#1077#1085#1085#1086#1077
  ClientHeight = 207
  ClientWidth = 560
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
    Left = 12
    Top = 20
    Width = 53
    Height = 13
    Caption = #1064#1072#1075' '#1089#1077#1090#1082#1080
  end
  object Label2: TLabel
    Left = 224
    Top = 8
    Width = 3
    Height = 13
  end
  object Button2: TButton
    Left = 466
    Top = 160
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 468
    Top = 112
    Width = 75
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object eSetkaStep: TEdit
    Left = 76
    Top = 16
    Width = 121
    Height = 21
    Hint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1082#1088#1072#1090#1085#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1086#1082#1088#1091#1075#1083#1103#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Text = '0,01'
  end
  object rgType: TRadioGroup
    Left = 8
    Top = 64
    Width = 305
    Height = 84
    Caption = #1053#1077' '#1076#1086#1087#1091#1089#1082#1072#1090#1100' '#1088#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1103' '
    Items.Strings = (
      #1042#1085#1091#1090#1088#1080' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1089#1083#1086#1103
      #1057#1085#1072#1088#1091#1078#1080' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1089#1083#1086#1103)
    TabOrder = 3
  end
  object Button3: TButton
    Left = 440
    Top = 32
    Width = 101
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1083#1086#1081'...'
    TabOrder = 4
    OnClick = Button3Click
  end
  object cbNotAll: TCheckBox
    Left = 12
    Top = 154
    Width = 253
    Height = 17
    Caption = #1054#1082#1088#1091#1075#1083#1103#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1091#1078#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1085#1099#1077
    TabOrder = 5
  end
end
