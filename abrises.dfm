object fAbrises: TfAbrises
  Left = 192
  Top = 114
  AutoScroll = False
  Caption = #1040#1073#1088#1080#1089#1099
  ClientHeight = 561
  ClientWidth = 746
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
  object Label1: TLabel
    Left = 8
    Top = 72
    Width = 99
    Height = 13
    Caption = #1058#1086#1095#1082#1080'  '#1076#1083#1103' '#1072#1073#1088#1080#1089#1086#1074
  end
  object Label2: TLabel
    Left = 8
    Top = 344
    Width = 92
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088#1085#1099#1077' '#1083#1080#1085#1080#1080
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 145
    Height = 25
    Caption = #1057#1090#1080#1083#1080'...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object dgA: TDrawGrid
    Left = 175
    Top = 0
    Width = 571
    Height = 561
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultColWidth = 270
    DefaultRowHeight = 270
    FixedCols = 0
    RowCount = 200
    FixedRows = 0
    TabOrder = 1
    OnDrawCell = dgADrawCell
  end
  object clbPointList: TCheckListBox
    Left = 8
    Top = 88
    Width = 145
    Height = 249
    ItemHeight = 13
    TabOrder = 2
    OnClick = clbPointListClick
  end
  object clbSizes: TCheckListBox
    Left = 8
    Top = 368
    Width = 145
    Height = 153
    ItemHeight = 13
    TabOrder = 3
    OnClick = clbSizesClick
  end
  object Button2: TButton
    Left = 8
    Top = 528
    Width = 105
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 4
  end
  object Button3: TButton
    Left = 8
    Top = 40
    Width = 145
    Height = 25
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077
    TabOrder = 5
    OnClick = Button3Click
  end
end
