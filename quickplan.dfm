object fQuickPlan: TfQuickPlan
  Left = 0
  Top = 0
  Caption = #1041#1099#1089#1090#1088#1099#1081' '#1087#1083#1072#1085' '#1091#1095#1072#1089#1090#1082#1072
  ClientHeight = 125
  ClientWidth = 444
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
    Top = 11
    Width = 71
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1083#1072#1085#1072' '
  end
  object Label2: TLabel
    Left = 287
    Top = 11
    Width = 11
    Height = 13
    Caption = #1089#1084
  end
  object Label3: TLabel
    Left = 183
    Top = 11
    Width = 6
    Height = 13
    Caption = #1061
  end
  object Button1: TButton
    Left = 304
    Top = 84
    Width = 123
    Height = 25
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object ePlanW: TEdit
    Left = 96
    Top = 8
    Width = 81
    Height = 21
    TabOrder = 1
    Text = '12'
  end
  object ePlanH: TEdit
    Left = 200
    Top = 8
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '12'
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'RTF'
    Filter = #1060#1072#1081#1083#1099' RTF|*.RTF|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Left = 256
    Top = 40
  end
end
