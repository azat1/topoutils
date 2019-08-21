unit frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   M2Addon, DllForm, StdCtrls, checklst, ExtCtrls, registry, Menus,
  Buttons, ActiveX, ClipBrd, math,M2AddonD,
  xmldom, XMLIntf, msxmldom, XMLDoc, Ingeo_TLB, ComCtrls;
const
  scales:array [1..13] of integer=(
  10,25,50,100,250,500,1000,2000,5000,10000,25000,50000,100000
  );
  gplsize:TM2Point=(X:12;y:17);
  gres:TPoint=(x:200;Y:200);
  glinewidth:real=0.5;
  gfontheight:real=4;
  gfontdx:real=2;
  gfontdy:real=2;
  gsmezdist:real=0.5;
  gautoscale:integer=0;
  gpointsize:real=0.5;
  gpointform:string=' Û„Î‡ˇ';
  gpictureformat:string='¿‚ÚÓ';
  gzemname:string='';
  gprec:real=0.2;
  gsqtype:boolean=False;
  BSERNUM:string='34b3h4b3jhb3jh4b34jbfjhfb3';
  //              12345678901234567890
            //     4 3 4 3 h 3 h b 4 b j f 3
            //4343h3hb4b
  gtextfor:integer=1;
  gautosavepath:string='';
  gautosaveformat:string='';
  gselstl:string='';
  gselfld:string='';

  gprecselstl:string='';
  gprecselfld:string='';

  gunprecborderstl:string='';
  gprecborderstl:string='';

  gpartborderstl:string='';
  gpartkn:string='';
  gpartname:string='';

  gkvselstl:string='';
  gkvselfld:string='';
  gcadnom:string='';
  gcadnomfont:integer=10;
  gDS:string='0,1';
  gFM:string='0,1';
//  gprec:real=0.2;

  pstNotPrec=0;
  pstOldPrec=1;
  pstNewPrec=2;
  pstDel=3;

  lstNotPrec=0;
  lstOldPrec=1;
  lstNewPrec=2;
  lstDel=3;
  lstNewNotPrec=4;
  gsimtable='¿¡¬√ƒ≈∆» ÀÃÕ';
           //1234567890
  gmainN:integer=324554323;
  gmainB:integer=1344322127;

  gcat:string='';
  gnaz:string='';
  gisp:string='';
  gadrnp:string='';
  gadrst:string='';
  gadrh:string='';
  gadror:string='';
  gadrod:string='';
  gadronapr:string='';
  gpprec:string='0.2';
  gright:string='';
  grsubj:string='';
  gdocsq:string='';
  gkey:longword=912345678;
type
  TIDArray=record
    ids:array [0..100] of TM2ID;
    count:integer;
    name:string;
  end;
  TGroupArray=record

    items:array [0..100] of TIDArray;
    count:integer;
  end;
  TLine=record
    p1,p2,s:integer;
  end;

  TMainForm = class(TM2AddonForm)
    Label1: TLabel;
    eSelStyle: TEdit;
    Button1: TButton;
    cbDeleteOld: TCheckBox;
    Label2: TLabel;
    eFormat: TEdit;
    Button2: TButton;
    cbField: TComboBox;
    Label3: TLabel;
    cbNoRepeat: TCheckBox;
    ProgressBar1: TProgressBar;
    eStartN: TEdit;
    Label4: TLabel;
    cbAutoNumber: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    x,y:array [0..10000] of double;
    xycount:integer;
    cx,cy:array [0..10000] of double;
    pn:array [0..10000] of string;
    cxycount,startnum:integer;

    pstyle:string;
    procedure Numerate;
    procedure AddPoint(ax,ay:double);
    procedure AddPointMaxNumber(ax,ay:double);
    procedure AddVPoint(ax,ay:double);
    procedure CreatePoints;
    procedure Loadfields;
    procedure LoadPointList;
    procedure AddVPoint2(ax, ay: double; pnum: string);
    procedure GetStartNumber;
  public
    { Public declarations }
  end;

procedure ShowFrm;
var
  MainForm: TMainForm;
  tcnv:TCanvas;
  spx,spy:integer;
implementation
uses addn, selstyle;

{$R *.DFM}

procedure ShowFrm;
begin
  DecimalSeparator:=',';
  MainForm:=TMainForm.Create(nil);
  Mainform.Show;
end;


procedure TMainForm.Button1Click(Sender: TObject);
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(nil);
  if f.ShowModal=mrOk then
  begin
    pstyle:=PM2ID(f.trv1.Selected.Data)^;
    eSelStyle.Text:=f.trv1.Selected.Text;
    LoadFields;
  end;
  f.Free;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Numerate;
end;

procedure TMainForm.Numerate;
var oi,si,cpi,vi:integer;
    objid:string;
    mobj:IIngeoMapObject;
    shps:IIngeoShapes;
    shp:IIngeoShape;
    cntr:IIngeoContour;
    cntrp:IIngeoContourPart;
    x,y,cnvs:Double;
begin
  if cbNoRepeat.Checked then LoadPointList else cxycount:=0;
  if cbAutoNumber.Checked then
     GetStartNumber();
  xycount:=0;
  for oi:=0 to gAddon2.Selection.Count-1 do
  begin
    objid:=gAddon2.Selection.IDs[oi];
    mobj:=gAddon2.ActiveDb.MapObjects.GetObject(objid);
    shps:=mobj.Shapes;
    for si:=0 to shps.Count-1 do
    begin
      shp:= shps.Item[si];
      if not shp.DefineGeometry then
        continue;
      //if shp.Contour.Square=0 then continue;
      cntr:=shp.Contour;
      for cpi:=0 to cntr.Count-1 do
      begin
        cntrp:=cntr.Item[cpi];
        for vi:=0 to cntrp.VertexCount-1 do
        begin
          cntrp.GetVertex(vi,x,y,cnvs);
          AddPoint(x,y);
        end;  //vi
      end;  //vpi
    end;   //si
    ProgressBar1.Position:=oi*100 div gAddon2.Selection.Count;
  end;   //oi
  CreatePoints;
end;

procedure TMainForm.AddPoint(ax, ay: double);
var i:integer;
    l:double;
begin
  for i:=0 to xycount-1 do
  begin
    l:=SQRT(SQR(ax-x[i])+SQR(ay-y[i]));
    if l<2e-2 then exit;
  end;
  for i:=0 to cxycount-1 do
  begin
    l:=SQRT(SQR(ax-cx[i])+SQR(ay-cy[i]));
    if l<2e-2 then exit;
  end;
  x[xycount]:=ax;
  y[xycount]:=ay;
  inc(xycount);
end;

procedure TMainForm.CreatePoints;
var i:integer;
    newobj:IIngeoMapObject;
    mobjs:IIngeoMapObjects;
    lar,tn,fn:string;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    cntr:IIngeoContour;
    cnv:double;
    oi,n:integer;
begin
  tn:=Copy(cbField.Text,0,Pos('.',cbField.Text)-1);
  fn:=Copy(cbField.Text,Pos('.',cbField.Text)+1,200);
  n:=0;
  TryStrToInt(eStartN.Text,n);
  if cbAutoNumber.Checked then
    n:=startnum;
  cnv:=0;
  lar:=gAddon2.ActiveDb.StyleFromID(pstyle).Layer.ID;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  oi:=0;
  for i:=0 to xycount-1 do
  begin
    newobj:=mobjs.AddObject(lar);
    shp:=newobj.Shapes.Insert(0,pstyle);
    cntp:=shp.Contour.Insert(0);
    cntp.InsertVertex(0,x[i],y[i],cnv);
    newobj.SemData.SetValue(tn,fn,Format(eFormat.Text,[n]),0);
    inc(n);
    inc(oi);
    ProgressBar1.Position:=i*100 div xyCount;
    if oi>300 then
    begin
       oi:=0;
       mobjs.UpdateChanges;
       Application.ProcessMessages;
    end;
  end;
  mobjs.UpdateChanges;
  mobjs:=nil;
end;

procedure TMainForm.Loadfields;
var st:IIngeoSemTables;
    i,t:integer;
    sst:IIngeoSemTable;
    fn:string;
begin
  cbField.Items.Clear;
  st:=gAddon2.ActiveDb.StyleFromID(pstyle).Layer.SemTables;
  for i:=0 to st.Count-1 do
  begin
    sst:=st.Item[i];
    for t:=0 to sst.FieldInfos.Count-1 do
    begin
      fn:=sst.Name+'.'+sst.FieldInfos.Item[t].FieldName;
      cbField.Items.Add(fn);
    end;
  end;
end;

procedure TMainForm.LoadPointList;
var rx1,ry1,rx2,ry2:double;
    x1,y1,x2,y2:double;
    shpi, i:integer;
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    x,y,c:double;
    lar:string;
    mq:IIngeoMapObjectsQuery;
    olar,ooid:WideString;
    pnumfield:string;
begin
  pnumfield:='{'+cbField.Text+'}';
  lar:=Gaddon2.ActiveDb.StyleFromID(pstyle).Layer.ID;
  cxycount:=0;
  if gAddon2.Selection.Count=0 then exit;
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
        if cbAutoNumber.Checked then AddVPoint2(x,y,mobj.FormatText(pnumfield))
          else AddVPoint(x,y);
        break;
      end;
    end;
    mobj:=nil;
  end;
  mq:=nil;
end;

procedure TMainForm.AddPointMaxNumber(ax, ay: double);
var i:integer;
    l:double;
    pnp:integer;
begin
  for i:=0 to cxycount-1 do
  begin
    l:=SQRT(SQR(ax-cx[i])+SQR(ay-cy[i]));
    if l<2e-2 then
    begin
      if TryStrToInt(pn[i],pnp) then
      begin
        if startnum<pnp then
          startnum:=pnp;
      end;
      exit;
    end;
  end;
end;

procedure TMainForm.AddVPoint(ax, ay: double);
var i:integer;
    l:double;
begin
  for i:=0 to cxycount-1 do
  begin
    l:=SQRT(SQR(ax-cx[i])+SQR(ay-cy[i]));
    if l<2e-2 then exit;
  end;
  cx[cxycount]:=ax;
  cy[cxycount]:=ay;
  inc(cxycount);
end;

procedure TMainForm.AddVPoint2(ax, ay: double;pnum:string);
var i:integer;
    l:double;
begin
  for i:=0 to cxycount-1 do
  begin
    l:=SQRT(SQR(ax-cx[i])+SQR(ay-cy[i]));
    if l<2e-2 then exit;
  end;
  cx[cxycount]:=ax;
  cy[cxycount]:=ay;
  pn[cxycount]:=pnum;
  inc(cxycount);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm:=nil;
  Action:=caFree;
end;

procedure TMainForm.GetStartNumber;
var oi,si,cpi,vi:integer;
    objid:string;
    mobj:IIngeoMapObject;
    shps:IIngeoShapes;
    shp:IIngeoShape;
    cntr:IIngeoContour;
    cntrp:IIngeoContourPart;
    x,y,cnvs:Double;
begin
  //xycount:=0;
  startnum:=1;
  for oi:=0 to gAddon2.Selection.Count-1 do
  begin
    objid:=gAddon2.Selection.IDs[oi];
    mobj:=gAddon2.ActiveDb.MapObjects.GetObject(objid);
    shps:=mobj.Shapes;
    for si:=0 to shps.Count-1 do
    begin
      shp:= shps.Item[si];
      if not shp.DefineGeometry then
        continue;
      //if shp.Contour.Square=0 then continue;
      cntr:=shp.Contour;
      for cpi:=0 to cntr.Count-1 do
      begin
        cntrp:=cntr.Item[cpi];
        for vi:=0 to cntrp.VertexCount-1 do
        begin
          cntrp.GetVertex(vi,x,y,cnvs);
          AddPointMaxNumber(x,y);
        end;  //vi
      end;  //vpi
    end;   //si
//    ProgressBar1.Position:=oi*100 div gAddon2.Selection.Count;
  end;   //oi
//  CreatePoints;
end;

end.
