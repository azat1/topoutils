unit smartpointmaker;

interface
uses Classes,SysUtils,Ingeo_TLB, Controls, StdCtrls, ExtCtrls, ComCtrls;
type
   TSmartPointMaker=class
  private
    procedure LoadPointList;
    procedure AddVPoint(ax, ay: double);
    procedure AddPoint(ax, ay,x2,y2,x3,y3: double);
    procedure CalcBissectVector(x,y,x1,y1,x3,y3:double;var bx,by:double);
    procedure CreatePoints;
     public
       x,y:array [0..10000] of double;
       tx,ty:array [0..10000] of double;
       xycount:integer;
       cx,cy:array [0..10000] of double;
       cxycount:integer;
       pstyle,tstyle,field,sformat:string;
       dx,dy,tl:double;
       start:integer;
       delold,norep:boolean;
       progress:TProgressBar;
       app:IIngeoApplication;
       //cxycount:integer;
       constructor Create(app:IIngeoApplication; pstyle,tstyle,field:string;dx,dy:double;sformat:string;start:integer;
         deleteold, norepeat:boolean);
       procedure MakePoints;
   end;
implementation

{ TSmartPointMaker }

procedure TSmartPointMaker.CalcBissectVector(x, y, x1, y1, x3, y3: double; var bx, by: double);
var l1,l2,vx1,vy1,vx2,vy2:double;
  bl: double;
begin
  vx1:=x1-x;
  vy1:=y1-y;
  vx2:=x3-x;
  vy2:=y3-y;
  l1:=SQrt(sqr(vx1)+SQr(vy1));
  l2:=SQrt(sqr(vx2)+SQr(vy2));
  vx1:=vx1/l1;
  vx2:=vx2/l2;
  vy1:=vy1/l1;
  vy2:=vy2/l2;
  bx:=vx1+vx2;
  by:=vy1+vy2;
  bl:=SQrt(sqr(bx)+sqr(by));
  bx:=bx/bl;
  by:=by/bl;

end;

constructor TSmartPointMaker.Create(app:IIngeoApplication;pstyle, tstyle, field: string;
 dx, dy: double; sformat: string; start: integer; deleteold, norepeat: boolean);
begin
  self.app:=app;
  self.pstyle:=pstyle;
  self.tstyle:=tstyle;
  self.field:=field;
  self.sformat:=sformat;
  self.dx:=dx;
  self.dy:=dy;
  self.start:=start;
  self.delold:=deleteold;
  self.norep:=norepeat;
end;

procedure TSmartPointMaker.MakePoints;
var oi,si,cpi,vi:integer;
    objid:string;
    mobj:IIngeoMapObject;
    shps:IIngeoShapes;
    shp:IIngeoShape;
    cntr:IIngeoContour;
    cntrp:IIngeoContourPart;
    x,y,cnvs,x1,y1,x3,y3:Double;
//  cxycount: Integer;
//  xycount: Integer;
begin
  tl:=sqrt(sqr(dx)+sqr(dy));
  if norep then LoadPointList else cxycount:=0;
  xycount:=0;
  for oi:=0 to app.Selection.Count-1 do
  begin
    objid:=app.Selection.IDs[oi];
    mobj:=app.ActiveDb.MapObjects.GetObject(objid);
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
        cntrp.GetVertex(cntrp.VertexCount-1,x1,y1,cnvs);
        for vi:=0 to cntrp.VertexCount-1 do
        begin
          if vi=cntrp.VertexCount-1 then
          begin
            cntrp.GetVertex(0,x3,y3,cnvs);
          end else
          begin
            cntrp.GetVertex(vi+1,x3,y3,cnvs);
          end;
          cntrp.GetVertex(vi,x,y,cnvs);
          AddPoint(x,y,x1,y1,x3,y3);
          x1:=x;y1:=y;
        end;  //vi
      end;  //vpi
    end;   //si
    progress.Position:=oi*100 div app.Selection.Count;
  end;   //oi
  CreatePoints;
end;

procedure TSmartPointMaker.CreatePoints;
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
  tn:=Copy(field,0,Pos('.',field)-1);
  fn:=Copy(field,Pos('.',field)+1,200);
  n:=start;
  cnv:=0;
  lar:=app.ActiveDb.StyleFromID(pstyle).Layer.ID;
  mobjs:=app.ActiveDb.MapObjects;
  oi:=0;
  for i:=0 to xycount-1 do
  begin
    newobj:=mobjs.AddObject(lar);
    shp:=newobj.Shapes.Insert(0,pstyle);
    cntp:=shp.Contour.Insert(0);
    cntp.InsertVertex(0,x[i],y[i],cnv);

    shp:=newobj.Shapes.Insert(0,tstyle);
    cntp:=shp.Contour.Insert(0);
    cntp.InsertVertex(-1,tx[i],ty[i],cnv);
    cntp.InsertVertex(-1,tx[i],ty[i]+2,cnv);

    newobj.SemData.SetValue(tn,fn,Format(sformat,[n]),0);
    inc(n);
    inc(oi);
    progress.Position:=i*100 div xyCount;
    if oi>300 then
    begin
       oi:=0;
       mobjs.UpdateChanges;
       app.ProcessMessages;
    end;
  end;
  mobjs.UpdateChanges;
  mobjs:=nil;
end;

procedure TSmartPointMaker.AddPoint(ax, ay,x2,y2,x3,y3: double);
var i:integer;
    l:double;
    bx,by:double;
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
  CalcBissectVector(ax,ay,x2,y2,x3,y3,bx,by);

  x[xycount]:=ax;
  y[xycount]:=ay;
  tx[xycount]:=ax-bx*tl;
  ty[xycount]:=ay-by*tl;
  inc(xycount);
end;


procedure TSmartPointMaker.LoadPointList;
var rx1,ry1,rx2,ry2:double;
    x1,y1,x2,y2:double;
    shpi, i:integer;
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    x,y,c:double;
    lar:string;
    mq:IIngeoMapObjectsQuery;
    olar,ooid:WideString;

begin
  lar:=app.ActiveDb.StyleFromID(pstyle).Layer.ID;
  cxycount:=0;
  if app.Selection.Count=0 then exit;
  mobj:=app.ActiveDb.MapObjects.GetObject(app.Selection.IDs[0]);
  rx1:=mobj.X1;
  ry1:=mobj.Y1;
  rx2:=mobj.X2;
  ry2:=mobj.Y2;
  for i:=1 to app.Selection.Count-1 do
  begin
    mobj:=app.ActiveDb.MapObjects.GetObject(app.Selection.IDs[i]);
    if rx1>mobj.X1 then rx1:=mobj.X1;
    if ry1>mobj.Y1 then ry1:=mobj.Y1;
    if rx2<mobj.X2 then rx2:=mobj.X2;
    if ry2<mobj.Y2 then ry2:=mobj.Y2;
  end;
  mq:= app.ActiveDb.MapObjects.QueryByRect(lar,rx1,ry1,rx2,ry2,True);
  while not mq.Eof do
  begin
    mq.Fetch(olar,ooid,shpi);
    mobj:=app.ActiveDb.MapObjects.GetObject(ooid);
    for i:=0 to mobj.Shapes.Count-1 do
    begin
      if mobj.Shapes.Item[i].DefineGeometry then
      begin
        mobj.Shapes.Item[i].Contour.Item[0].GetVertex(0,x,y,c);
        AddVPoint(x,y);
        break;
      end;
    end;
    mobj:=nil;
  end;
  mq:=nil;
end;

procedure TSmartPointMaker.AddVPoint(ax, ay: double);
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


end.
