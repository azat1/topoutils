unit multizone;

interface
uses Classes,SysUtils, Ingeo_TLB,InScripting_TLB;
type
   TMultiZoneCreator=class
     public
       app:IIngeoApplication;
       stlid:string;
       width:double;
       constructor Create(app:IIngeoApplication;stlid:string;width:double);
       procedure CreateZone;
       procedure RemoveArc(cntr:IIngeoContour);
       procedure RemoveLinePoints(cntr:IIngeoContour);
       procedure GetArcParams(x1,y1,x2,y2,cv:double;var cx,cy,r:double);
       procedure GetArcPoint(x1,y1,x2,y2,cv:double;var x,y:double);
       procedure GetArcPoint2(x1,y1,x2,y2,cv:double;var ix,iy,ix2,iy2:double);
       procedure GetLineInterSectionPoint(a1,b1,c1,a2,b2,c2:double;var ix,iy:double);
       function PointInLine(x1,y1,x2,y2,x,y:double):boolean;
   end;
implementation

{ TMultiZoneCreator }

constructor TMultiZoneCreator.Create(app: IIngeoApplication; stlid: string; width: double);
begin
  self.app:=app;
  self.stlid:=stlid;
  self.width:=width;
end;

procedure TMultiZoneCreator.CreateZone;
var
  maincntr: IIngeoContour;
  i: Integer;
  mobjs:IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  bcntr: IIngeoContour;
  newobj: IIngeoMapObject;
  lar: string;
  shp: IIngeoShape;
begin
  if app.Selection.Count=0 then
    exit;
  mobjs:=app.ActiveDb.MapObjects;
  maincntr:=app.CreateObject(inocContour,0) as IIngeoContour;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(app.Selection.IDs[i]);
    for si := 0 to mobj.Shapes.Count - 1 do
    begin
      if mobj.Shapes[si].DefineGeometry then
      begin
        bcntr:=mobj.Shapes[si].Contour.BuildBufferZone(width);
        maincntr.Combine(inccOr,bcntr);
      end;
    end;

  end;
  RemoveArc(maincntr);
  RemoveLinePoints(maincntr);
  lar:=app.ActiveDb.StyleFromID(stlid).Layer.ID;
  newobj:=mobjs.AddObject(lar);
  shp:=newobj.Shapes.Insert(-1,stlid);
  shp.Contour.AddPartsFrom(maincntr);
  mobjs.UpdateChanges;


end;

procedure TMultiZoneCreator.GetArcParams(x1, y1, x2, y2, cv: double; var cx, cy,
  r: double);
  var vx,vy,cx1x,cx1y:double;
  b,s: double;
  a,vrx,vry,l: Double;
begin
//            PointFD v = p1.GetVector(p2);
  vx:=x2-x1;
  vy:=y2-y1;
//            PointFD cx1 = p1.MidPoint(p2);
  cx1x:=(x1+x2)/2;
  cx1y:=(y1+y2)/2;
//            double b=v.VectorLen()/2;
  b:=SQRT(vx*vx+vy*vy)/2;

  //          double s=b*c;
  s:=b*cv;
  r :=  (s * s + b * b) / (2 * s);
  a := r - s;
  //          PointFD vr = new PointFD(-v.Y, v.X);
  vrx:=-vy;
  vry:=vx;
  l:=SQRT(vrx*vrx+vry*vry);
//            vr.SetLen(a);
  vrx:=vrx/l*a;//(2*b)*a;
  vry:=vry/l*a;//(2*b)*a;

//            PointFD cx2 = new PointFD(cx1.X + vr.X, cx1.Y + vr.Y);
  cx:=cx1x+vrx;
  cy:=cx1y+vry;
  r:=abs(r);
end;

procedure TMultiZoneCreator.GetArcPoint(x1, y1, x2, y2, cv: double; var x,
  y: double);
var cx,cy,r,vx,vy,vx2,vy2,c1,c2,ix,iy:double;
begin
  GetArcParams(x1,y1,x2,y2,cv,cx,cy,r);
  //если дуга + вектор от центра и направо
    vx:=x1-cx; //вектор для перпендикулярной прямой  a=vx b=vy
    vy:=y1-cy;
    vx2:=x2-cx; //вектор для второй перпендикулярной прямой  a=vx b=vy
    vy2:=y2-cy;
    //ax+by+c=0  c=-ax-by;
    c1:=-vx*x1-vy*y1;
    c2:=-vx2*x2-vy2*y2;
    GetLineIntersectionPoint(vx,vy,c1,vx2,vy2,c2,x,y);
//    x:=cx;
//    y:=cy;
end;

procedure TMultiZoneCreator.GetArcPoint2(x1, y1, x2, y2, cv: double; var ix, iy,
  ix2, iy2: double);
var cx,cy,r,vx,vy,vx2,vy2,c1,c2,c3,vx3,vy3,px,py:double;
  l: Extended;
  mpx: Double;
  mpy: Double;
begin
    GetArcParams(x1,y1,x2,y2,cv,cx,cy,r);
  //если дуга + вектор от центра и направо
    vx:=x1-cx; //вектор для перпендикулярной прямой  a=vx b=vy
    vy:=y1-cy;
    vx2:=x2-cx; //вектор для второй перпендикулярной прямой  a=vx b=vy
    vy2:=y2-cy;
    //ax+by+c=0  c=-ax-by;
    c1:=-vx*x1-vy*y1;
    c2:=-vx2*x2-vy2*y2;
    //третья касательная сложение двух векторов
    vx3:=y2-y1;
    vy3:=x1-x2;
    l:=SQRT(vx3*vx3+vy3*vy3);
    vx3:=vx3/2*cv;
    vy3:=vy3/2*cv;

    mpx:=(x1+x2)/2;
    mpy:=(y1+y2)/2;

    //точка через которую надо пропустить третью касатальную
    //тупо по сложенному вектору
    px:=mpx+vx3;
    py:=mpy+vy3;
    c3:=-vx3*px-vy3*py;
    GetLineIntersectionPoint(vx,vy,c1,vx3,vy3,c3,ix,iy);
    GetLineIntersectionPoint(vx2,vy2,c2,vx3,vy3,c3,ix2,iy2);
//    ix:=cx;
//    iy:=cy;
end;

procedure TMultiZoneCreator.GetLineInterSectionPoint(a1, b1, c1, a2, b2,
  c2: double; var ix, iy: double);
begin

 try
  ix:=(b1*c2-b2*c1)/(a1*b2-a2*b1);
  iy:=(c1*a2-c2*a1)/(a1*b2-a2*b1);
 except

 end;
end;

function TMultiZoneCreator.PointInLine(x1, y1, x2, y2, x, y: double): boolean;
begin
  Result:=abs((y2-y1)*x-(x2-x1)*y+x2*y1-y2*x1)/sqrt(sqr(y2-y1)+sqr(x2-x1))<0.1;
end;

procedure TMultiZoneCreator.RemoveArc(cntr: IIngeoContour);
var
  ci,vi: Integer;
  cntp: IIngeoContourPart;
  x,y,cv,ix,iy,ix1,iy1,x1,y1,cvv:double;
begin
  for ci := 0 to cntr.Count - 1 do
  begin
    cntp:=cntr[ci];
    if cntp.Closed then
    begin
      cntp.GetVertex(cntp.VertexCount-1,x1,y1,cvv);
      vi:=0;
    end else
    begin
      cntp.GetVertex(0,x1,y1,cvv);
      vi:=1;
    end;
 //   vi:=0;
    while vi<cntp.VertexCount do
    begin
      cntp.GetVertex(vi,x,y,cv);
      if cv<>0 then
      begin
        if abs(cv)<0.5 then
        begin
          GetArcPoint(x1,y1,x,y,cv,ix,iy);
          cntp.DeleteVertex(vi);
         // cntp.DeleteVertex(vi);
          cntp.InsertVertex(vi,ix,iy,0);
    //      cntp.DeleteVertex(vi-1);       //   cntp.InsertVertex(vi+1,x,y,0);

        end else
        begin
          GetArcPoint2(x1,y1,x,y,cv,ix,iy,ix1,iy1);
          cntp.DeleteVertex(vi);
          cntp.InsertVertex(vi,ix,iy,0);
          cntp.InsertVertex(vi+1,ix1,iy1,0);
          cntp.InsertVertex(vi+2,x,y,0);

        end;

      end;
        x1:=x;
        y1:=y;
        inc(vi);
    end;

  end;

end;

procedure TMultiZoneCreator.RemoveLinePoints(cntr: IIngeoContour);
var
  i,vi: Integer;
  x1,y1,cv,x2,y2,x3,y3:double;
  cntp: IIngeoContourPart;
begin
  for i := 0 to cntr.Count - 1 do
  begin
    cntp:=cntr[i];
    vi:=1;
    cntp.GetVertex(0,x1,y1,cv);
    while vi<(cntp.VertexCount-1) do
    begin
      cntp.GetVertex(vi-1,x1,y1,cv);
      cntp.GetVertex(vi,x2,y2,cv);
      cntp.GetVertex(vi+1,x3,y3,cv);
      if PointInLine(x1,y1,x3,y3,x2,y2) then
      begin
        cntp.DeleteVertex(vi);
        continue;
      end;
      inc(vi);
    end;

  end;

end;

end.
