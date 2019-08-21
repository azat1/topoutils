object fOkrugl: TfOkrugl
  Left = 0
  Top = 0
  Width = 397
  Height = 176
  Caption = #1054#1082#1088#1091#1075#1083#1077#1085#1080#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 20
    Width = 53
    Height = 13
    Caption = #1064#1072#1075' '#1089#1077#1090#1082#1080
  end
  object eSetkaStep: TEdit
    Left = 76
    Top = 16
    Width = 121
    Height = 21
    Hint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1082#1088#1072#1090#1085#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1086#1082#1088#1091#1075#1083#1103#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = '0,01'
  end
  object Button1: TButton
    Left = 300
    Top = 56
    Width = 75
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 300
    Top = 100
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
end
