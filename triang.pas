unit triang;

interface
uses Classes, XMLIntf, M2Addon, M2AddonD, math, ptslist, sysutils;
type
//forward
  TZTriangle=class;

//=================
   TZPoint=class
     public
       x,y,z:extended;
       trl:TList;
       constructor Create(ax,ay,az:extended);

   end;
//=================
   TZPointList=class(TList)
     public
       procedure MemClear;
       function GetP(index:integer):TZPoint;
       function FindNear(p:TZPoint):TZPoint;
       procedure FilterList(mindistance:extended);
       function IsInTriangle(p1,p2,p3:TZPoint):boolean;
   end;
//=================
   TZLine=class
     public
       p1,p2:TZPoint;
       len:extended;
       constructor Create(ap1,ap2:TZPoint);
       constructor CreateFast(ap1,ap2:TZPoint;al:extended);
   end;
//-----------------
   TZLineTR=class(TZLine)
     public
       left,right:TZTriangle;
       constructor Create(ap1,ap2:TZPoint);
       constructor CreateFast(ap1,ap2:TZPoint;al:extended);
       function HavePoint(p:TZPoint):boolean;
       procedure SetSide(tr:TZtriangle;ap1,ap2,ap3:TZPoint);
   end;
//=================
   TZTriangle=class
     public
       pts:array [1..3] of TZPoint;
       lines:array [1..3] of TZLineTR;
       rect:TM2Rect;
       constructor Create(p1,p2,p3:TZPoint);
       constructor CreateL(l1,l2,l3:TZLineTR);
       procedure LockLines;
       function IsIntersect(atr:TZTriangle):boolean;
       function IsLineIntersect(p1,p2:TZPoint):boolean;
       function CalcRect:TM2REct;
       function ReCalcRect:TM2REct;
       function IsPointIn(p:TZPoint):boolean;
   end;
//=================
   TZLineList=class(TList)
     public
       function GetL(index:integer):TZLine;
       procedure FastAdd(l:TZLine);
   end;
//=================
   TZLineTRList=class (TZLineList)
     public
       function GetL(index:integer):TZLineTR;
       function AddLine(p1,p2:TZPoint):TZLineTR;
   end;
//=================
   TZTriangleList=class(TList)
     public
       function GetTR(i:integer):TZTriangle;
       function IsPointIn(p:TZPoint):boolean;
       function IsLineIntersect(p1,p2:TZPoint):boolean;
       function GetTrWithP(p:TZPoint):TZTriangle;

       procedure FillXML(node:IXMLNode);virtual;
   end;
//=================
   TTriangler=class
     public
       points,srcpoints:TZPointList;
       lines:TZLineList;
       linestr:TZLineTRList;
       maxlen:extended;
       triangles:TZTriangleList;
       constructor Create;
       procedure LoadPoints(xn:IXMLNode);
       procedure Make;virtual;
       procedure FillTriangles(xn:IXMLNode);
       procedure AddLine_and_TR(oldl:TZLineTR;newp:TZPoint;right:boolean);
   end;
//=================

   function ZLineLen(p1,p2:TZPoint):extended;
   function LLenX(x1,y1,x2,y2:double):double;
   function SQRZLineLen(p1,p2:TZPoint):extended;
   function FastZLen(p1,p2:TZPoint;lim:extended;var res:extended):boolean;
   function ZLCompare(p1,p2:pointer):boolean;
   function TRSign(p1,p2,p3:TZPoint):extended;
   function IsLinesIntersect(p1,p2,p3,p4:TZPoint):boolean;
   function IsLinesIntersect2(x1,y1,x2,y2,x3,y3,x4,y4:double;var x,y:double):boolean;
   function IsLinesIntersect3(x1,y1,x2,y2,x3,y3,x4,y4:double;var x,y:double):boolean;
   function FastCircle(p1,p2,p3:TZPoint):extended;
   procedure ZSwap(var p1,p2:TZPoint);
   function ZPointCompare(p1,p2:pointer):integer;
   function LineSide(lp1,lp2,p:TZPoint):integer;

implementation
uses dialogs;
   function IsLinesIntersect3(x1,y1,x2,y2,x3,y3,x4,y4:double;var x,y:double):boolean;
   begin
   
   end;
   function LLenX(x1,y1,x2,y2:double):double;
   begin
     try
       Result:=SQRT(SQR(x1-x2)+SQR(y1-y2));
     except
       on e:exception do ShowMessage('LLenX err '+e.Message+Format('%f %f %f %f',[x1,y1,x2,y2]));
     end;
   end;
   function LineSide(lp1,lp2,p:TZPoint):integer;
   begin
     Result:=Sign((lp1.x-p.x)*(lp2.y-p.y)-(lp2.x-p.x)*(lp1.y-p.y));
   end;

   function ZPointCompare(p1,p2:pointer):integer;
   begin
     if TZPoint(p1).z<TZPoint(p2).z then Result:=1;
     if TZPoint(p1).z=TZPoint(p2).z then Result:=0;
     if TZPoint(p1).z>TZPoint(p2).z then Result:=-1;
   end;

  procedure ZSwap(var p1,p2:TZPoint);
  begin
    asm
      mov eax,p1
      mov ebx,p2
      mov p2,eax
      mov p1,ebx
    end;
  end;

  function FastCircle(p1,p2,p3:TZPoint):extended;
  var a,b,c,k1,k2,sx1,sx2,sx3:extended;
  begin
    sx1:=SQR(p1.X)+SQR(p1.y);
    sx2:=SQR(p2.X)+SQR(p2.y);
    sx3:=SQR(p3.X)+SQR(p3.y);
    k1:=1/M3x3Opred(M3x3(p1.x,p1.Y,1,p2.X,p2.Y,1,p3.X,p3.Y,1));
    a:=-M3x3Opred(M3x3(sx1,p1.Y,1,
                       sx2,p2.Y,1,
                       sx3,p3.Y,1))*k1;
    b:=M3x3Opred(M3x3(sx1,p1.x,1,
                      sx2,p2.x,1,
                      sx3,p3.x,1))*k1;
    c:=-M3x3Opred(M3x3(sx1,p1.x,p1.Y,
                       sx2,p2.x,p2.Y,
                       sx3,p3.x,p3.Y))*k1;
    rEsult:=Abs(SQR(a)+SQR(b)-4*c);
  end;

   function IsLinesIntersect(p1,p2,p3,p4:TZPoint):boolean;
   var ax,ay,bx,by,cx,cy,dx,dy,t1,t2,k,l,m,n,x,y,mlnk:extended;
   begin
     Result:=False;
     if (p1=p3) or (p1=p4) or
       (p2=p3) or (p2=p4) then exit;
     ax:=p1.X; ay:= p1.Y;
     bx:=p2.X; by:= p2.Y;
     cx:= p3.X; cy:= p3.Y;
     dx:= p4.X; dy:= p4.Y;
     k:=bx-ax;
     l:=dx-cx;
     m:=by-ay;
     n:=dy-cy;
     mlnk:=(m*l-n*k);
     if mlnk=0 then exit;
     t1:=((cy-ay)*l+n*(ax-cx))/(mlnk);
     if (t1<0) or (t1>1) then exit;
     x:=ax+k*t1;
     y:=ay+m*t1;

     if SameValue(dx,cx,1e-6) then
        t2:=(y-cy)/(dy-cy) else
        t2:=(x-cx)/(dx-cx);
     if (t2<0) or (t2>1) then exit;
     Result:=True;
   end;

   function IsLinesIntersect2(x1,y1,x2,y2,x3,y3,x4,y4:double;var x,y:double):boolean;
   var ax,ay,bx,by,cx,cy,dx,dy,t1,t2,k,l,m,n,mlnk,err:double;
   begin
     err:=0.0001;
     Result:=False;
     if (LLenX(x1,y1,x3,y3)<err) or
        (LLenX(x1,y1,x4,y4)<err) or
        (LLenX(x2,y2,x3,y3)<err) or
        (LLenX(x2,y2,x4,y4)<err)
       then
     exit;
     ax:=X1; ay:= Y1;
     bx:=X2; by:= Y2;
     cx:= X3; cy:= Y3;
     dx:= X4; dy:= Y4;
     k:=bx-ax;
     l:=dx-cx;
     m:=by-ay;
     n:=dy-cy;
     mlnk:=(m*l-n*k);
     if mlnk=0 then exit;
     try
     t1:=((cy-ay)*l+n*(ax-cx))/(mlnk);
     except
       on e:Exception do ShowMessage('mlnk error!'+e.Message);
     end;
     if SameValue(t1,0,err) or SameValue(t1,1,err) then exit;
     if (t1<0) or (t1>1) then exit;
     x:=ax+k*t1;
     y:=ay+m*t1;
     try
     if SameValue(dx,cx,1e-6) then
        t2:=(y-cy)/(dy-cy) else
        t2:=(x-cx)/(dx-cx);
     except
       on e:Exception do ShowMessage('dx cx error!'+e.Message);
     end;
     if SameValue(t2,0,err) or SameValue(t2,1,err) then exit;
     if (t2<0) or (t2>1) then exit;
     Result:=True;
   end;

   function TRSign(p1,p2,p3:TZPoint):extended;
   begin
    Result:=(p1.X-p3.X)*(p2.Y-p3.y)-(p1.Y-p3.Y)*(p2.X-p3.X);
   end;
//warning abstract
   function ZLCompare(p1,p2:pointer):boolean;
   begin
   end;
//end w
   function ZLineLen(p1,p2:TZPoint):extended;
   begin
     Result:=SQRT(SQR(p1.x-p2.x)+SQR(p1.y-p2.y));
   end;

   function SQRZLineLen(p1,p2:TZPoint):extended;
   begin
     Result:=SQR(p1.x-p2.x)+SQR(p1.y-p2.y);
   end;

   function FastZLen(p1,p2:TZPoint;lim:extended;var res:extended):boolean;
   var cx,cy:extended;
   begin
     REsult:=False;
     cx:=abs(p1.x-p2.x);
     if cx>lim then exit;
     cy:=abs(p1.y-p2.y);
     if cy>lim then exit;
     res:=SQRT(SQR(cx)+SQR(cy));
     if res>lim then exit;
     Result:=True;
   end;
{ TTriangler }

procedure TTriangler.AddLine_and_TR(oldl:TZLineTR; newp: TZPoint;right:boolean);
var newline1,newline2:TZLineTR;
    newtr:TZTriangle;
begin
  newline1:=linesTR.AddLine(oldl.p1,newp);
  newline2:=linesTR.AddLine(oldl.p2,newp);
  newtr:=TZTriangle.CreateL(oldl,newline1,newline2);
  triangles.Add(newtr);
  newtr.LockLines;
end;

constructor TTriangler.Create;
begin
  inherited;
  points:=TZPointList.Create;
  
end;

procedure TTriangler.FillTriangles(xn: IXMLNode);
begin
  triangles.FillXML(xn);
end;


procedure TTriangler.LoadPoints(xn: IXMLNode);
var xn2,pxn:IXMLNode;
    i:integer;
    x,y,z:extended;
begin
// clear memory
  points.MemClear;
//
  for i:=0 to xn.ChildNodes.Count-1 do
  begin
    pxn:=xn.ChildNodes.Get(i);
    x:=pxn.GetAttributeNS('X','');
    y:=pxn.GetAttributeNS('Y','');
    z:=pxn.GetAttributeNS('Z','');
    points.Add(TZPoint.Create(x,y,z));
  end;
  srcpoints:=TZPointList.Create;
  srcpoints.Assign(points);
  points.FilterList(1e-2);
end;

procedure TTriangler.Make;
var i,li:integer;
    fp,pp,tp:TZPoint;
    leftr,rightr,cr:extended;
    rightp,leftp:TZPoint;
    sgn,len1,len2,sqmaxlen:extended;
    cline,newline1,newline2,newtr:TZLineTR;
    added:boolean;
begin
  sqmaxlen:=SQR(maxlen);
  triangles:=TZTriangleList.Create;
  lines:=TZLineList.Create;
  linestr:=TZLineTRList.Create;
  if points.Count=0 then exit;
  fp:=points.GetP(0);
  pp:=points.FindNear(fp);
  linestr.Add(TZLineTR.Create(fp,pp));
  repeat
    added:=False;
    for li:=0 to linestr.Count-1 do
    begin
      cline:=linestr.GetL(li);
      if (cline.left<>nil) and (cline.right<>nil) then continue;
      fp:=cline.p1; pp:=cline.p2;
      leftr:=1e10;rightr:=1e10;
      if cline.left<>nil then leftr:=-1; //блокировка занятых сторон
      if cline.right<>nil then rightr:=-1;

      rightp:=nil;leftp:=nil;
          for i:=0 to points.Count-1 do
          begin

            tp:=points.GetP(i);
            if (tp=pp) or (tp=fp) then continue;
            sgn:=TRSign(fp,pp,tp);
            cr:=FastCircle(fp,pp,tp);
            if (cr>rightr) and (cr>leftr) then continue;
            if triangles.IsPointIn(tp) then continue;
            if triangles.IsLineIntersect(pp,tp) then continue;
            if triangles.IsLineIntersect(pp,fp) then continue;
            if points.IsInTriangle(fp,pp,tp) then continue;
            if (SQRZLineLen(pp,tp)>sqmaxlen) or (SQRZLineLen(fp,tp)>sqmaxlen) then continue;

            if (cr<rightr) and (sgn>0) then
            begin
              rightp:=tp;
              rightr:=cr;
            end;
            if (cr<leftr) and (sgn<0) then
            begin
              leftp:=tp;
              leftr:=cr;
            end;
          end;  //i
          if rightp<>nil then
          begin
            AddLine_and_TR(cline,rightp,True);
            added:=True;
          end;
          if leftp<>nil then
          begin
            AddLine_and_TR(cline,leftp,False);
            added:=True;
          end;
     end; //li
     if not added then break;
  until False;
end;

{ TZPoint }

constructor TZPoint.Create(ax, ay, az: extended);
begin
  inherited Create;
  x:=ax;
  y:=ay;
  z:=az;
  trl:=TList.Create;
end;

{ TZPointList }

procedure TZPointList.FilterList(mindistance: extended);
var i,j:integer;
    p1,p2:TZPoint;
    flag:boolean;
begin
  Sort(ZPointCompare);
    j:=0;
    repeat
      if j>Count-2 then break;
      p1:=GetP(j);
      p2:=GetP(j+1);
      if ZLineLen(p1,p2)<mindistance then
      begin
        if p1.z=p2.z then
        begin
          Delete(j);
          continue;
        end;
        if p1.z<>p2.z then
        begin
          Delete(j);
          Delete(j+1);
          continue;
        end;
      end;
      Inc(j);
    until j>Count-2;
end;

function TZPointList.FindNear(p: TZPoint): TZPoint;
var i,mi:integer;
    mr,tr,sqmr:extended;
    fp,pp:TZPoint;
begin
  Result:=nil;
  if Count=0 then exit;
  fp:=nil;
  sqmr:=1e10;
  mr:=SQR(sqmr);
  for i:=1 to Count-1 do
  begin

     pp:=GetP(i);
     if pp=p then continue;
     if abs(pp.x-p.x)>sqmr then continue;
     if abs(pp.y-p.y)>sqmr then continue;
     tr:=SQRZLineLen(pp,p);
     if tr<mr then
     begin
       fp:=pp;
       mr:=tr;
       sqmr:=SQRT(mr);
     end;
  end;
  Result:=fp;
end;

function TZPointList.GetP(index: integer): TZPoint;
begin
  Result:=TZPoint(Items[index]);
end;

function TZPointList.IsInTriangle(p1, p2, p3: TZPoint): boolean;
var s1,s2,s3,i:integer;
    cp:TZpoint;
    rect:TM2REct;
begin
  rect.X1:=Min(p1.x,Min(p2.x,p3.x));
  rect.Y1:=Min(p1.y,Min(p2.y,p3.y));
  rect.X2:=Max(p1.x,Max(p2.x,p3.x));
  rect.Y2:=Max(p1.y,Max(p2.y,p3.y));
  Result:=False;
  for i:=0 to Count-1 do
  begin
    cp:=GetP(i);
    if not M2RectContainsPoint(Rect,M2Point(cp.x,cp.y)) then continue;
    s1:=Sign(TRSign(p1,p2,cp));
    s2:=Sign(TRSign(p2,p3,cp));
    s3:=Sign(TRSign(p3,p1,cp));
    if (s1=s2) and( s1=s3) then
    begin
      Result:=True;
      exit;
    end;
  end;
end;

procedure TZPointList.MemClear;
var i:integer;
begin
  for i:=0 to Count-1 do
  begin
    TZPoint(Items[i]).Free;
  end;
  Clear;
end;

{ TZLine }

constructor TZLine.Create(ap1, ap2: TZPoint);
begin
  inherited Create;
  if ap1.x<ap2.x then
  begin
    p1:=ap1;
    p2:=ap2;
  end else
  begin
    p1:=ap2;
    p2:=ap1;
  end;
  len:=ZLineLen(p1,p2);
end;

constructor TZLine.CreateFast(ap1, ap2: TZPoint; al: extended);
begin
  inherited Create;
  p1:=ap1;
  p2:=ap2;
  len:=al;
end;

{ TZLineList }

procedure TZLineList.FastAdd(l: TZLine);
var a,b,c:integer;
begin
  a:=0;
  b:=Count-1;
  if l.len<GetL(0).Len then
  begin
    Insert(0,l);
    exit;
  end;
  if l.len>GetL(Count-1).len then
  begin
    Add(l);
    exit;

  end;
  while (b-a)=1 do
  begin
    c:=(a+b) div 2;
    if l.len>GetL(c).len then a:=c else b:=c;
  end;
  Insert(b,l);
end;

function TZLineList.GetL(index: integer): TZLine;
begin
  Result:=TZLine(items[index]);
end;

{ TZLineTR }

constructor TZLineTR.Create(ap1, ap2: TZPoint);
begin
  inherited;
  left:=nil;
  right:=nil;
end;

constructor TZLineTR.CreateFast(ap1, ap2: TZPoint; al: extended);
begin
  inherited;
  left:=nil;
  right:=nil;
end;

{ TTriangle }

function TZTriangle.CalcRect: TM2REct;
begin
  Result.X1:=Min(pts[1].x,Min(pts[2].x,pts[3].x));
  Result.Y1:=Min(pts[1].Y,Min(pts[2].y,pts[3].y));
  Result.X2:=Max(pts[1].x,Max(pts[2].x,pts[3].x));
  Result.Y2:=Max(pts[1].Y,Max(pts[2].y,pts[3].y));
end;

constructor TZTriangle.Create(p1, p2, p3: TZPoint);
begin
  inherited Create;
  pts[1]:=p1;
  pts[2]:=p2;
  pts[3]:=p3;
  ReCalcRect;
end;

constructor TZTriangle.CreateL(l1, l2, l3: TZLineTR);
begin
  inherited Create;
  lines[1]:=l1;
  lines[2]:=l2;
  lines[3]:=l3;
  pts[1]:=l1.p1;
  pts[2]:=l1.p2;
  if (l2.p1=l1.p1) or (l2.p1=l1.p2) then
     pts[3]:=l2.p2 else pts[3]:=l2.p1;
  ReCalcRect;
end;

function TZTriangle.IsIntersect(atr: TZTriangle): boolean;
var i,j,z1,z2,z3:integer;
begin
  Result:=False;
  if not M2RectIntersectsRect(Rect,atr.Rect) then exit;
  for i:=1 to 3 do
    for j:=1 to 3 do
    begin
      if atr.pts[i]=pts[j] then
      begin
        //-------------check intersect
        if i=1 then
        begin
          z1:=2; z2:=3;
        end;
        if i=2 then
        begin
          z1:=1; z2:=3;
        end;
        if i=3 then
        begin
          z1:=1; z2:=2;
        end;
        if j=1 then z3:=2 else z3:=1;
        if IsLinesIntersect(atr.pts[z1],atr.pts[z2],pts[j],pts[z3]) then
        begin
          Result:=True;
          exit;
        end;
      end;
    end;
  if IsPointIn(atr.pts[1]) or IsPointIn(atr.pts[2]) or IsPointIn(atr.pts[3]) then
  begin
    Result:=True;
    exit;
  end;
  if atr.IsPointIn(pts[1]) or atr.IsPointIn(pts[2]) or atr.IsPointIn(pts[3]) then
  begin
    Result:=True;
    exit;
  end;
end;

function TZTriangle.IsLineIntersect(p1, p2: TZPoint): boolean;
begin
  Result:=IsLinesIntersect(p1,p2,pts[1],pts[2]) or
              IsLinesIntersect(p1,p2,pts[2],pts[3]) or
              IsLinesIntersect(p1,p2,pts[1],pts[3]);
end;

function TZTriangle.IsPointIn(p: TZPoint): boolean;
var s1,s2,s3:integer;
begin
  Result:=False;
//  if not M2RectContainsPoint(Rect,M2Point(p.x,p.y)) then exit;
  s1:=Sign(TRSign(pts[1],pts[2],p));
  s2:=Sign(TRSign(pts[2],pts[3],p));
  s3:=Sign(TRSign(pts[3],pts[1],p));
  if (s1=s2) and( s1=s3) then Result:=True;
end;

procedure TZTriangle.LockLines;
var pp,p1,p2,p3:TZPoint;
    sign:extended;
begin
  p1:=lines[1].p1;
  p2:=lines[1].p2;
  if (lines[2].p1=p1) or (lines[2].p1=p2) then p3:=lines[2].p2 else p3:=lines[2].p1;
  sign:=TRSign(p1,p2,p3);
  if sign>0 then
  begin
      pts[1]:=p1;
      pts[2]:=p2;
      pts[3]:=p3;
//      lines[1].right:=self;
  end else
  begin
      pts[1]:=p1;
      pts[2]:=p3;
      pts[3]:=p2;
//      lines[1].left:=self;
  end;
  lines[1].SetSide(self,p1,p2,p3);
  lines[2].SetSide(self,p1,p2,p3);
  lines[3].SetSide(self,p1,p2,p3);
{  if sign>0 then lines[1].right:=self else lines[1].left:=self;

  p1:=lines[2].p1;
  p2:=lines[2].p2;
  if (lines[3].p1=p1) or (lines[3].p1=p2) then p3:=lines[3].p2 else p3:=lines[3].p1;
  sign:=TRSign(p1,p2,p3);
  if sign>0 then lines[2].right:=self else lines[2].left:=self;

  p1:=lines[3].p1;
  p2:=lines[3].p2;
  if (lines[1].p1=p1) or (lines[1].p1=p2) then p3:=lines[1].p2 else p3:=lines[1].p1;
  sign:=TRSign(p1,p2,p3);
  if sign>0 then
  begin
      lines[3].right:=self;
      pts[1]:=p1;
      pts[2]:=p2;
      pts[3]:=p3;
  end
      else
  begin
      lines[3].left:=self;
      pts[1]:=p2;
      pts[2]:=p1;
      pts[3]:=p3;
  end;}
end;

function TZLineTR.HavePoint(p: TZPoint): boolean;
begin
  Result:=(p1=p) or (p2=p);
end;

procedure TZLineTR.SetSide(tr: TZtriangle; ap1, ap2, ap3: TZPoint);
var pp:TZpoint;
    s:extended;
begin
  if HavePoint(ap1) then
  begin
    if HavePoint(ap2) then pp:=ap3 else pp:=ap2;
  end
  else pp:=ap1;
  s:=TRSign(p1,p2,pp);
  if s>0 then right:=tr else left:=tr;
end;

{ TZLineTRList }

function TZLineTRList.AddLine(p1, p2: TZPoint): TZLineTR;
var fl:TZLineTR;
    i:integer;
    sp,sp2:TZPoint;
begin
  if p1.x>p2.x then
  begin
    sp:=p1;
    p1:=p2;
    p2:=sp;
  end;
  for i:=0 to Count-1 do
  begin
    fl:=GetL(i);
    if (fl.p1=p1) and (fl.p2=p2) then
    begin
      Result:=fl;
      exit;
    end;
  end;
  fl:=TZLineTR.Create(p1,p2);
  Add(fl);
  Result:=fl;
end;

function TZLineTRList.GetL(index: integer): TZLineTR;
begin
  Result:=TZLineTR(Items[index]);
end;

{ TZTriangleList }

procedure TZTriangleList.FillXML(node: IXMLNode);
var i,j:integer;
    xn:IXMLNode;
    tr:TZTriangle;
begin
  node.ChildNodes.Clear;
  for i:=0 to Count-1 do
  begin
    tr:=GetTR(i);
    xn:=node.AddChild('TRNG');
    for j:=1 to 3 do
    begin
      xn.SetAttributeNS('X'+IntToStr(j),'',tr.pts[j].x);
      xn.SetAttributeNS('Y'+IntToStr(j),'',tr.pts[j].y);
    end;
  end;
end;

function TZTriangleList.GetTR(i: integer): TZTriangle;
begin
  Result:=TZTriangle(Items[i]);
end;

function TZTriangleList.GetTrWithP(p: TZPoint): TZTriangle;
var i:integer;
    tr:TZTriangle;
begin
  REsult:=nil;
  for i:=0 to Count-1 do
  begin
    tr:=GetTR(i);
    if tr.IsPointIn(p) then
    begin
      Result:=tr;
      exit;
    end;
  end;
end;

function TZTriangleList.IsLineIntersect(p1, p2: TZPoint): boolean;
var i:integer;
begin
  Result:=False;
  for  i:=0  to Count-1 do
  begin
    if GetTR(i).IsLineIntersect(p1,p2) then
    begin
      Result:=True;
      exit;
    end;
  end;

end;

function TZTriangleList.IsPointIn(p: TZPoint): boolean;
var i:integer;
begin
  Result:=True;
  for i:=0 to Count-1 do
  begin
    if GetTR(i).IsPointIn(p) then
    begin
      exit;
    end;
  end;
  Result:=False;
end;

function TZTriangle.ReCalcRect: TM2REct;
begin
  Result:=CalcRect;
  rect:=Result;
end;

end.
