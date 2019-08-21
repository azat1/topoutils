object fPinCreate: TfPinCreate
  Left = 0
  Top = 0
  Caption = #1042#1089#1090#1072#1074#1082#1072' '#1089#1090#1086#1083#1073#1086#1074
  ClientHeight = 114
  ClientWidth = 409
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
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = #1057#1090#1080#1083#1100
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 60
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object Label3: TLabel
    Left = 176
    Top = 40
    Width = 55
    Height = 13
    Caption = #1044#1080#1089#1090#1072#1085#1094#1080#1103
  end
  object Label4: TLabel
    Left = 8
    Top = 95
    Width = 3
    Height = 13
  end
  object cbStyle: TComboBox
    Left = 54
    Top = 5
    Width = 347
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbStyleChange
  end
  object eCount: TEdit
    Left = 80
    Top = 37
    Width = 57
    Height = 21
    TabOrder = 1
    OnChange = eCountChange
  end
  object eDistance: TEdit
    Left = 245
    Top = 37
    Width = 68
    Height = 21
    TabOrder = 2
    OnChange = eDistanceChange
  end
  object cbMakeVector: TCheckBox
    Left = 8
    Top = 72
    Width = 161
    Height = 17
    Caption = #1057#1086#1079#1076#1072#1074#1072#1090#1100' '#1074#1077#1082#1090#1086#1088#1099
    TabOrder = 3
  end
  object Button1: TButton
    Left = 296
    Top = 80
    Width = 107
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
end
