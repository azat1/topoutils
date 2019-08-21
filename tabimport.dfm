object fTabImport: TfTabImport
  Left = 0
  Top = 0
  Caption = #1055#1086#1084#1086#1097#1085#1080#1082' '#1080#1084#1087#1086#1088#1090#1072' TAB'
  ClientHeight = 125
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 79
    Height = 13
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083
  end
  object Button1: TButton
    Left = 160
    Top = 19
    Width = 120
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083'...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object mStatus: TMemo
    Left = 8
    Top = 50
    Width = 272
    Height = 67
    ReadOnly = True
    TabOrder = 1
  end
  object OpenDialog1: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' TAB|*.TAB'
    Left = 336
    Top = 24
  end
end
