object fPolygonCreator: TfPolygonCreator
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 199
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1084#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082#1086#1074
  ClientHeight = 133
  ClientWidth = 479
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
    Left = 139
    Top = 8
    Width = 36
    Height = 13
    Caption = #1056#1072#1076#1080#1091#1089
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Caption = #1063#1080#1089#1083#1086' '#1091#1075#1083#1086#1074
  end
  object Label3: TLabel
    Left = 8
    Top = 35
    Width = 75
    Height = 13
    Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072
  end
  object Label4: TLabel
    Left = 139
    Top = 35
    Width = 32
    Height = 13
    Caption = #1062#1077#1085#1090#1088
  end
  object Label5: TLabel
    Left = 177
    Top = 35
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object Label6: TLabel
    Left = 287
    Top = 35
    Width = 6
    Height = 13
    Caption = 'Y'
  end
  object Label7: TLabel
    Left = 8
    Top = 64
    Width = 31
    Height = 13
    Caption = #1057#1090#1080#1083#1100
  end
  object Button1: TButton
    Left = 223
    Top = 104
    Width = 75
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 396
    Top = 104
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button2Click
  end
  object eR: TEdit
    Left = 181
    Top = 5
    Width = 36
    Height = 21
    TabOrder = 2
    Text = '5'
    OnChange = ePCountExit
  end
  object cbRType: TComboBox
    Left = 223
    Top = 5
    Width = 134
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
    Text = #1042#1087#1080#1089#1072#1085#1085#1086#1081' '#1086#1082#1088#1091#1078#1085#1086#1089#1090#1080' '
    OnChange = ePCountExit
    Items.Strings = (
      #1042#1087#1080#1089#1072#1085#1085#1086#1081' '#1086#1082#1088#1091#1078#1085#1086#1089#1090#1080' '
      #1054#1087#1080#1089#1072#1085#1085#1086#1081' '#1086#1082#1088#1091#1078#1085#1086#1089#1090#1080)
  end
  object ePCount: TEdit
    Left = 76
    Top = 5
    Width = 45
    Height = 21
    TabOrder = 4
    Text = '3'
    OnExit = ePCountExit
  end
  object UpDown1: TUpDown
    Left = 121
    Top = 5
    Width = 12
    Height = 21
    Associate = ePCount
    Min = 3
    Position = 3
    TabOrder = 5
    OnChanging = UpDown1Changing
  end
  object eAngle: TEdit
    Left = 89
    Top = 32
    Width = 32
    Height = 21
    TabOrder = 6
    Text = '0'
    OnChange = ePCountExit
  end
  object eX: TEdit
    Left = 189
    Top = 32
    Width = 92
    Height = 21
    TabOrder = 7
    OnChange = ePCountExit
  end
  object eY: TEdit
    Left = 299
    Top = 32
    Width = 86
    Height = 21
    TabOrder = 8
    OnChange = ePCountExit
  end
  object Button3: TButton
    Left = 391
    Top = 34
    Width = 75
    Height = 18
    Caption = #1059#1082#1072#1079#1072#1090#1100
    TabOrder = 9
    OnClick = Button3Click
  end
  object cbStyle: TComboBox
    Left = 56
    Top = 64
    Width = 415
    Height = 21
    ItemHeight = 13
    TabOrder = 10
    OnChange = cbStyleChange
  end
end
