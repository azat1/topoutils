object fPKZOImport: TfPKZOImport
  Left = 357
  Top = 266
  Width = 706
  Height = 395
  Caption = #1048#1084#1087#1086#1088#1090' '#1080#1079' '#1055#1050' '#1047#1054
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object leFolder: TLabeledEdit
    Left = 8
    Top = 24
    Width = 481
    Height = 21
    EditLabel.Width = 126
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1072#1087#1082#1072' '#1089' '#1092#1072#1081#1083#1072#1084#1080' '#1055#1050' '#1047#1054
    TabOrder = 0
  end
  object Button1: TButton
    Left = 496
    Top = 24
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 608
    Top = 328
    Width = 75
    Height = 25
    Caption = #1048#1084#1087#1086#1088#1090
    TabOrder = 2
    OnClick = Button2Click
  end
  object sgPoints: TStringGrid
    Left = 8
    Top = 64
    Width = 681
    Height = 97
    ColCount = 12
    DefaultRowHeight = 12
    FixedCols = 0
    TabOrder = 3
  end
  object sgOPoints: TStringGrid
    Left = 8
    Top = 176
    Width = 681
    Height = 97
    ColCount = 12
    DefaultRowHeight = 12
    FixedCols = 0
    TabOrder = 4
  end
end
