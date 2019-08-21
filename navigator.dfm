object fNavigator: TfNavigator
  Left = 443
  Top = 227
  Width = 434
  Height = 339
  Caption = #1053#1072#1074#1080#1075#1072#1090#1086#1088
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
  object imMain: TImage
    Left = 0
    Top = 0
    Width = 426
    Height = 264
    Align = alClient
    OnMouseDown = imMainMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 426
    Height = 41
    Align = alBottom
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object sbCenter: TSpeedButton
      Left = 8
      Top = 8
      Width = 23
      Height = 22
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1090#1088' '#1085#1072#1074#1080#1075#1072#1090#1086#1088#1072' '#1087#1086' '#1082#1072#1088#1090#1077
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFF9FFFFFFFFFFFFFFF9FFFFFFFFFFFFFFF9FFFFFFFFFFFFF9F9F9F
        FFFFFFFFFFF999FFFFFFFFF9FFFF9FFF9FFFFFFF9FFFFFF9FFFF999999FFFF99
        9999FFFF9FFFFFF9FFFFFFF9FFFF9FFF9FFFFFFFFFF999FFFFFFFFFFFF9F9F9F
        FFFFFFFFFFFF9FFFFFFFFFFFFFFF9FFFFFFFFFFFFFFF9FFFFFFF}
      OnClick = sbCenterClick
    end
    object cbScale: TComboBox
      Left = 48
      Top = 8
      Width = 145
      Height = 21
      Hint = #1052#1072#1089#1096#1090#1072#1073
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbScaleChange
      Items.Strings = (
        '100'
        '500'
        '1000'
        '2000'
        '5000'
        '10000'
        '25000'
        '50000'
        '100000'
        '200000'
        '500000'
        '1000000')
    end
  end
end
