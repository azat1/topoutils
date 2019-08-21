object fTemplatesList: TfTemplatesList
  Left = 192
  Top = 114
  Width = 458
  Height = 281
  Caption = #1057#1087#1080#1089#1086#1082' '#1096#1072#1073#1083#1086#1085#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 216
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 368
    Top = 216
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object lMain: TListBox
    Left = 0
    Top = 0
    Width = 450
    Height = 161
    Align = alTop
    ItemHeight = 13
    TabOrder = 2
  end
  object bAdd: TButton
    Left = 8
    Top = 168
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
    TabOrder = 3
    OnClick = bAddClick
  end
  object bDelete: TButton
    Left = 96
    Top = 168
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 4
    OnClick = bDeleteClick
  end
  object bOpenTemplate: TButton
    Left = 300
    Top = 168
    Width = 148
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1096#1072#1073#1083#1086#1085' '#1074' Word'
    TabOrder = 5
    OnClick = bOpenTemplateClick
  end
  object OpenDialog1: TOpenDialog
    Filter = #1064#1072#1073#1083#1086#1085#1099' Word|*.dot'
    Left = 80
    Top = 208
  end
end
