object fZasechka: TfZasechka
  Left = 0
  Top = 0
  Caption = #1051#1080#1085#1077#1081#1085#1072#1103' '#1079#1072#1089#1077#1095#1082#1072
  ClientHeight = 164
  ClientWidth = 513
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 36
    Height = 13
    Caption = #1058#1086#1095#1082#1072'1'
  end
  object Label2: TLabel
    Left = 16
    Top = 38
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object Label3: TLabel
    Left = 152
    Top = 38
    Width = 6
    Height = 13
    Caption = 'Y'
  end
  object Label4: TLabel
    Left = 360
    Top = 38
    Width = 32
    Height = 13
    Caption = #1044#1083#1080#1085#1072
  end
  object Label5: TLabel
    Left = 16
    Top = 64
    Width = 36
    Height = 13
    Caption = #1058#1086#1095#1082#1072'2'
  end
  object Label6: TLabel
    Left = 16
    Top = 86
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object Label7: TLabel
    Left = 152
    Top = 86
    Width = 6
    Height = 13
    Caption = 'Y'
  end
  object Label8: TLabel
    Left = 360
    Top = 86
    Width = 32
    Height = 13
    Caption = #1044#1083#1080#1085#1072
  end
  object eX1: TEdit
    Left = 32
    Top = 35
    Width = 97
    Height = 21
    TabOrder = 0
  end
  object eY1: TEdit
    Left = 168
    Top = 35
    Width = 97
    Height = 21
    TabOrder = 1
  end
  object eL1: TEdit
    Left = 398
    Top = 35
    Width = 97
    Height = 21
    TabOrder = 2
    OnChange = eL1Change
  end
  object eX2: TEdit
    Left = 32
    Top = 83
    Width = 97
    Height = 21
    TabOrder = 3
  end
  object eY2: TEdit
    Left = 168
    Top = 83
    Width = 97
    Height = 21
    TabOrder = 4
  end
  object eL2: TEdit
    Left = 398
    Top = 83
    Width = 97
    Height = 21
    TabOrder = 5
    OnChange = eL1Change
  end
  object bSel1: TButton
    Left = 271
    Top = 33
    Width = 75
    Height = 25
    Caption = #1042#1079#1103#1090#1100' '#1074#1099#1076'.'
    TabOrder = 6
    OnClick = bSel1Click
  end
  object bSel2: TButton
    Left = 271
    Top = 81
    Width = 75
    Height = 25
    Caption = #1042#1079#1103#1090#1100' '#1074#1099#1076'.'
    TabOrder = 7
    OnClick = bSel2Click
  end
  object bMake1: TButton
    Left = 168
    Top = 120
    Width = 143
    Height = 32
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1082#1088#1072#1089#1085#1091#1102
    TabOrder = 8
    OnClick = bMake1Click
  end
  object bMake2: TButton
    Left = 352
    Top = 120
    Width = 143
    Height = 32
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1089#1080#1085#1102#1102
    TabOrder = 9
    OnClick = bMake2Click
  end
end
