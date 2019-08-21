object fCoordSystemList: TfCoordSystemList
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1087#1080#1089#1082#1072' '#1089#1080#1089#1090#1077#1084' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  ClientHeight = 371
  ClientWidth = 404
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
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 273
    Height = 355
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 312
    Top = 8
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 312
    Top = 48
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 312
    Top = 104
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 312
    Top = 338
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 4
  end
end
