object fObjectSelect: TfObjectSelect
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088#1082#1072' '#1086#1073#1098#1077#1082#1090#1086#1074
  ClientHeight = 227
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = #1057#1090#1080#1083#1080
  end
  object Label2: TLabel
    Left = 332
    Top = 11
    Width = 49
    Height = 13
    Caption = #1055#1077#1088#1080#1084#1077#1090#1088
  end
  object Label3: TLabel
    Left = 332
    Top = 38
    Width = 47
    Height = 13
    Caption = #1055#1083#1086#1097#1072#1076#1100
  end
  object Label4: TLabel
    Left = 332
    Top = 74
    Width = 25
    Height = 13
    Caption = #1055#1086#1083#1077
  end
  object Label5: TLabel
    Left = 330
    Top = 162
    Width = 49
    Height = 13
    Caption = #1044#1080#1072#1087#1072#1079#1086#1085
  end
  object clbStyles: TCheckListBox
    Left = 8
    Top = 27
    Width = 293
    Height = 146
    ItemHeight = 13
    TabOrder = 0
  end
  object cbPerimeterOp: TComboBox
    Left = 412
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = #1083#1102#1073#1086#1081
    Items.Strings = (
      #1083#1102#1073#1086#1081
      #1088#1072#1074#1077#1085
      #1073#1086#1083#1100#1096#1077
      #1084#1077#1085#1100#1096#1077
      #1084#1077#1078#1076#1091)
  end
  object ePerim1: TEdit
    Left = 576
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object ePerim2: TEdit
    Left = 660
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object cbSquareOp: TComboBox
    Left = 412
    Top = 35
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = #1083#1102#1073#1072#1103
    Items.Strings = (
      #1083#1102#1073#1072#1103
      #1088#1072#1074#1077#1085
      #1073#1086#1083#1100#1096#1077
      #1084#1077#1085#1100#1096#1077
      #1084#1077#1078#1076#1091)
  end
  object eSquare1: TEdit
    Left = 576
    Top = 35
    Width = 57
    Height = 21
    TabOrder = 5
    Text = '1'
  end
  object eSquare2: TEdit
    Left = 660
    Top = 35
    Width = 57
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object cbFieldOp: TComboBox
    Left = 492
    Top = 93
    Width = 93
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 7
    Text = #1083#1102#1073#1086#1077
    Items.Strings = (
      #1083#1102#1073#1086#1077
      #1088#1072#1074#1077#1085
      #1073#1086#1083#1100#1096#1077
      #1084#1077#1085#1100#1096#1077
      #1084#1077#1078#1076#1091)
  end
  object cbField: TComboBox
    Left = 332
    Top = 93
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    Text = 'cbField'
  end
  object cbFieldValue: TComboBox
    Left = 596
    Top = 93
    Width = 155
    Height = 21
    ItemHeight = 13
    TabOrder = 9
    Text = 'cbFieldValue'
  end
  object Button1: TButton
    Left = 632
    Top = 162
    Width = 119
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 10
    OnClick = Button1Click
  end
  object cbField2: TComboBox
    Left = 332
    Top = 120
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 11
    Text = 'cbField2'
  end
  object cbFieldOp2: TComboBox
    Left = 492
    Top = 120
    Width = 93
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 12
    Text = #1083#1102#1073#1086#1077
    Items.Strings = (
      #1083#1102#1073#1086#1077
      #1088#1072#1074#1077#1085
      #1073#1086#1083#1100#1096#1077
      #1084#1077#1085#1100#1096#1077
      #1084#1077#1078#1076#1091)
  end
  object cbFieldValue2: TComboBox
    Left = 596
    Top = 120
    Width = 155
    Height = 21
    ItemHeight = 13
    TabOrder = 13
    Text = 'cbFieldValue'
  end
  object cbRange: TComboBox
    Left = 404
    Top = 159
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 14
    Items.Strings = (
      #1074#1077#1079#1076#1077
      #1074#1087#1080#1089#1072#1085#1085#1099#1077
      #1074#1099#1076#1077#1083#1077#1085#1085#1099#1077)
  end
end
