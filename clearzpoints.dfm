object fClearZPoints: TfClearZPoints
  Left = 0
  Top = 0
  Caption = #1054#1095#1080#1089#1090#1082#1072' '#1086#1090#1084#1077#1090#1086#1082' '#1074#1099#1089#1086#1090#1099
  ClientHeight = 268
  ClientWidth = 589
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
    Width = 210
    Height = 13
    Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1077' '#1084#1077#1078#1076#1091' '#1090#1086#1095#1082#1072#1084#1080
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 154
    Height = 13
    Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1088#1072#1079#1085#1080#1094#1072' '#1074#1099#1089#1086#1090' '
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 67
    Height = 13
    Caption = #1055#1086#1083#1077' '#1074#1099#1089#1086#1090#1099
  end
  object Label4: TLabel
    Left = 215
    Top = 238
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 8
    Top = 112
    Width = 144
    Height = 13
    Caption = #1053#1045' '#1091#1076#1072#1083#1103#1090#1100' '#1090#1086#1095#1082#1080' '#1089#1086' '#1089#1090#1080#1083#1077#1084
  end
  object eminDist: TEdit
    Left = 232
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object eMaxDZ: TEdit
    Left = 232
    Top = 45
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 408
    Top = 213
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 506
    Top = 213
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 3
  end
  object cbZField: TComboBox
    Left = 88
    Top = 77
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 4
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 257
    Width = 589
    Height = 11
    Align = alBottom
    TabOrder = 5
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 157
    Width = 185
    Height = 81
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
    Items.Strings = (
      #1042#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1086#1073#1098#1077#1082#1090#1099
      #1042#1089#1077' '#1086#1073#1098#1077#1082#1090#1099' '#1089#1083#1086#1103)
    TabOrder = 6
  end
  object cbExlStyle: TComboBox
    Left = 158
    Top = 109
    Width = 423
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'cbExlStyle'
  end
end
