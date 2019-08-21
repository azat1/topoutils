object fDeCurve: TfDeCurve
  Left = 0
  Top = 0
  Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1076#1091#1075
  ClientHeight = 168
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 32
    Width = 132
    Height = 13
    Caption = #1064#1072#1075' '#1072#1087#1087#1088#1086#1082#1089#1080#1084#1072#1094#1080#1080' '#1075#1088#1072#1076'.'
    Visible = False
  end
  object Button1: TButton
    Left = 336
    Top = 16
    Width = 121
    Height = 33
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 80
    Top = 48
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '1'
    Visible = False
  end
  object udStep: TUpDown
    Left = 129
    Top = 48
    Width = 14
    Height = 21
    Associate = Edit1
    Min = 1
    Position = 1
    TabOrder = 2
    Visible = False
  end
  object Button2: TButton
    Left = 336
    Top = 96
    Width = 123
    Height = 49
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button2Click
  end
  object bFastMake: TButton
    Left = 20
    Top = 96
    Width = 169
    Height = 49
    Caption = #1043#1088#1091#1073#1086#1077' '#1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077
    TabOrder = 4
    OnClick = bFastMakeClick
  end
end
