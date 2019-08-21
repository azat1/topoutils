unit geom;

interface
uses Classes, Windows;

type
     TGeometry=class
       public
         lx:array [0..10000] of extended;
         ly:array [0..10000] of extended;
         count:integer;
         maxx,minx,maxy,miny:extended;
         function IsPointIn(x,y:extended):boolean;
         function IsIntersect(x1,y1,x2,y2,ax1,ay1,ax2,ay2:extended):boolean;
         function GetLineK(x1,y1,x2,y2:extended):extended;
         function GetLineB(x1,y1,x2,y2:extended):extended;
         function GetIntersectX(k1,b1,k2,b2:extended):extended;
     end;
implementation

function TGeometry.GetLineK(x1,y1,x2,y2:extended):extended;
begin
  if abs(y2-y1)<0.00001 then Result:=0 else
  Result:=(x2-x1)/(y2-y1);
end;

function TGeometry.GetLineB(x1,y1,x2,y2:extended):extended;
begin
  Result:=x1-GetLineK(x1,y1,x2,y2)*y1;
end;

function TGeometry.GetIntersectX(k1,b1,k2,b2:extended):extended;
begin
  if abs(k1-k2)<0.00001 then result:=0 else
  Result:=(b2-b1)/(k1-k2);
end;

function TGeometry.IsIntersect(x1,y1,x2,y2,ax1,ay1,ax2,ay2:extended):boolean;
var k1,k2,b1,b2,x,y,v:extended;
    r,r2:TRect;
    p:TPoint;
begin
  k1:=GetLineK(x1,y1,x2,y2);
  b1:=GetLineB(x1,y1,x2,y2);

  k2:=GetLineK(ax1,ay1,ax2,ay2);
  b2:=GetLineB(ax1,ay1,ax2,ay2);

  y:=GetIntersectX(k1,b1,k2,b2);

  x:=k1*y+b1;
  if x1>x2 then
  begin
    v:=x1;
    x1:=x2;
    x2:=v;
  end;

  if ax1>ax2 then
  begin
    v:=ax1;
    ax1:=ax2;
    ax2:=v;
  end;


  if (x>=x1) and (x<=x2) and (x>=ax1) and (x<=ax2) then Result:=True else Result:=False;
end;

function TGeometry.IsPointIn(x,y:extended):boolean;
var cc,i:integer;
    vx,vy:extended;
begin
  Result:=False;
  maxx:=lx[0];
  maxy:=ly[0];
  minx:=lx[0];
  miny:=ly[0];
  lx[count]:=lx[0];
  ly[count]:=ly[0];
  for i:=1 to Count-1 do
  begin
    if lx[i]>maxx then maxx:=lx[i];
    if lx[i]<minx then minx:=lx[i];
    if ly[i]>maxy then maxy:=ly[i];
    if ly[i]<miny then miny:=ly[i];
  end;
  if (x>maxx) or (x<minx) or (y>maxy) or (y<miny) then exit;

  vx:=Random*maxx;
  vy:=maxy+10000;
  cc:=0;
  for i:=0 to Count-1 do
  begin
    if IsIntersect(lx[i],ly[i],lx[i+1],ly[i+1],x,y,vx,vy) then
      inc(cc);
  end;
  if Odd(cc) and (cc>0) then Result:=True else Result:=False;
end;

end.
