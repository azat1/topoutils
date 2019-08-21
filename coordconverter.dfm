object fCoordConverter: TfCoordConverter
  Left = 510
  Top = 351
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  ClientHeight = 344
  ClientWidth = 511
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 36
    Height = 13
    Caption = #1058#1086#1095#1082#1072'1'
  end
  object Label2: TLabel
    Left = 8
    Top = 68
    Width = 36
    Height = 13
    Caption = #1058#1086#1095#1082#1072'2'
  end
  object Label7: TLabel
    Left = 24
    Top = 224
    Width = 3
    Height = 13
  end
  object lParams: TLabel
    Left = 8
    Top = 174
    Width = 3
    Height = 13
  end
  object Label8: TLabel
    Left = 8
    Top = 94
    Width = 36
    Height = 13
    Caption = #1058#1086#1095#1082#1072'3'
  end
  object Label9: TLabel
    Left = 24
    Top = 173
    Width = 36
    Height = 13
    Caption = 'X1=X0*'
  end
  object Label10: TLabel
    Left = 187
    Top = 173
    Width = 26
    Height = 13
    Caption = '+ Y0*'
  end
  object Label11: TLabel
    Left = 339
    Top = 173
    Width = 6
    Height = 13
    Caption = '+'
  end
  object Label12: TLabel
    Left = 24
    Top = 200
    Width = 36
    Height = 13
    Caption = 'Y1=X0*'
  end
  object Label13: TLabel
    Left = 187
    Top = 200
    Width = 26
    Height = 13
    Caption = '+ Y0*'
  end
  object Label14: TLabel
    Left = 339
    Top = 200
    Width = 6
    Height = 13
    Caption = '+'
  end
  object GroupBox1: TGroupBox
    Left = 52
    Top = 4
    Width = 201
    Height = 117
    Caption = #1048#1089#1093#1086#1076#1085#1072#1103
    TabOrder = 0
    object Label3: TLabel
      Left = 40
      Top = 16
      Width = 7
      Height = 13
      Caption = 'X'
    end
    object Label4: TLabel
      Left = 136
      Top = 16
      Width = 7
      Height = 13
      Caption = 'Y'
    end
    object eSX1: TEdit
      Left = 4
      Top = 32
      Width = 89
      Height = 21
      TabOrder = 0
    end
    object eSY1: TEdit
      Left = 100
      Top = 32
      Width = 89
      Height = 21
      TabOrder = 1
    end
    object eSX2: TEdit
      Left = 4
      Top = 60
      Width = 89
      Height = 21
      TabOrder = 2
    end
    object eSY2: TEdit
      Left = 100
      Top = 60
      Width = 89
      Height = 21
      TabOrder = 3
    end
    object eSX3: TEdit
      Left = 5
      Top = 87
      Width = 89
      Height = 21
      TabOrder = 4
    end
    object eSY3: TEdit
      Left = 101
      Top = 87
      Width = 89
      Height = 21
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 260
    Top = 4
    Width = 201
    Height = 117
    Caption = #1058#1088#1077#1073#1091#1077#1084#1072#1103
    TabOrder = 1
    object Label5: TLabel
      Left = 40
      Top = 16
      Width = 7
      Height = 13
      Caption = 'X'
    end
    object Label6: TLabel
      Left = 136
      Top = 16
      Width = 7
      Height = 13
      Caption = 'Y'
    end
    object eDX1: TEdit
      Left = 4
      Top = 32
      Width = 89
      Height = 21
      TabOrder = 0
    end
    object eDY1: TEdit
      Left = 100
      Top = 32
      Width = 89
      Height = 21
      TabOrder = 1
    end
    object eDX2: TEdit
      Left = 4
      Top = 60
      Width = 89
      Height = 21
      TabOrder = 2
    end
    object eDY2: TEdit
      Left = 100
      Top = 60
      Width = 89
      Height = 21
      TabOrder = 3
    end
    object eDY3: TEdit
      Left = 99
      Top = 87
      Width = 89
      Height = 21
      TabOrder = 4
    end
    object eDX3: TEdit
      Left = 3
      Top = 87
      Width = 89
      Height = 21
      TabOrder = 5
    end
  end
  object Button1: TButton
    Left = 396
    Top = 276
    Width = 107
    Height = 25
    Caption = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 396
    Top = 311
    Width = 107
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 280
    Top = 252
    Width = 41
    Height = 25
    Caption = 'Button3'
    TabOrder = 4
    Visible = False
    OnClick = Button3Click
  end
  object cbAllObjects: TCheckBox
    Left = 8
    Top = 127
    Width = 185
    Height = 17
    Caption = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1086#1073#1098#1077#1082#1090#1099
    TabOrder = 5
  end
  object ListBox1: TListBox
    Left = 8
    Top = 244
    Width = 249
    Height = 92
    ItemHeight = 13
    TabOrder = 6
  end
  object cbKoeff: TCheckBox
    Left = 8
    Top = 147
    Width = 273
    Height = 17
    Caption = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1075#1086#1090#1086#1074#1099#1084' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072#1084
    TabOrder = 7
  end
  object eA1: TEdit
    Left = 74
    Top = 170
    Width = 107
    Height = 21
    TabOrder = 8
  end
  object eB1: TEdit
    Left = 226
    Top = 170
    Width = 107
    Height = 21
    TabOrder = 9
  end
  object eC1: TEdit
    Left = 360
    Top = 170
    Width = 107
    Height = 21
    TabOrder = 10
  end
  object eA2: TEdit
    Left = 74
    Top = 197
    Width = 107
    Height = 21
    TabOrder = 11
  end
  object eB2: TEdit
    Left = 226
    Top = 197
    Width = 107
    Height = 21
    TabOrder = 12
  end
  object eC2: TEdit
    Left = 360
    Top = 197
    Width = 107
    Height = 21
    TabOrder = 13
  end
  object cbReverse: TCheckBox
    Left = 263
    Top = 127
    Width = 198
    Height = 17
    Caption = #1054#1073#1088#1072#1090#1085#1086#1077' '#1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077
    TabOrder = 14
  end
end
