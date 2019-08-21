object fPodt: TfPodt
  Left = 0
  Top = 0
  Width = 561
  Height = 250
  Caption = #1055#1086#1076#1090#1103#1078#1082#1072
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
  object Button1: TButton
    Left = 368
    Top = 184
    Width = 75
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 464
    Top = 184
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button2Click
  end
  object leLarName: TLabeledEdit
    Left = 8
    Top = 24
    Width = 529
    Height = 21
    EditLabel.Width = 160
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1083#1086#1081' '#1087#1086#1076#1090#1103#1075#1080#1074#1072#1077#1084#1099#1093' '#1086#1073#1098#1077#1082#1090#1086#1074
    TabOrder = 2
  end
  object Button3: TButton
    Left = 464
    Top = 48
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1086#1088'...'
    TabOrder = 3
    OnClick = Button3Click
  end
  object leDist: TLabeledEdit
    Left = 8
    Top = 80
    Width = 121
    Height = 21
    EditLabel.Width = 137
    EditLabel.Height = 13
    EditLabel.Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1077' '
    TabOrder = 4
  end
end
