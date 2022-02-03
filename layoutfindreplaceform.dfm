object fLayoutFindReplaceForm: TfLayoutFindReplaceForm
  Left = 0
  Top = 0
  Caption = #1052#1072#1089#1089#1086#1074#1072#1103' '#1082#1086#1088#1088#1077#1082#1094#1080#1103' '#1096#1072#1073#1083#1086#1085#1086#1074
  ClientHeight = 397
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 168
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1096#1072#1073#1083#1086#1085#1086#1074' '#1076#1083#1103' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
  end
  object Label2: TLabel
    Left = 8
    Top = 200
    Width = 31
    Height = 13
    Caption = #1053#1072#1081#1090#1080
  end
  object Label3: TLabel
    Left = 10
    Top = 267
    Width = 48
    Height = 13
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100
  end
  object ListBox1: TListBox
    Left = 8
    Top = 35
    Width = 605
    Height = 146
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 296
    Top = 4
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 538
    Top = 4
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 504
    Top = 197
    Width = 109
    Height = 61
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1080#1089#1082' '#1079#1072#1084#1077#1085#1091
    TabOrder = 3
    WordWrap = True
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 336
    Width = 141
    Height = 45
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1085#1072' '#1087#1077#1095#1072#1090#1100
    TabOrder = 4
    OnClick = Button4Click
  end
  object eFind: TMemo
    Left = 64
    Top = 197
    Width = 417
    Height = 57
    TabOrder = 5
    WordWrap = False
  end
  object eReplace: TMemo
    Left = 64
    Top = 260
    Width = 417
    Height = 57
    TabOrder = 6
    WordWrap = False
  end
  object OpenDialog1: TOpenDialog
    Filter = #1064#1072#1073#1083#1086#1085#1099'|*.afr'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 224
  end
end
