object fCoordEdit: TfCoordEdit
  Left = 0
  Top = 0
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  ClientHeight = 280
  ClientWidth = 427
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
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 55
    Height = 13
    Caption = #1069#1083#1083#1080#1087#1089#1086#1080#1076
  end
  object Label3: TLabel
    Left = 8
    Top = 96
    Width = 151
    Height = 13
    Caption = #1062#1077#1085#1090#1088#1072#1083#1100#1085#1099#1081' '#1084#1077#1088#1080#1076#1080#1072#1085', '#1075' '#1084' '#1089
  end
  object Label4: TLabel
    Left = 8
    Top = 123
    Width = 118
    Height = 13
    Caption = #1057#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1074#1086#1089#1090#1086#1082', '#1084
  end
  object Label5: TLabel
    Left = 8
    Top = 157
    Width = 112
    Height = 13
    Caption = #1057#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1089#1077#1074#1077#1088', '#1084
  end
  object Label6: TLabel
    Left = 8
    Top = 184
    Width = 45
    Height = 13
    Caption = #1052#1072#1089#1096#1090#1072#1073
  end
  object lDD: TLabel
    Left = 8
    Top = 216
    Width = 3
    Height = 13
  end
  object eName: TEdit
    Left = 87
    Top = 8
    Width = 332
    Height = 21
    TabOrder = 0
  end
  object cbDatumType: TComboBox
    Left = 87
    Top = 37
    Width = 210
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'WSG 84'
      #1050#1088#1072#1089#1086#1074#1089#1082#1080#1081' 1942')
  end
  object eCM: TEdit
    Left = 176
    Top = 93
    Width = 121
    Height = 21
    TabOrder = 2
    OnExit = eCMExit
  end
  object eFNorth: TEdit
    Left = 176
    Top = 154
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object eFEast: TEdit
    Left = 176
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Button1: TButton
    Left = 240
    Top = 240
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 344
    Top = 240
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object eScale: TEdit
    Left = 176
    Top = 181
    Width = 121
    Height = 21
    TabOrder = 7
  end
end
