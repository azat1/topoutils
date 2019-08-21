unit delo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ImgList, ComCtrls, ToolWin, Grids, Menus;

type
  TfDelo = class(TForm)
    sgFields: TStringGrid;
    ToolBar1: TToolBar;
    tbClear: TToolButton;
    tbSave: TToolButton;
    ImageList1: TImageList;
    tbOPen: TToolButton;
    Button1: TButton;
    Button2: TButton;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    cbTable: TComboBox;
    pmM: TPopupMenu;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTableChange(Sender: TObject);
    procedure sgFieldsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgFieldsClick(Sender: TObject);
    procedure sgFieldsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure N11Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    settings:TStringList;
    procedure LoadSetting;
    procedure FillGrid;
    procedure SaveSettings;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDelo: TfDelo;

implementation
uses frm, inifiles,addn, setup, Math;
{$R *.dfm}

procedure TfDelo.FormCreate(Sender: TObject);
begin
  LoadSetting;
end;

procedure TfDelo.LoadSetting;
var dbn,ps,secname:string;
    z:array [1..255] of char;
    mh:THandle;
    inf:Tinifile;
    m:TMenuItem;
    I:INTEGER;

begin
  dbn:=fSetup.leDatabasePath.Text;
  ADOConnection1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source='+dbn+
  ';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;'+
  'Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don''t Copy Locale on Compact=False;'+
  'Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False';
  try
    ADOConnection1.Open;
  except
    on e:Exception do ShowMessage('Ошибка открытя БД'#13#10+e.Message);
  end;
   ADOConnection1.GetTableNames(cbTable.Items);

  settings:=TStringList.Create;
  mh:=GetModuleHandle('MEZDEL.DLL');
  GetModuleFileName(mh,@z,255);
  ps:=ExtractFilePath(StrPas(@z));
  ps:=ps+'dbsetup.ini';
  inf:=TIniFile.Create(ps);
  secname:=gAddon.GISDatabase.DatabaseName;
  inf.ReadSectionValues(secname,settings);
  inf.Free;
  cbTable.Text:=settings.Values['DBTableName'];


  for i:=0 to MainForm.ComboBox1.Items.Count-1 do
  begin
    m:=TMenuItem.Create(self);
    m.Caption:=MainForm.ComboBox1.Items.Strings[i];
    m.OnClick:=N11Click;
    pmM.Items.Add(m);
  end;
end;

procedure TfDelo.FormShow(Sender: TObject);
begin
  cbTableChange(self);;
end;

procedure TfDelo.FillGrid;
var i,i1:integer;
    cb:TComboBox;
begin
//  cbTableChange(self);
  for i:=0 to ADOTable1.FieldCount-1 do
  begin
    sgFields.Cells[0,i+1]:=ADOTable1.Fields.Fields[i].FieldName;
    sgFields.Cells[1,i+1]:=settings.Values[ADOTable1.Fields.Fields[i].FieldName];
//)))))
  end;
end;

procedure TfDelo.cbTableChange(Sender: TObject);
begin
  ADOTable1.TableName:=cbTable.Text;
  try
    ADOTable1.Open;
    FillGrid;
  except
    on e:Exception do ShowMessage('Ошибка открытия таблицы: '+cbTable.Text+#13#10+e.Message);
  end;

end;

procedure TfDelo.sgFieldsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var  r:TRect;
begin
  //********
//  r:=sgFields.CellRect(ACol,ARow);

end;

procedure TfDelo.sgFieldsClick(Sender: TObject);
var x,y:integer;
begin
  //************

end;

procedure TfDelo.sgFieldsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var cb:TComboBox;
    i:integer;
begin
end;

procedure TfDelo.N11Click(Sender: TObject);
var n:TMenuItem;
begin
  //*************
  n:=TMenuItem( Sender);
  if n.Tag=1 then
  begin
    sgFields.Cells[1,sgFields.Row]:=sgFields.Cells[1,sgFields.Row]+'['+n.Caption+']';
  end else
  sgFields.Cells[1,sgFields.Row]:=sgFields.Cells[1,sgFields.Row]+n.Caption;

end;

procedure TfDelo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  SaveSettings;
end;

procedure TfDelo.SaveSettings;
var dbn,ps,secname:string;
    z:array [1..255] of char;
    mh:THandle;
    inf:Tinifile;
    m:TMenuItem;
    I:INTEGER;

begin

  mh:=GetModuleHandle('MEZDEL.DLL');
  GetModuleFileName(mh,@z,255);
  ps:=ExtractFilePath(StrPas(@z));
  ps:=ps+'dbsetup.ini';

  inf:=TIniFile.Create(ps);
  secname:=gAddon.GISDatabase.DatabaseName;

  for i:=1 to sgFields.RowCount-1 do
  begin
    if sgFields.Cells[0,i]<>'' then
    begin
      inf.WriteString(secname,sgFields.Cells[0,i],sgFields.Cells[1,i]);
    end;
  end;
  inf.WriteString(secname,'DBTableName',cbTable.Text);
  inf.Free;



end;

procedure TfDelo.Button1Click(Sender: TObject);
begin
  SaveSettings;
end;

end.
