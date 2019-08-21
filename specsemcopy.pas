unit specsemcopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Ingeo_TLB, Menus, ComCtrls;

type
  TfSpecSemCopy = class(TForm)
    leLayerName: TLabeledEdit;
    Button1: TButton;
    sgFields: TStringGrid;
    GroupBox1: TGroupBox;
    cbContains: TCheckBox;
    cbContained: TCheckBox;
    cbIntersected: TCheckBox;
    Button2: TButton;
    pmFields: TPopupMenu;
    N11: TMenuItem;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure sgFieldsClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    slar,sstl:string;
    cnt1,cnt2,cnt3:integer;
    gmobjs:IIngeoMapObjects;
    { Private declarations }
    procedure LoadFields;
    procedure LoadFields2;
    procedure MakeWork;
    procedure MakeOneCopy(obj:IIngeoMapObject);
    procedure CopyFields(dobj,sobj:IIngeoMapObject);
    procedure DivideField(s:string;out t,f:string);

  public
    { Public declarations }
  end;

var
  fSpecSemCopy: TfSpecSemCopy;

implementation
uses addn,selstyle, M2Addon, M2AddonD;
{$R *.dfm}

procedure TfSpecSemCopy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfSpecSemCopy.FormShow(Sender: TObject);
begin
//  gAddon2.
  windows.SetParent(Handle,gAddon2.MainWindow.Handle);
  sgFields.Cells[0,0]:='Поле исходного объекта';
  sgFields.Cells[1,0]:='Целевое поле объекта';
  LoadFields2;
end;

procedure TfSpecSemCopy.Button1Click(Sender: TObject);
var f:TfSelectStyle;
    s:string;
    stl:IIngeoStyle;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrOk then
  begin
    sstl:=pm2id(f.trv1.Selected.data)^;
    stl:=Gaddon2.ActiveDb.StyleFromID(sstl);
    slar:=gAddon2.ActiveDb.StyleFromID(sstl).Layer.ID;
    leLayerName.Text:=stl.Layer.Map.Name+'\'+stl.Layer.Name+'\'+stl.Name;
    LoadFields;
  end;
end;

procedure TfSpecSemCopy.LoadFields;
var st:IIngeoSemTables;
    i,t:integer;
    sst:IIngeoSemTable;
    fn:string;
begin
  sgFields.RowCount:=2;
  st:=gAddon2.ActiveDb.LayerFromID(slar).SemTables;
  for i:=0 to st.Count-1 do
  begin
    sst:=st.Item[i];
    for t:=0 to sst.FieldInfos.Count-1 do
    begin
      fn:=sst.Name+'.'+sst.FieldInfos.Item[t].FieldName;
      sgFields.RowCount:=sgFields.RowCount+1;
      sgFields.Cells[0,sgFields.RowCount-2]:=fn;
//      cbZ.Items.Add(fn);
    end;
  end;
//  cbName.Items:=cbZ.Items;
end;

procedure TfSpecSemCopy.LoadFields2;
var st:IIngeoSemTables;
    i,t:integer;
    sst:IIngeoSemTable;
    fn:string;
    pmm:TMenuItem;
begin
  pmFields.Items.Clear;

  st:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.SemTables;
  for i:=0 to st.Count-1 do
  begin
    sst:=st.Item[i];
    for t:=0 to sst.FieldInfos.Count-1 do
    begin
      fn:=sst.Name+'.'+sst.FieldInfos.Item[t].FieldName;
//      sgFields.RowCount:=sgFields.RowCount+1;
      pmm:=TMenuItem.Create(self);
      pmm.Caption:=fn;
      pmm.OnClick:=N11Click;
      pmFields.Items.Add(pmm);
//      sgFields.Cells[0,sgFields.RowCount-2]:=fn;
//      cbZ.Items.Add(fn);
    end;
  end;
//  cbName.Items:=cbZ.Items;
end;

procedure TfSpecSemCopy.N11Click(Sender: TObject);
var zz:TMenuItem;
begin
//....
  zz:=Sender as TMenuItem;
  sgFields.Cells[1,sgFields.Row]:=zz.Caption;
end;

procedure TfSpecSemCopy.sgFieldsClick(Sender: TObject);
var x,y:integer;
    tr:TRect;
    tpp:TPoint;
begin
  tr:=sgFields.CellRect(1,sgFields.Row);
  tpp:=sgFields.ClientToScreen(Point(tr.Left,tr.Bottom));
//  sgFields.MouseCoord()
  pmFields.Popup(tpp.X,tpp.Y);
end;

procedure TfSpecSemCopy.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TfSpecSemCopy.Button2Click(Sender: TObject);
begin
  MakeWork;
end;

procedure TfSpecSemCopy.MakeWork;
var i:integer;
    obj:IIngeoMapObject;
begin
  gmobjs:=gAddon2.ActiveDb.MapObjects;
  cnt1:=0;cnt2:=0;cnt3:=0;
  if sstl='' then
  begin
    ShowMessage('Стиль не выбран!');
    exit;
  end;
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    ProgressBar1.Position:=i*100 div gAddon2.Selection.Count;
    obj:=gmobjs.GetObject(gAddon2.Selection.IDs[i]);
    MakeOneCopy(obj);
  end;
  gmobjs.UpdateChanges;
  ShowMessage(format('%d;%d;%d',[cnt1,cnt2,cnt3]));
end;

procedure TfSpecSemCopy.MakeOneCopy(obj: IIngeoMapObject);
var flag:integer;
    mq:IIngeoMapObjectsQuery;
    ilar,iobj:WideString;
    iss:integer;
    obj2:IIngeoMapObject;
begin
  flag:=0;
  if cbContains.Checked then
  begin
  mq:=gAddon2.ActiveDb.MapObjects.QueryByObject(slar,obj.ID,incrContains,incrContains);
  while not mq.EOF do
  begin
    mq.Fetch(ilar,iobj,iss);
    obj2:=gmobjs.GetObject(iobj);
    if obj2.ID=obj.ID then continue;
    CopyFields(obj,obj2);
    inc(cnt1);
    exit;
  end;
  end;

  if cbContained.Checked then
  begin
  mq:=gAddon2.ActiveDb.MapObjects.QueryByObject(slar,obj.ID,incrContained,incrContained);
  while not mq.EOF do
  begin
    mq.Fetch(ilar,iobj,iss);
    obj2:=gmobjs.GetObject(iobj);
    if obj2.ID=obj.ID then continue;
    CopyFields(obj,obj2);
    inc(cnt2);
    exit;
  end;
  end;

  if cbIntersected.Checked then
  begin
  mq:=gAddon2.ActiveDb.MapObjects.QueryByObject(slar,obj.ID,incrIntersected,incrIntersected);
  while not mq.EOF do
  begin
    mq.Fetch(ilar,iobj,iss);
    obj2:=gmobjs.GetObject(iobj);
    if obj2.ID=obj.ID then continue;
    CopyFields(obj,obj2);
    inc(cnt3);
    exit;
  end;
  end;
end;

procedure TfSpecSemCopy.CopyFields(dobj, sobj: IIngeoMapObject);
var i:integer;
    dfld,sfld,st,sf,df,dt:string;
begin
   for i:=1 to sgFields.RowCount-2 do
   begin
     dfld:=sgFields.Cells[1,i];
     if dfld='' then continue;
     sfld:=sgFields.Cells[0,i];
     DivideField(dfld,dt,df);
     DivideField(sfld,st,sf);
     try
       dobj.SemData.SetValue(dt,df,sobj.SemData.GetValue(st,sf,0),0);
     except
     end;
   end;
end;

procedure TfSpecSemCopy.DivideField(s: string; out t, f: string);
var c:integer;
begin
  c:=Pos('.',s);
  t:=Copy(s,1,c-1);
  f:=Copy(s,c+1,300);
end;

end.
