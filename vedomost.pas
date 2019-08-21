unit vedomost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DllForm, Excel_TLB, Ingeo_TLB, M2Addon;

type
  TfVedomost = class(TM2AddonForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cbTitleField: TComboBox;
    cbUsePoints: TCheckBox;
    Label2: TLabel;
    eStyleName: TEdit;
    cbPointField: TComboBox;
    Label3: TLabel;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    ex:variant;
    { Private declarations }
    procedure MakeVedomost;
    procedure Loadfields;
    procedure Loadfields2;
    procedure OutMapObject(ex,ws:variant;imobj: IIngeoMapObject);
    procedure LoadParams;
    procedure SaveParams;
    procedure LoadPoints;
    procedure AddVPoint(ax,ay:double;pn:string);
    function GetPName(ax,ay:double):string;
  public
    x,y:array [0..10000] of double;
    n:array [0..10000] of string;
    xycount:integer;
    pstyle,ptn,pfn:string;
    { Public declarations }
  end;

var
  fVedomost: TfVedomost;

implementation

uses ComObj, addn, prefsaver, selstyle;

{$R *.dfm}

procedure TfVedomost.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfVedomost.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
  fVedomost:=nil;
  Action:=caFree;
end;

procedure TfVedomost.Button1Click(Sender: TObject);
begin
  MakeVedomost;
end;

procedure TfVedomost.MakeVedomost;
var ws:variant;
    i:integer;
    mobj:IIngeoMapObject;
begin
  if cbUsePoints.Checked then LoadPoints else xycount:=0;
  ex:=CreateOleObject('Excel.Application');
  ex.Workbooks.Add;
  ex.Visible:=True;
  ws:=ex.ActiveWorkbook.ActiveSheet;
  ws.Columns[2].ColumnWidth:=14;
  ws.Columns[3].ColumnWidth:=14;
  ws.Columns[4].ColumnWidth:=14;
  ws.Columns[5].ColumnWidth:=14;
  ws.Columns[6].ColumnWidth:=14;
  ws.Columns[7].ColumnWidth:=14;
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    mobj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[i]);
    OutMapObject(ex,ws,mobj);
  end;
end;

procedure TfVedomost.FormCreate(Sender: TObject);
begin
  LoadParams;
  LoadFields;
end;

procedure TfVedomost.Loadfields;
var ilar:IIngeoLayer;
    isemd:IIngeoSemTable;
    i,j:integer;
begin
  cbTitleField.Items.Clear;
  ilar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
  for i:=0 to ilar.SemTables.Count-1 do
  begin
    isemd:= ilar.SemTables.Item[i];
    for j:=0 to isemd.FieldInfos.Count-1 do
    begin
      cbTitleField.Items.Add(isemd.Name+'.'+ isemd.FieldInfos.Item[j].FieldName);
    end;
  end;
end;

procedure TfVedomost.OutMapObject(ex,ws: variant; imobj: IIngeoMapObject);
var form,tit,s,tn,fn,r1,r2:string;
    i,si,vi,row:integer;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    x,y,cv:Double;
    pn:string;
    vv:olevariant;
begin
  vv:=False;
  s:=cbTitleField.Text;
  if Trim(s)='' then tit:='' else
  begin
    tn:=Copy(s,1,Pos('.',s)-1);
    fn:=Copy(s,Pos('.',s)+1,300);
    tit:=imobj.SemData.GetDisplayText(tn,fn,0);
  end;
  row:=ex.ActiveCell.Row;
  ws.Cells[row,1].Value:='Ведомость вычисления площадей';
  r1:=ws.Cells[row,1].Address[vv,vv];
  r2:=ws.Cells[row,7].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;
  ex.Selection.Merge;
  ex.Selection.HorizontalAlignment:=xlCenter;
  inc(row);
  ws.Cells[row,1].Value:=tit;
  r1:=ws.Cells[row,1].Address[vv,vv];
  r2:=ws.Cells[row,7].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;
  ex.Selection.Merge;
  ex.Selection.HorizontalAlignment:=xlCenter;
  inc(row);
  ws.Cells[row,1]:='№ п/п';
  ws.Cells[row,2]:='Координаты';
  ws.Cells[row,4]:='Разности';
  ws.Cells[row,6]:='Произведения';

  r1:=ws.Cells[row,1].Address[vv,vv];
  r2:=ws.Cells[row+1,1].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;
  ex.Selection.Merge;
  ex.Selection.HorizontalAlignment:=xlCenter;

  r1:=ws.Cells[row,2].Address[vv,vv];
  r2:=ws.Cells[row,3].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;
  ex.Selection.Merge;
  ex.Selection.HorizontalAlignment:=xlCenter;

  r1:=ws.Cells[row,4].Address[vv,vv];
  r2:=ws.Cells[row,5].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;
  ex.Selection.Merge;
  ex.Selection.HorizontalAlignment:=xlCenter;

  r1:=ws.Cells[row,6].Address[vv,vv];
  r2:=ws.Cells[row,7].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;
  ex.Selection.Merge;
  ex.Selection.HorizontalAlignment:=xlCenter;
  inc(row);
  ws.Cells[row,2]:='Yk';
  ws.Cells[row,3]:='Xk';
  ws.Cells[row,4]:='dYk=(Yk+1)-(Yk-1)';
  ws.Cells[row,5]:='dXk=(Xk+1)-(Xk-1)';
  ws.Cells[row,6]:='Xk*dYk';
  ws.Cells[row,7]:='yk*dXk';

  r1:=ws.Cells[row-1,1].Address[vv,vv];
  r2:=ws.Cells[row,7].Address[vv,vv];
  ws.Range[r1+':'+r2].Select;

  ex.Selection.Borders.LineStyle:=xlContinuous;
  ex.Selection.HorizontalAlignment:=xlCenter;
  inc(row);
  shp:=nil;
  for i:=0 to imobj.Shapes.Count-1 do
  begin
    if imobj.Shapes.Item[i].DefineGeometry=True then
    begin
      shp:=imobj.Shapes.Item[i];
      break;
    end;

  end;
  if shp=nil then exit;
  for i:=0 to shp.Contour.Count-1 do
  begin
    cntp:=shp.Contour.Item[i];
    for vi:=0 to cntp.VertexCount-1 do
    begin
      cntp.GetVertex(vi,x,y,cv);
      if cbUsePoints.Checked then
         pn:=GetPName(x,y) else pn:=IntTosTr(vi+1);
      ws.Cells[row,1].Value:=pn;
      ws.Cells[row,2].Value:=y;
      ws.Cells[row,3].Value:=x;
      if vi=0 then
      begin
        ws.Cells[row,4].Formula:='='+ws.Cells[row+1,2].Address[vv,vv]+'-'+ws.Cells[row+cntp.VertexCount-1,2].Address[vv,vv];
        ws.Cells[row,5].Formula:='='+ws.Cells[row+1,3].Address[vv,vv]+'-'+ws.Cells[row+cntp.VertexCount-1,3].Address[vv,vv];
      end;
      if vi=cntp.VertexCount-1 then
      begin
        ws.Cells[row,4].Formula:='='+ws.Cells[row-cntp.VertexCount+1,2].Address[vv,vv]+'-'+ws.Cells[row-1,2].Address[vv,vv];
        ws.Cells[row,5].Formula:='='+ws.Cells[row-cntp.VertexCount+1,3].Address[vv,vv]+'-'+ws.Cells[row-1,3].Address[vv,vv];
      end;
      if (vi<>cntp.VertexCount-1) and (vi>0) then
      begin
        ws.Cells[row,4].Formula:='='+ws.Cells[row+1,2].Address[vv,vv]+'-'+ws.Cells[row-1,2].Address[vv,vv];
        ws.Cells[row,5].Formula:='='+ws.Cells[row+1,3].Address[vv,vv]+'-'+ws.Cells[row-1,3].Address[vv,vv];
      end;
      ws.Cells[row,6].Formula:='='+ws.Cells[row,4].Address[vv,vv]+'*'+ws.Cells[row,3].Address[vv,vv];
      ws.Cells[row,7].Formula:='='+ws.Cells[row,2].Address[vv,vv]+'*'+ws.Cells[row,5].Address[vv,vv];
      inc(row);
    end;  //vi
    ws.Cells[row,1].Value:='сумма';
    ws.Cells[row,6].Formula:='=SUM('+ws.Cells[row-cntp.VertexCount,6].Address[vv,vv]+':'+ws.Cells[row-1,6].Address[vv,vv]+')';
    ws.Cells[row,7].Formula:='=SUM('+ws.Cells[row-cntp.VertexCount,7].Address[vv,vv]+':'+ws.Cells[row-1,7].Address[vv,vv]+')';
    inc(row);
    ws.Cells[row,1].Value:='площадь';
    ws.Cells[row,6].Formula:='='+ws.Cells[row-1,6].Address[vv,vv]+'/2';
    ws.Cells[row,7].Formula:='='+ws.Cells[row-1,7].Address[vv,vv]+'/2';
    inc(row);
  end; //i
  ws.Cells[row,1].Activate;
//  ex.Selection.HorizontalAlignment:=xlCenter;

end;

procedure TfVedomost.LoadParams;
begin
  prefsaver.app:=gAddon2;
  prefsaver.scope:=inupUser;
  Loadcontrol(cbUsePoints,'topoutils_ved');
  Loadcontrol(cbPointField,'topoutils_ved');
  pstyle:=gAddon2.UserProfile.Get(inupUser,'','topoutils_ved_pstyle','');
  if pstyle<>'' then LoadFields2;
end;

procedure TfVedomost.SaveParams;
begin
  SAvecontrol(cbUsePoints,'topoutils_ved');
  Savecontrol(cbPointField,'topoutils_ved');
  gAddon2.UserProfile.Put(inupUser,'','topoutils_ved_pstyle',pstyle);
end;

procedure TfVedomost.Loadfields2;
var ilar:IIngeoLayer;
    isemd:IIngeoSemTable;
    i,j:integer;

begin
  eStyleName.Text:=gAddon2.ActiveDb.StyleFromID(pstyle).Layer.Name+'\'+
         gAddon2.ActiveDb.StyleFromID(pstyle).Name;

  cbPointField.Items.Clear;
  ilar:=gAddon2.ActiveDb.StyleFromID(pstyle).Layer;
  for i:=0 to ilar.SemTables.Count-1 do
  begin
    isemd:= ilar.SemTables.Item[i];
    for j:=0 to isemd.FieldInfos.Count-1 do
    begin
      cbPointField.Items.Add(isemd.Name+'.'+ isemd.FieldInfos.Item[j].FieldName);
    end;
  end;
end;

procedure TfVedomost.Button3Click(Sender: TObject);
var fs:TfSelectStyle;
begin
  fs:=TfSelectStyle.Create(self);
  if fs.ShowModal=mrOk then
  begin
    pstyle:=PM2ID(fs.trv1.Selected.Data)^;
    Loadfields2;
  end;
end;

procedure TfVedomost.LoadPoints;
var rx1,ry1,rx2,ry2:double;
    x1,y1,x2,y2:double;
    shpi, i:integer;
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    x,y,c:double;
    lar,pn:string;
    mq:IIngeoMapObjectsQuery;
    olar,ooid:WideString;

begin
  lar:=Gaddon2.ActiveDb.StyleFromID(pstyle).Layer.ID;
  xycount:=0;
  if gAddon2.Selection.Count=0 then exit;
  ptn:=Copy(cbPointField.Text,1,Pos('.',cbPointField.Text)-1);
  pfn:=Copy(cbPointField.Text,Pos('.',cbPointField.Text)+1,200);
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[0]);
  rx1:=mobj.X1;
  ry1:=mobj.Y1;
  rx2:=mobj.X2;
  ry2:=mobj.Y2;
  for i:=1 to gAddon2.Selection.Count-1 do
  begin
    mobj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[i]);
    if rx1>mobj.X1 then rx1:=mobj.X1;
    if ry1>mobj.Y1 then ry1:=mobj.Y1;
    if rx2<mobj.X2 then rx2:=mobj.X2;
    if ry2<mobj.Y2 then ry2:=mobj.Y2;
  end;
  mq:= gAddon2.ActiveDb.MapObjects.QueryByRect(lar,rx1,ry1,rx2,ry2,True);
  while not mq.Eof do
  begin
    mq.Fetch(olar,ooid,shpi);
    mobj:=gAddon2.ActiveDb.MapObjects.GetObject(ooid);
    for i:=0 to mobj.Shapes.Count-1 do
    begin
      if mobj.Shapes.Item[i].DefineGeometry then
      begin
        mobj.Shapes.Item[i].Contour.Item[0].GetVertex(0,x,y,c);
        pn:=mobj.SemData.GetDisplayText(ptn,pfn,0);
        AddVPoint(x,y,pn);
        break;
      end;
    end;
    mobj:=nil;
  end;
  mq:=nil;
end;

procedure TfVedomost.AddVPoint(ax, ay: double;pn:string);
var i:integer;
    l:double;
begin
  for i:=0 to xycount-1 do
  begin
    l:=SQRT(SQR(ax-x[i])+SQR(ay-y[i]));
    if l<2e-2 then exit;
  end;
  x[xycount]:=ax;
  y[xycount]:=ay;
  n[xycount]:=pn;
  inc(xycount);
end;

function TfVedomost.GetPName(ax, ay: double): string;
var i:integer;
    l:double;
begin
  Result:='';
  for i:=0 to xycount-1 do
  begin
    l:=SQRT(SQR(ax-x[i])+SQR(ay-y[i]));
    if l<2e-2 then
    begin
      Result:=n[i];
      exit;
    end;
  end;
end;

end.
