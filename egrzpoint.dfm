object fEGRZPoint: TfEGRZPoint
  Left = 0
  Top = 0
  Caption = #1048#1079#1074#1083#1077#1095#1077#1085#1080#1077' '#1045#1043#1056#1047' '#1090#1086#1095#1077#1082
  ClientHeight = 379
  ClientWidth = 690
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
    Left = 12
    Top = 8
    Width = 14
    Height = 13
    Caption = #1041#1044
  end
  object Label2: TLabel
    Left = 12
    Top = 56
    Width = 82
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1082#1074#1072#1088#1090#1072#1083#1072
  end
  object Label3: TLabel
    Left = 244
    Top = 56
    Width = 93
    Height = 13
    Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object Label4: TLabel
    Left = 360
    Top = 56
    Width = 37
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object Label5: TLabel
    Left = 12
    Top = 100
    Width = 123
    Height = 13
    Caption = #1057#1083#1086#1081' '#1090#1086#1095#1077#1082' '#1091#1090#1086#1095#1085#1077#1085#1085#1099#1093
  end
  object Label6: TLabel
    Left = 12
    Top = 144
    Width = 139
    Height = 13
    Caption = #1057#1083#1086#1081' '#1090#1086#1095#1077#1082' '#1053#1045' '#1091#1090#1086#1095#1085#1077#1085#1085#1099#1093
  end
  object Label7: TLabel
    Left = 12
    Top = 184
    Width = 97
    Height = 13
    Caption = #1055#1086#1083#1077' '#1085#1086#1084#1077#1088#1072' '#1090#1086#1095#1082#1080
  end
  object eDB: TEdit
    Left = 12
    Top = 24
    Width = 573
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 596
    Top = 24
    Width = 75
    Height = 25
    Caption = #1054#1073#1079#1086#1088'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object eKVNum: TEdit
    Left = 12
    Top = 72
    Width = 161
    Height = 21
    TabOrder = 2
  end
  object eUser: TEdit
    Left = 244
    Top = 72
    Width = 105
    Height = 21
    TabOrder = 3
    Text = 'SYSDBA'
  end
  object ePassword: TEdit
    Left = 360
    Top = 72
    Width = 105
    Height = 21
    TabOrder = 4
    Text = 'masterkey'
  end
  object Button2: TButton
    Left = 480
    Top = 68
    Width = 97
    Height = 37
    Caption = #1048#1079#1074#1083#1077#1095#1100
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 592
    Top = 68
    Width = 75
    Height = 37
    Caption = #1048#1084#1087#1086#1088#1090
    TabOrder = 6
    OnClick = Button3Click
  end
  object ePSName: TEdit
    Left = 12
    Top = 116
    Width = 561
    Height = 21
    TabOrder = 7
  end
  object Button4: TButton
    Left = 580
    Top = 116
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1086#1088'...'
    TabOrder = 8
    OnClick = Button4Click
  end
  object eUSName: TEdit
    Left = 12
    Top = 160
    Width = 561
    Height = 21
    TabOrder = 9
  end
  object Button5: TButton
    Left = 580
    Top = 160
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1086#1088'...'
    TabOrder = 10
    OnClick = Button5Click
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 236
    Width = 690
    Height = 126
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultColWidth = 100
    DefaultRowHeight = 14
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
  end
  object cbField: TComboBox
    Left = 12
    Top = 204
    Width = 281
    Height = 21
    ItemHeight = 13
    TabOrder = 12
    OnChange = cbFieldChange
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 362
    Width = 690
    Height = 17
    Align = alBottom
    TabOrder = 13
  end
  object CheckBox1: TCheckBox
    Left = 324
    Top = 198
    Width = 293
    Height = 17
    Caption = #1048#1079#1074#1083#1077#1082#1072#1090#1100' '#1080' '#1080#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1082#1074#1072#1088#1090#1072#1083#1099
    TabOrder = 14
  end
  object ProgressBar2: TProgressBar
    Left = 324
    Top = 221
    Width = 358
    Height = 9
    TabOrder = 15
  end
  object OpenDialog1: TOpenDialog
    Filter = #1041#1072#1079#1072' Interbase|*.GDB'
    Left = 156
    Top = 80
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'C:\cadstr\SQLBase\CADASTER.GDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    SQLDialect = 1
    Left = 408
    Top = 188
  end
  object IBQuery1: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    SQL.Strings = (
      
        'select X_GEOCOORD,Y_GEOCOORD,ID_GEOSUBST, num_GEOPOINT,TYPE_GEOP' +
        'OINT,TOCHN_GEOPOINT,XCOORDDOC_GEOPOINT,YCOORDDOC_GEOPOINT'
      
        'from geopoint,geocoord where (geocoord.ID_GEOCOORD=geopoint.ID_G' +
        'EOCOORD)'
      'and (geocoord.ID_GEOSUBST=:GS) and (STATUS_GEOPOINT=5)')
    Left = 472
    Top = 188
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'GS'
        ParamType = ptUnknown
      end>
    object IBQuery1X_GEOCOORD: TFloatField
      FieldName = 'X_GEOCOORD'
      Origin = 'GEOCOORD.X_GEOCOORD'
    end
    object IBQuery1Y_GEOCOORD: TFloatField
      FieldName = 'Y_GEOCOORD'
      Origin = 'GEOCOORD.Y_GEOCOORD'
    end
    object IBQuery1ID_GEOSUBST: TIBStringField
      FieldName = 'ID_GEOSUBST'
      Origin = 'GEOCOORD.ID_GEOSUBST'
      Required = True
      FixedChar = True
      Size = 10
    end
    object IBQuery1NUM_GEOPOINT: TIntegerField
      FieldName = 'NUM_GEOPOINT'
      Origin = 'GEOPOINT.NUM_GEOPOINT'
    end
    object IBQuery1TYPE_GEOPOINT: TIBStringField
      FieldName = 'TYPE_GEOPOINT'
      Origin = 'GEOPOINT.TYPE_GEOPOINT'
      FixedChar = True
      Size = 1
    end
    object IBQuery1TOCHN_GEOPOINT: TIBStringField
      FieldName = 'TOCHN_GEOPOINT'
      Origin = 'GEOPOINT.TOCHN_GEOPOINT'
      Size = 45
    end
    object IBQuery1XCOORDDOC_GEOPOINT: TFloatField
      FieldName = 'XCOORDDOC_GEOPOINT'
      Origin = 'GEOPOINT.XCOORDDOC_GEOPOINT'
    end
    object IBQuery1YCOORDDOC_GEOPOINT: TFloatField
      FieldName = 'YCOORDDOC_GEOPOINT'
      Origin = 'GEOPOINT.YCOORDDOC_GEOPOINT'
    end
  end
  object IBTransaction1: TIBTransaction
    Left = 560
    Top = 192
  end
  object IBQuery2: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    SQL.Strings = (
      
        'select KN_OBJ,TYPE_OBJ,ID_GEOSUBST,IDSUBST_GEOSUBST,ID_OBJ from ' +
        'geosubst,obj where (obj.ID_OBJ=IDSUBST_GEOSUBST) AND'
      '(KN_OBJ=:KN)')
    Left = 508
    Top = 188
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'KN'
        ParamType = ptUnknown
      end>
  end
  object IBQuery3: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    SQL.Strings = (
      
        'select KN_OBJ,TYPE_OBJ,ID_GEOSUBST,IDSUBST_GEOSUBST,ID_OBJ from ' +
        'geosubst,obj where (obj.ID_OBJ=IDSUBST_GEOSUBST) AND'
      '(TYPE_OBJ=505)')
    Left = 612
    Top = 192
  end
end
