object fTransformator: TfTransformator
  Left = 307
  Top = 264
  Width = 625
  Height = 332
  Caption = #1058#1088#1072#1085#1089#1092#1086#1088#1084#1072#1094#1080#1103' '#1086#1073#1098#1077#1082#1090#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bTransform: TButton
    Left = 472
    Top = 248
    Width = 137
    Height = 25
    Caption = #1058#1088#1072#1085#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 0
    OnClick = bTransformClick
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 292
    Width = 617
    Height = 13
    Align = alBottom
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 449
    Height = 121
    Caption = #1055#1086#1074#1086#1088#1086#1090
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 31
      Height = 13
      Caption = #1062#1077#1085#1090#1088
    end
    object leCenterX: TLabeledEdit
      Left = 8
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 7
      EditLabel.Height = 13
      EditLabel.Caption = 'X'
      TabOrder = 0
    end
    object leCenterY: TLabeledEdit
      Left = 8
      Top = 88
      Width = 121
      Height = 21
      EditLabel.Width = 7
      EditLabel.Height = 13
      EditLabel.Caption = 'Y'
      TabOrder = 1
    end
    object leAngle: TLabeledEdit
      Left = 136
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 75
      EditLabel.Height = 13
      EditLabel.Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072
      TabOrder = 2
    end
    object cbRotate: TCheckBox
      Left = 336
      Top = 16
      Width = 97
      Height = 17
      Caption = #1042#1082#1083#1102#1095#1077#1085#1086
      TabOrder = 3
    end
    object Button1: TButton
      Left = 136
      Top = 88
      Width = 97
      Height = 25
      Caption = #1042#1079#1103#1090#1100' '#1089' '#1082#1072#1088#1090#1099
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 152
    Width = 449
    Height = 121
    Caption = #1057#1084#1077#1097#1077#1085#1080#1077
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 104
      Height = 13
      Caption = #1042#1077#1083#1080#1095#1080#1085#1072' '#1089#1084#1077#1097#1077#1085#1080#1103
    end
    object leDX: TLabeledEdit
      Left = 8
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 7
      EditLabel.Height = 13
      EditLabel.Caption = 'X'
      TabOrder = 0
    end
    object leDY: TLabeledEdit
      Left = 8
      Top = 88
      Width = 121
      Height = 21
      EditLabel.Width = 7
      EditLabel.Height = 13
      EditLabel.Caption = 'Y'
      TabOrder = 1
    end
    object cbDelta: TCheckBox
      Left = 336
      Top = 16
      Width = 97
      Height = 17
      Caption = #1042#1082#1083#1102#1095#1077#1085#1086
      TabOrder = 2
    end
  end
end
