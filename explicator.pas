unit explicator;

interface
uses M2Addon,M2AddonD,addn, SysUtils, classes;
type gdatarec=record
       h:boolean;
       id,a,d:string;
       x,y:real;

     end;
const
     bldNo=0;
     bldOld=1;
     bldNew=2;
var  pdata:array [1..10000] of gdatarec;
     pdatacount:integer;
     partcontours:array [1..500] of IM2Contour;
     partnames:array [1..500] of string;
     partkns:array [1..500] of string;
     newparts:array [1..500] of boolean;
     partcontourRect:array [1..500] of TM2REct;
     pblds:array [1..500] of integer;
     partcontourCount:integer;
     upartcontourCount:integer;

     updatacount:integer;
     upartcontours:array [1..500] of IM2Contour;
     upartnames:array [1..500] of string;
     upartkns:array [1..500] of string;
     umaxnum:integer;
function GetInContourSquare(main,lar:TM2ID):real;
procedure AddPart(cont:IM2Contour;stl:TM2ID);
procedure AddPart2(cont:IM2Contour;stl:TM2ID;pkn,pname:string);
function CalcAngle(x1, y1, x2, y2: real): string;
procedure  MakeParts(main:TM2ID;stll,bstll:TStringList);
procedure  MakeUParts(main:TM2ID;astl:string);
function IsUPart(im:Im2Contour):integer;
function MakeContRect(cont:IM2Contour):TM2REct;

implementation
uses math, frm, strutils;

function IsUPart(im:Im2Contour):integer;
var i:integer;
    imcp:Im2Contour;
    sq1,sq2:extended;
begin
  for i:=1 to upartcontourCount do
  begin
    im.i_Clone(imcp);
    sq1:=gAddon.GeometryLib.CalcContourSquare(imcp);
    gAddon.GeometryLib.ContourOperation(imcp,upartcontours[i],kcoAnd);
    sq2:=gAddon.GeometryLib.CalcContourSquare(imcp);
    if (sq2/sq1)>0.75 then
    begin
      Result:=i;
      exit;
    end;
  end;
  Result:=-1;
end;
function MakeContRect(cont:IM2Contour):TM2REct;
var i:integer;
    cmd:TM2ContourCommand;
    cont2:TM2Contour;
begin
  cont2.OleObject:=cont;
  cont2.GetCommand(0,cmd);
  REsult.X1:=cmd.MoveTo.Point.X;
  REsult.y1:=cmd.MoveTo.Point.y;
  REsult.X2:=cmd.MoveTo.Point.X;
  REsult.y2:=cmd.MoveTo.Point.y;
  for i:=1 to cont2.Count-1 do
  begin
    cont2.GetCommand(i,cmd);
    case cmd.CommandType of
    ccLineTo,ccMoveTo:
      begin

        REsult.X1:=Min(REsult.X1,cmd.MoveTo.Point.X);
        REsult.X2:=Max(REsult.X2,cmd.MoveTo.Point.X);
        REsult.Y1:=Min(REsult.y1,cmd.MoveTo.Point.y);
        REsult.Y2:=Max(REsult.y2,cmd.MoveTo.Point.y);
      end;
    end;
  end;
end;

function CalcAngle(x1, y1, x2, y2: real): string;
var an:real;
    g,m,s:integer;
begin
  an:=ArcTan2((y2-y1),(x2-x1));
  an:=an*360/(2*pi);
  if an<0 then an:=an+360;
  g:=Round(int(an));
  m:=Round(frac(an)*60);
  s:=Round(frac(an)*3600)mod 60;
  Result:=Format('%d°%d''%d"',[g,m,s]);
end;
function LLen(x1, y1, x2, y2: real): real;
begin
  REsult:=SQRT(SQR(x1-x2)+SQR(y1-y2));
end;

procedure AddPart(cont:IM2Contour;stl:TM2ID);
var i,c:integer;
    cmd:TM2ContourCommand;
begin
  inc(partcontourCount);
  partcontours[partcontourCount]:=cont;
  partcontourRect[partcontourCount]:=MakeContRect(cont);
  partkns[partcontourCount]:='';
  partnames[partcontourCount]:=gAddon2.ActiveDb.StyleFromID(stl).Name;
  inc(pdatacount);
  pdata[pdatacount].h:=True;
  pdata[pdatacount].id:=gAddon2.ActiveDb.StyleFromID(stl).Name;

  cont.i_GetCount(c);
  for i:=0 to c-1 do
  begin
    cont.i_GetCommand(i,cmd);
    case cmd.CommandType of
    ccMoveTo,ccLineTo:
    begin
      inc(pdatacount);
      pdata[pdatacount].h:=False;
      pdata[pdatacount].id:=IntToStr(i);
      pdata[pdatacount].x:=cmd.MoveTo.Point.X;
      pdata[pdatacount].Y:=cmd.MoveTo.Point.Y;
      if i>0 then
      begin
        pdata[pdatacount].a:=CalcAngle(pdata[pdatacount-1].x,pdata[pdatacount-1].y,
                                      pdata[pdatacount].x,pdata[pdatacount].y);
        pdata[pdatacount].d:=Format('%12.4f',[LLen(pdata[pdatacount-1].x,pdata[pdatacount-1].y,
                                      pdata[pdatacount].x,pdata[pdatacount].y)]);
      end;
    end;
    end;

  end;

end;

procedure AddPart2(cont:IM2Contour;stl:TM2ID;pkn,pname:string);
begin
  AddPart(cont,stl);
  partkns[partcontourCount]:=pkn;
  partnames[partcontourCount]:=pname;
end;

function GetInContourSquare(main,lar:TM2ID):real;
var oblist:IM2IDsList;
    rect:TM2Rect;
    i,cc,j,cc2:integer;
    obj,stl,larr:TM2ID;
    spl:IM2ShapeList;
    mcont,oldc,scont:IM2Contour;
    acc,sacc:real;
    cv:TM2ShapeList;
begin
  Result:=0;
  rect:=gAddon.MapObjects.GetObjectBounds(main);
  larr:=gAddon2.ActiveDb.StyleFromID(lar).Layer.ID;
  oblist:=gAddon.MapObjects.FindIntersectedObjects(larr,False,rect,False);
  oblist.i_GetCount(cc);

    spl:=gAddon.MapObjects.GetObjectShapeList(main);
    spl.i_GetCount(cc2);
    if cc2=0 then exit;
    for j:=0 to cc2-1 do
    begin
      spl.i_GetContour(j,mcont);
      if gAddon.GeometryLib.CalcContourSquare(mcont)>0 then break;
    end;
//  acc:=gAddon.GeometryLib.CalcContourSquare(mcont);
  acc:=0;
  for i:=0 to cc-1 do
  begin
    oblist.i_GetItem(i,obj);
    spl:=gAddon.MapObjects.GetObjectShapeList(obj);
    spl.i_GetCount(cc2);
    for j:=0 to cc2-1 do
    begin
      spl.i_GetContour(j,scont);
      spl.i_GetStyleID(j,stl);
      if stl<>lar then continue;
      if gAddon.GeometryLib.CalcContourSquare(scont)<=1e-4 then continue;
//        mcont.i_Clone(oldc);
      try
        gAddon.GeometryLib.ContourOperation(scont,mcont,kcoAnd);
        sacc:=gAddon.GeometryLib.CalcContourSquare(scont);
        acc:=acc+sacc;

//        if sacc>0.1 then AddPart(scont,stl);
      except
//        mcont:=oldc;
      end;
    end;
  end;
  Result:=acc;
end;

procedure  MakeUParts(main:TM2ID;astl:string);
var oblist:IM2IDsList;
    rect:TM2Rect;
    mi,i,cc,j,cc2,ti:integer;
    lar,obj,stl:TM2ID;
    spl:IM2ShapeList;
    mcont,oldc,scont:IM2Contour;
    acc,sacc:real;
    cv:TM2ShapeList;
    larlist:TStringList;
    pn,pk,ts:string;
begin
  umaxnum:=0;
  upartcontourCount:=0;
  rect:=gAddon.MapObjects.GetObjectBounds(main);
  lar:=gAddon2.ActiveDb.StyleFromID(astl).Layer.ID;
  oblist:=gAddon.MapObjects.FindIntersectedObjects(lar,False,rect,False);
  oblist.i_GetCount(cc);
  spl:=gAddon.MapObjects.GetObjectShapeList(main);
  spl.i_GetCount(cc2);
  if cc2=0 then exit;
  for j:=0 to cc2-1 do
  begin
    spl.i_GetContour(j,mcont);
    if gAddon.GeometryLib.CalcContourSquare(mcont)>0 then break;
  end;
  for i:=0 to cc-1 do
  begin
    oblist.i_GetItem(i,obj);
    spl:=gAddon.MapObjects.GetObjectShapeList(obj);
    spl.i_GetCount(cc2);
    for j:=0 to cc2-1 do
    begin
      spl.i_GetContour(j,scont);
      spl.i_GetStyleID(j,stl);
      if astl<>stl then continue;
      if gAddon.GeometryLib.CalcContourSquare(scont)<=1e-4 then continue;
      try
        gAddon.GeometryLib.ContourOperation(scont,mcont,kcoAnd);
        sacc:=gAddon.GeometryLib.CalcContourSquare(scont);
        if (sacc>0.1) then
        begin
          inc(upartcontourCount);
          upartcontours[upartcontourCount]:=scont;
          upartnames[upartcontourCount]:=MainForm.GetByFormat(obj,gpartname);
          upartkns[upartcontourCount]:=MainForm.GetByFormat(obj,gpartkn);
          ts:=RightStr(upartkns[upartcontourCount],3);
          if TryStrToInt(ts,ti) then
          begin
            if ti>umaxnum then
              umaxnum:=ti;
          end;
//        mcont:=oldc;
        end;
      except
      end;
     end;
   end;

end;

procedure  MakeParts(main:TM2ID;stll,bstll:TStringList);
var oblist:IM2IDsList;
    rect:TM2Rect;
    mi,i,cc,j,cc2,ucc:integer;
    lar,obj,stl:TM2ID;
    spl:IM2ShapeList;
    mcont,oldc,scont:IM2Contour;
    acc,sacc:real;
    cv:TM2ShapeList;
    larlist:TStringList;
    pn,pk:string;
begin
  MakeUParts(main,gpartborderstl);
  partcontourCount:=0;
  rect:=gAddon.MapObjects.GetObjectBounds(main);
  larlist:=TStringList.Create;
  for mi:=0 to stll.Count-1 do
  begin
    lar:=gAddon2.ActiveDb.StyleFromID(stll.Strings[mi]).Layer.ID;
    if larlist.IndexOf(lar)=-1 then
      larlist.Add(lar);
  end;
  for mi:=0 to larlist.Count-1 do
  begin
    lar:=larlist.Strings[mi];
    oblist:=gAddon.MapObjects.FindIntersectedObjects(lar,False,rect,False);
    oblist.i_GetCount(cc);

    spl:=gAddon.MapObjects.GetObjectShapeList(main);
    spl.i_GetCount(cc2);
    if cc2=0 then exit;
    for j:=0 to cc2-1 do
    begin
      spl.i_GetContour(j,mcont);
      if gAddon.GeometryLib.CalcContourSquare(mcont)>0 then break;
    end;
    for i:=0 to cc-1 do
    begin
      oblist.i_GetItem(i,obj);
      spl:=gAddon.MapObjects.GetObjectShapeList(obj);
      spl.i_GetCount(cc2);
      for j:=0 to cc2-1 do
      begin
        spl.i_GetContour(j,scont);
        spl.i_GetStyleID(j,stl);
        if stll.IndexOf(stl)=-1 then continue;
        if gAddon.GeometryLib.CalcContourSquare(scont)<=1e-4 then continue;
        try
          gAddon.GeometryLib.ContourOperation(scont,mcont,kcoAnd);
          sacc:=gAddon.GeometryLib.CalcContourSquare(scont);

          if (sacc>0.1) then
          begin
             ucc:=IsUPart(scont);
             if  (ucc=-1) then
             begin
               AddPart(scont,stl);
               inc(umaxnum);
               partkns[partcontourCount]:=Format('%.3d',[umaxnum]);
               newparts[partcontourCount]:=True;
//               if MainForm.bld
               if bstll.IndexOf(stl)=-1 then
                 pblds[partcontourCount]:=bldNo else
                 pblds[partcontourCount]:=bldNew;
             end
             else
             begin
               pn:=upartnames[ucc];
               pk:=upartkns[ucc];
               AddPart2(scont,stl,pk,pn);
               newparts[partcontourCount]:=False;
               if bstll.IndexOf(stl)=-1 then
                 pblds[partcontourCount]:=bldNo else
                 pblds[partcontourCount]:=bldOld;
             end;
          end; //if
        except
//        mcont:=oldc;
        end;
    end;
  end;

  end; {mi}
//  SetPartNumbers;
end;

end.
