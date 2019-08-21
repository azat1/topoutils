object fRasterChange: TfRasterChange
  Left = 0
  Top = 0
  Caption = #1057#1076#1074#1080#1075' '#1088#1072#1089#1090#1088#1086#1074
  ClientHeight = 409
  ClientWidth = 448
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
    Left = 280
    Top = 8
    Width = 55
    Height = 13
    Caption = #1057#1076#1074#1080#1075' '#1087#1086' X'
  end
  object Label2: TLabel
    Left = 280
    Top = 56
    Width = 55
    Height = 13
    Caption = #1057#1076#1074#1080#1075' '#1087#1086' Y'
  end
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 0
    Width = 241
    Height = 409
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
  end
  object eX: TEdit
    Left = 280
    Top = 27
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object eY: TEdit
    Left = 280
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 296
    Top = 320
    Width = 136
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 296
    Top = 368
    Width = 136
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 4
    OnClick = Button2Click
  end
end
