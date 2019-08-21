object fSemiPinDrawer: TfSemiPinDrawer
  Left = 0
  Top = 0
  Caption = #1056#1080#1089#1086#1074#1072#1085#1080#1077' '#1089#1090#1086#1083#1073#1086#1074
  ClientHeight = 105
  ClientWidth = 544
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
    Left = 8
    Top = 40
    Width = 69
    Height = 13
    Caption = #1057#1090#1080#1083#1100' '#1089#1090#1086#1083#1073#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 75
    Width = 103
    Height = 13
    Caption = #1057#1083#1086#1081' '#1082#1086#1084#1084#1091#1085#1080#1082#1072#1094#1080#1081' '
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 52
    Height = 13
    Caption = #1057#1083#1086#1081' '#1086#1087#1086#1088
  end
  object cbSelStyle: TComboBox
    Left = 83
    Top = 36
    Width = 453
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbSelStyleChange
  end
  object eCommLayerName: TEdit
    Left = 117
    Top = 72
    Width = 348
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 476
    Top = 70
    Width = 60
    Height = 25
    Caption = #1042#1099#1073#1086#1088'...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 117
    Top = 5
    Width = 348
    Height = 21
    TabOrder = 3
  end
  object Button2: TButton
    Left = 476
    Top = 3
    Width = 60
    Height = 25
    Caption = #1042#1099#1073#1086#1088'...'
    TabOrder = 4
    OnClick = Button2Click
  end
end
