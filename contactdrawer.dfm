object fContactDrawer: TfContactDrawer
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1056#1080#1089#1086#1074#1072#1085#1080#1077' '#1082#1086#1085#1090#1072#1082#1090#1085#1099#1093' '#1083#1080#1085#1080#1081
  ClientHeight = 119
  ClientWidth = 341
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
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = #1054#1089#1100' '#1088#1077#1083#1100#1089#1086#1074
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 127
    Height = 13
    Caption = #1057#1090#1080#1083#1100' '#1082#1086#1085#1090#1072#1082#1090#1085#1086#1081' '#1083#1080#1085#1080#1080
  end
  object eos: TEdit
    Left = 88
    Top = 5
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 215
    Top = 3
    Width = 122
    Height = 25
    Caption = #1047#1072#1076#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081
    TabOrder = 1
    OnClick = Button1Click
  end
  object eStyle: TEdit
    Left = 8
    Top = 59
    Width = 323
    Height = 21
    TabOrder = 2
  end
  object Button2: TButton
    Left = 256
    Top = 86
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object cbActive: TCheckBox
    Left = 8
    Top = 86
    Width = 97
    Height = 17
    Caption = #1042#1082#1083#1102#1095#1077#1085#1086
    TabOrder = 4
    OnClick = cbActiveClick
  end
end
