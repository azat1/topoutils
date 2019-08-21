object fFieldSetup: TfFieldSetup
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1086#1083#1077#1081
  ClientHeight = 475
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 356
    Width = 72
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1083#1072#1085#1072
  end
  object Label4: TLabel
    Left = 180
    Top = 356
    Width = 7
    Height = 13
    Caption = #1061
  end
  object Label5: TLabel
    Left = 280
    Top = 356
    Width = 14
    Height = 13
    Caption = #1089#1084
  end
  object Button1: TButton
    Left = 396
    Top = 440
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 492
    Top = 440
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object sgFields: TStringGrid
    Left = 0
    Top = 0
    Width = 603
    Height = 345
    Align = alTop
    ColCount = 2
    DefaultColWidth = 130
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    ParentFont = False
    PopupMenu = pm1
    TabOrder = 2
    ColWidths = (
      137
      332)
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 383
    Width = 305
    Height = 41
    Caption = #1042#1099#1074#1086#1076' '#1075#1077#1086#1076#1072#1085#1085#1099#1093
    TabOrder = 3
    object cbCoords: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
      TabOrder = 0
    end
    object cbAngles: TCheckBox
      Left = 144
      Top = 16
      Width = 153
      Height = 17
      Caption = #1059#1075#1083#1099' '#1080' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1103
      TabOrder = 1
    end
  end
  object ePlanSizeX: TEdit
    Left = 104
    Top = 352
    Width = 69
    Height = 21
    TabOrder = 4
    Text = '10'
  end
  object ePlanSizeY: TEdit
    Left = 192
    Top = 352
    Width = 85
    Height = 21
    TabOrder = 5
    Text = '10'
  end
  object pm1: TPopupMenu
    AutoHotkeys = maManual
    Left = 152
    Top = 85
    object N1: TMenuItem
      Caption = #1055#1083#1086#1097#1072#1076#1100' '#1091#1095#1072#1089#1090#1082#1072' 1'
      OnClick = N1Click
    end
    object N21: TMenuItem
      Caption = #1055#1083#1086#1097#1072#1076#1100' '#1091#1095#1072#1089#1090#1082#1072' 2'
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1050#1072#1076#1072#1089#1090#1088#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' '#1089#1090#1072#1088#1099#1081
      OnClick = N1Click
    end
    object N5: TMenuItem
      Caption = #1050#1072#1076#1072#1089#1090#1088#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' '#1085#1086#1074#1099#1081' 1'
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = #1050#1072#1076#1072#1089#1090#1088#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' '#1085#1086#1074#1099#1081' 2'
      OnClick = N1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N7: TMenuItem
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1091#1095#1072#1089#1090#1082#1072' '#1087#1086#1083#1085#1086#1077
      OnClick = N1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object N11: TMenuItem
      Caption = #1043#1088#1072#1085#1080#1094#1099' '#1080' '#1090#1086#1095#1082#1080' 1'
      OnClick = N1Click
    end
    object N12: TMenuItem
      Caption = #1043#1088#1072#1085#1080#1094#1099' '#1080' '#1090#1086#1095#1082#1080' 2'
      OnClick = N1Click
    end
    object N15: TMenuItem
      Caption = #1053#1086#1084#1077#1088' '#1082#1074#1072#1088#1090#1072#1083#1072
      OnClick = N1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
  end
end
