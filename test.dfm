object fTest: TfTest
  Left = 0
  Top = 0
  Width = 449
  Height = 250
  Caption = #1058#1077#1089#1090#1086#1074#1099#1077' '#1092#1091#1085#1082#1094#1080#1080
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
    Left = 64
    Top = 8
    Width = 31
    Height = 13
    Caption = 'RMask'
  end
  object Label2: TLabel
    Left = 228
    Top = 8
    Width = 15
    Height = 13
    Caption = 'Rel'
  end
  object Label3: TLabel
    Left = 60
    Top = 120
    Width = 27
    Height = 13
    Caption = 'Layer'
  end
  object cbMContains: TCheckBox
    Left = 60
    Top = 28
    Width = 97
    Height = 17
    Caption = 'Contains'
    TabOrder = 0
  end
  object cbMContained: TCheckBox
    Left = 60
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Contained'
    TabOrder = 1
  end
  object cbMIntersected: TCheckBox
    Left = 60
    Top = 68
    Width = 97
    Height = 17
    Caption = 'Intersected'
    TabOrder = 2
  end
  object cbContains: TCheckBox
    Left = 224
    Top = 28
    Width = 97
    Height = 17
    Caption = 'Contains'
    TabOrder = 3
  end
  object cbContained: TCheckBox
    Left = 224
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Contained'
    TabOrder = 4
  end
  object cbIntersected: TCheckBox
    Left = 224
    Top = 68
    Width = 97
    Height = 17
    Caption = 'Intersected'
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 56
    Top = 140
    Width = 293
    Height = 21
    TabOrder = 6
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 356
    Top = 140
    Width = 75
    Height = 25
    Caption = 'Select...'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 340
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Select'
    TabOrder = 8
    OnClick = Button2Click
  end
  object cbMTouched: TCheckBox
    Left = 60
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Touched'
    TabOrder = 9
  end
  object cbTouched: TCheckBox
    Left = 224
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Touched'
    TabOrder = 10
  end
end
