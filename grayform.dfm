object fGrayMaker: TfGrayMaker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074' '#1086#1076#1080#1085' '#1094#1074#1077#1090
  ClientHeight = 133
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 107
    Width = 26
    Height = 13
    Caption = #1062#1074#1077#1090
  end
  object rgTarget: TRadioGroup
    Left = 16
    Top = 8
    Width = 277
    Height = 81
    Caption = #1044#1080#1072#1087#1072#1079#1086#1085' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    Items.Strings = (
      #1042#1077#1089#1100' '#1089#1083#1086#1081
      #1042#1089#1102' '#1082#1072#1088#1090#1091)
    TabOrder = 0
  end
  object clbColor: TColorBox
    Left = 76
    Top = 103
    Width = 169
    Height = 22
    DefaultColorColor = clGray
    Selected = clGray
    ItemHeight = 16
    TabOrder = 1
  end
  object Button1: TButton
    Left = 332
    Top = 91
    Width = 105
    Height = 35
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 2
  end
end
