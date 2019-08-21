object fSpecSemCopy: TfSpecSemCopy
  Left = 0
  Top = 0
  Width = 562
  Height = 357
  Caption = #1058#1086#1087#1086#1083#1086#1075#1080#1095#1077#1089#1082#1086#1077' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1077#1084#1072#1085#1090#1080#1082#1080
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
  object leLayerName: TLabeledEdit
    Left = 8
    Top = 24
    Width = 457
    Height = 21
    EditLabel.Width = 196
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1090#1080#1083#1100' '#1080#1089#1093#1086#1076#1085#1099#1093' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
    TabOrder = 0
  end
  object Button1: TButton
    Left = 472
    Top = 24
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1086#1088'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object sgFields: TStringGrid
    Left = 8
    Top = 120
    Width = 537
    Height = 129
    ColCount = 2
    DefaultColWidth = 250
    DefaultRowHeight = 16
    RowCount = 2
    TabOrder = 2
    OnClick = sgFieldsClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 56
    Width = 537
    Height = 41
    Caption = #1057#1087#1086#1089#1086#1073' '#1087#1086#1080#1089#1082#1072
    TabOrder = 3
    object cbContains: TCheckBox
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Caption = #1042#1083#1086#1078#1077#1085#1085#1099#1077' '#1086#1073#1098#1077#1082#1090#1099
      TabOrder = 0
    end
    object cbContained: TCheckBox
      Left = 168
      Top = 16
      Width = 153
      Height = 17
      Caption = #1057#1086#1076#1077#1088#1078#1072#1097#1080#1077' '#1086#1073#1098#1077#1082#1090#1099
      TabOrder = 1
    end
    object cbIntersected: TCheckBox
      Left = 344
      Top = 16
      Width = 177
      Height = 17
      Caption = #1055#1077#1088#1077#1089#1077#1082#1072#1102#1097#1080#1077#1089#1103' '#1086#1073#1098#1077#1082#1090#1099
      TabOrder = 2
    end
  end
  object Button2: TButton
    Left = 304
    Top = 268
    Width = 105
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 440
    Top = 268
    Width = 105
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 5
    OnClick = Button3Click
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 306
    Width = 554
    Height = 17
    Align = alBottom
    TabOrder = 6
  end
  object pmFields: TPopupMenu
    Left = 184
    Top = 264
    object N11: TMenuItem
      Caption = '1'
      OnClick = N11Click
    end
  end
end
