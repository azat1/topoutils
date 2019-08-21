object fCreateZone: TfCreateZone
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1086#1085#1099
  ClientHeight = 129
  ClientWidth = 446
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
    Left = 28
    Top = 8
    Width = 40
    Height = 13
    Caption = #1064#1080#1088#1080#1085#1072
  end
  object Label2: TLabel
    Left = 28
    Top = 48
    Width = 31
    Height = 13
    Caption = #1057#1090#1080#1083#1100
  end
  object Label3: TLabel
    Left = 80
    Top = 48
    Width = 53
    Height = 13
    Caption = #1085#1077' '#1074#1099#1073#1088#1072#1085
  end
  object eWidth: TEdit
    Left = 80
    Top = 5
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '2'
  end
  object Button1: TButton
    Left = 348
    Top = 80
    Width = 75
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 80
    Top = 67
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    TabOrder = 2
    OnClick = Button2Click
  end
end
