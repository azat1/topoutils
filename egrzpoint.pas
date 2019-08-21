unit egrzpoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DB, IBDatabase, IBCustomDataSet, IBQuery, ComCtrls;
const
  key='\Software\AzSoft\TOPOUTILS\EGRZPOINTS';
type
  TfEGRZPoint = class(TForm)
    Label1: TLabel;
    eDB: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    eKVNum: TEdit;
    Label2: TLabel;
    eUser: TEdit;
    Label3: TLabel;
    ePassword: TEdit;
    Label4: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label5: TLabel;
    ePSName: TEdit;
    Button4: TButton;
    eUSName: TEdit;
    Label6: TLabel;
    Button5: TButton;
    StringGrid1: TStringGrid;
    IBDatabase1: TIBDatabase;
    Label7: TLabel;
    cbField: TComboBox;
    IBQuery1: TIBQuery;
    IBTransaction1: TIBTransaction;
    IBQuery2: TIBQuery;
    IBQuery1X_GEOCOORD: TFloatField;
    IBQuery1Y_GEOCOORD: TFloatField;
    IBQuery1ID_GEOSUBST: TIBStringField;
    IBQuery1NUM_GEOPOINT: TIntegerField;
    IBQuery1TYPE_GEOPOINT: TIBStringField;
    IBQuery1TOCHN_GEOPOINT: TIBStringField;
    IBQuery1XCOORDDOC_GEOPOINT: TFloatField;
    IBQuery1YCOORDDOC_GEOPOINT: TFloatField;
    ProgressBar1: TProgressBar;
    CheckBox1: TCheckBox;
    IBQuery3: TIBQuery;
    ProgressBar2: TProgressBar;
    procedure Button3Click(Sender: TObject);
    procedure cbFieldChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    ppstl,upstl,pfield:string;
    procedure SAveParams;
    procedure LoadParams;
    procedure UpdateNames;
    procedure MakeImport;
    procedure ImportAll;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var params:TCreateParams);override;  
  end;

var
  fEGRZPoint: TfEGRZPoint;

implementation
uses registry, addn, Ingeo_TLB, selstyle, M2Addon, M2AddonD;
{$R *.dfm}

procedure TfEGRZPoint.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    eDB.Text:=OpenDialog1.FileName;
  end;
end;

procedure TfEGRZPoint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
  Action:=caFree;
end;

procedure TfEGRZPoint.FormShow(Sender: TObject);
begin
  LoadParams;
end;

procedure TfEGRZPoint.ImportAll;
var
  r,cc: Integer;
  s:tstringList;
  kvn:string;
begin
  IBDatabase1.DatabaseName:=eDB.Text;
  IBDatabase1.Params.Values['user_name']:=eUser.Text;
  IBDatabase1.Params.Values['password']:=ePassword.Text;
  try
  IBDatabase1.Open;
  except
    ShowMessage('Не удалось открыть БД');
  end;
  IBQuery3.Open;
  cc:=1;
  while not IBQuery3.Eof do
  begin
    IBQuery2.Close;
    IBQuery2.ParamByName('KN').AsString:=IBQuery3.FieldByName('KN_OBJ').AsString;
    eKVNum.Text:=IBQuery3.FieldByName('KN_OBJ').AsString;
    IBQuery2.Open;
    IBQuery1.Close;
    IBQuery1.ParamByName('GS').AsString:=IBQuery2.FieldByName('ID_GEOSUBST').AsString;
    IBQuery1.Open;
//  IBQuery1.Re
    r:=1;
    StringGrid1.RowCount:=2;
    StringGrid1.Cells[0,1]:='';
    StringGrid1.Cells[0,2]:='';
    StringGrid1.Cells[0,3]:='';
    StringGrid1.Cells[0,4]:='';
    StringGrid1.Cells[0,0]:='';
    while not IBQuery1.Eof do
    begin
      StringGrid1.RowCount:=StringGrid1.RowCount+1;
      StringGrid1.Cells[0,r]:=IntToStr(r);
      StringGrid1.Cells[1,r]:=IBQuery1TYPE_GEOPOINT.AsString+IBQuery1NUM_GEOPOINT.AsString;
      StringGrid1.Cells[2,r]:=IBQuery1Y_GEOCOORD.AsString;
      StringGrid1.Cells[3,r]:=IBQuery1X_GEOCOORD.AsString;
      StringGrid1.Cells[4,r]:=IBQuery1TOCHN_GEOPOINT.AsString;
      inc(r);
      IBQuery1.Next;
    end;
    MakeImport;
//    ProgressBar2.Position:=rOUND(cc*100/IBQuery3.RecordCount);
    Application.ProcessMessages;
    IBQuery3.Next;
//    inc(cc);
  end;
  IBDatabase1.Close;
end;

procedure TfEGRZPoint.LoadParams;
var r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(key,True);
  if r.ValueExists('DB') then eDB.Text:=r.ReadString('DB');
  if r.ValueExists('USER') then eUser.Text:=r.ReadString('USER');
  if r.ValueExists('PASS') then ePassword.Text:=r.ReadString('PASS');
//  if r.ValueExists('DB') then eDB.Text:=r.ReadString('DB');
  r.Free;
  ppstl:= gAddon2.UserProfile.Get(inupUser,'','EGRZIMP_PPSTL','');
  upstl:= gAddon2.UserProfile.Get(inupUser,'','EGRZIMP_UPSTL','');
  pfield:= gAddon2.UserProfile.Get(inupUser,'','EGRZIMP_PFIELD','');
  UpdateNames;
end;

procedure TfEGRZPoint.SAveParams;
var r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(key,True);
  r.WriteString('DB',eDB.Text);
  r.WriteString('USER',eUser.Text);
  r.WriteString('PASS',ePassword.Text);
  r.Free;
  gAddon2.UserProfile.Put(inupUser,'','EGRZIMP_PPSTL',ppstl);
  gAddon2.UserProfile.Put(inupUser,'','EGRZIMP_UPSTL',upstl);
  gAddon2.UserProfile.Put(inupUser,'','EGRZIMP_PFIELD',pfield);
end;

procedure TfEGRZPoint.UpdateNames;
var smt:IIngeoSemTables;
    st:IIngeoSemTable;
    i,ti:integer;
begin
  ePSName.Text:=GetStyleName(ppstl);
  eUSName.Text:=GetStyleName(upstl);
  cbField.Text:=pfield;
  if not gAddon2.ActiveDb.StyleExists(ppstl) then exit;
  smt:=gAddon2.ActiveDb.StyleFromID(ppstl).Layer.SemTables;
  cbField.Items.Clear;
  for i:=0 to smt.Count-1 do
  begin
    st:=smt.Item[i];
    for ti:=0 to st.FieldInfos.Count-1 do
    begin
      cbField.Items.Add(st.Name+'.'+st.FieldInfos.Item[ti].FieldName);
    end;
  end;
end;

procedure TfEGRZPoint.Button4Click(Sender: TObject);
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrOK then
  begin
    ppstl:=PM2ID(f.trv1.Selected.Data)^;
    UpdateNames;
  end;
  f.Free;
end;

procedure TfEGRZPoint.Button5Click(Sender: TObject);
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrOK then
  begin
    upstl:=PM2ID(f.trv1.Selected.Data)^;
    UpdateNames;
  end;
  f.Free;
end;

procedure TfEGRZPoint.Button2Click(Sender: TObject);
var r:integer;
begin
  if CheckBox1.Checked then
    ImportAll else
  begin
  IBDatabase1.DatabaseName:=eDB.Text;
  IBDatabase1.Params.Values['user_name']:=eUser.Text;
  IBDatabase1.Params.Values['password']:=ePassword.Text;
  try
  IBDatabase1.Open;
  except
    ShowMessage('Не удалось открыть БД');
  end;
  IBQuery2.Close;
  IBQuery2.ParamByName('KN').AsString:=eKVNum.Text;
  IBQuery2.Open;
  IBQuery1.Close;
  IBQuery1.ParamByName('GS').AsString:=IBQuery2.FieldByName('ID_GEOSUBST').AsString;
  IBQuery1.Open;
  r:=1;
  while not IBQuery1.Eof do
  begin
    StringGrid1.RowCount:=StringGrid1.RowCount+1;
    StringGrid1.Cells[0,r]:=IntToStr(r);
    StringGrid1.Cells[1,r]:=IBQuery1TYPE_GEOPOINT.AsString+IBQuery1NUM_GEOPOINT.AsString;
    StringGrid1.Cells[2,r]:=IBQuery1Y_GEOCOORD.AsString;
    StringGrid1.Cells[3,r]:=IBQuery1X_GEOCOORD.AsString;
    StringGrid1.Cells[4,r]:=IBQuery1TOCHN_GEOPOINT.AsString;
    inc(r);
    IBQuery1.Next;
  end;

  IBDatabase1.Close;
  end;
end;

procedure TfEGRZPoint.cbFieldChange(Sender: TObject);
begin
  pfield:=cbField.Text;
end;

procedure TfEGRZPoint.Button3Click(Sender: TObject);
begin
  MakeImport;
end;

procedure TfEGRZPoint.MakeImport;
var mobjs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    i,oc:integer;
    x,y,cv:double;
    lar,pstl,t,f:string;
begin
  i:=Pos('.',cbField.Text);
  if i=0 then exit;
  t:=Copy(cbField.Text,1,i-1);
  f:=Copy(cbField.Text,i+1,400);
  lar:=gAddon2.ActiveDb.StyleFromID(ppstl).Layer.ID;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  oc:=0;
  for i:=1 to StringGrid1.RowCount-1 do
  begin
    ProgressBar1.Position:=i*100 div StringGrid1.RowCount;
    if StringGrid1.Cells[0,i]='' then break;
    obj:=mobjs.AddObject(lar);
    if StringGrid1.Cells[4,i]='Достаточная' then pstl:=ppstl else pstl:=upstl;
    shp:=obj.Shapes.Insert(-1,pstl);
    cntp:=shp.Contour.Insert(-1);
    x:=StrToFloat(StringGrid1.Cells[2,i]);
    y:=StrToFloat(StringGrid1.Cells[3,i]);
    cntp.InsertVertex(-1,x,y,0);
    obj.SemData.SetValue(t,f,StringGrid1.Cells[1,i],0);
    inc(oc);
    if oc>200 then
    begin
      mobjs.UpdateChanges;
      oc:=0;
    end;
  end;
  mobjs.UpdateChanges;
end;

procedure TfEGRZPoint.CreateParams(var params: TCreateParams);
begin
  inherited;
  params.WndParent:=gAddon2.MainWindow.Handle;
end;

end.
