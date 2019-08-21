object fVectorRotater: TfVectorRotater
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1088#1072#1097#1077#1085#1080#1077' '#1074#1077#1082#1090#1086#1088#1086#1074
  ClientHeight = 356
  ClientWidth = 402
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
    Top = 20
    Width = 42
    Height = 13
    Caption = #1059#1075#1086#1083', '#1075#1088
  end
  object eAngle: TEdit
    Left = 76
    Top = 17
    Width = 97
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object bRotate: TButton
    Left = 248
    Top = 15
    Width = 133
    Height = 42
    Caption = #1055#1086#1074#1077#1088#1085#1091#1090#1100
    TabOrder = 1
    OnClick = bRotateClick
  end
  object Button1: TButton
    Left = 164
    Top = 111
    Width = 217
    Height = 42
    Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074#1089#1077' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086' '#1085#1072#1087#1088#1072#1074#1086
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 164
    Top = 231
    Width = 217
    Height = 42
    Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074#1089#1077' '#1074#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086' '#1074#1074#1077#1088#1093
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 164
    Top = 295
    Width = 217
    Height = 42
    Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074#1089#1077' '#1074#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086' '#1074#1085#1080#1079
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 164
    Top = 167
    Width = 217
    Height = 42
    Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074#1089#1077' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086' '#1085#1072#1083#1077#1074#1086
    TabOrder = 5
    OnClick = Button4Click
  end
end
