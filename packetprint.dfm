object fPacketPrint: TfPacketPrint
  Left = 225
  Top = 226
  Width = 356
  Height = 150
  Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' '
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
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 107
    Width = 348
    Height = 16
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 69
    EditLabel.Height = 13
    EditLabel.Caption = #1069#1082#1079#1077#1084#1087#1083#1103#1088#1086#1074
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 1
    Text = '1'
  end
  object Button1: TButton
    Left = 256
    Top = 72
    Width = 75
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object UpDown1: TUpDown
    Left = 129
    Top = 24
    Width = 15
    Height = 21
    Associate = LabeledEdit1
    Min = 1
    Position = 1
    TabOrder = 3
    Wrap = False
  end
end
