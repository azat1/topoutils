object fTHEditor: TfTHEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1058#1077#1086#1076#1086#1083#1080#1090#1085#1099#1081' '#1093#1086#1076
  ClientHeight = 309
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 41
    Width = 393
    Height = 227
    Align = alClient
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 268
    Width = 393
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 318
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object Button2: TButton
      Left = 214
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1050
      ModalResult = 1
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 41
    Align = alTop
    TabOrder = 2
  end
end
