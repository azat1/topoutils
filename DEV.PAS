

unit dev;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, ClipBrd, ComObj, M2Addon,Explicator, variants, StrUtils, Ingeo_TLB;
const
  scales:array [1..10] of integer=
  (10,25,50,100,200,500,1000,2000,5000,10000);
type
  TCoordData=class
      constructor Create(aname:string);
    public
      name:string;
      count:integer;
      x,y:array [1..1000] of real;
  end;
  TPlanDrawer = class
    constructor  Create;
  public
    ptn,ang,len:array [1..5000] of string;
    scale:integer;
    dpi:integer;
    bt:TBitMap;
    tbt:TBitMap;
    ptop:integer;
    ptcount:integer;
    partcoords:TList;
    ptx,pty:array [1..5000] of real;
    cptcount:integer;
    cptx,cpty:array [1..5000] of real;
    zowner,zcadnom, zaddr, zmaker, cadnombegin,n1,n2,n3,n4 :string;
    sms:array [0..5000,0..3] of string;
    smcount:integer;
    pash,pw,ph,e1,e2,e3,e4,sf:real;
    expl:boolean;
    dname:string;
    obj:TM2ID;
    prevlots:string;
    procedure DrawPlan2(bt:TBitMap);
    procedure DrawPlanT;
    procedure DrawContour(bt:TBitmap);
    procedure DrawContourRed(bt:TBitmap);
    procedure SaveToWord;
  private
    ssf,savepoints:TStringList;
    geotable:integer;
    procedure SelectScale(wx,wy,mx,my:real);
    function CVX(x:real):integer;
    function CalcAngle(x1,y1,x2,y2:real):string;
    procedure SelectDelta(var ma:real;j:integer);
    procedure LoadOptions;
    procedure OutSemdata(w:variant;wfield,sfield:string);
    procedure OutCoords(w:variant;table:string);
    procedure OutPartCoords(w:variant;table:string);
    procedure OutSmezes(w:variant;table:string);
    procedure OutExplication(w:variant;table:string);
    procedure OutMainImage(w:variant;bookm:string);
    procedure OutSquare(w:variant;bookm:string);
    procedure OutScale(w:variant;bookm:string);
    procedure OutPerim(w:variant;bookm:string);
    function llen(x1,y1,x2,y2:real):string;
    procedure OutPoints(w:variant;bookm:string);
    procedure OutLines(w:variant;bookm:string);
    procedure OutKvartal(w:variant;bookm:string);
    procedure OutF1_1(w:variant);
    procedure OutF1_2(w:variant);
    procedure OutF1_3(w:variant);
    procedure OutAbrises(w:variant);
    function GetCategoryN(s:string):integer;
    function GetSquareWithPrecision:string;
    function GetObjData(obj:TM2ID; field: string):string;
    function GetByFormat(obj: TM2ID; field: string): string;
    function Calc(obj: TM2ID; expr: string): string;
    function FormatResult(res, fmt: string): string;
    procedure OutGeoData1(w:variant;bookm:string);
    procedure OutGeoData2(w:variant;bookm:string);
    procedure OutSquare1(w:variant;bookm:string);
    procedure OutSquare2(w:variant;bookm:string);
    procedure OutCadNum1(w:variant;bookm:string);
    procedure OutCadNum2(w:variant;bookm:string);
    procedure OutCadNumOld(w:variant;bookm:string);

    //(w:variant;table:string);

    { Private declarations }
  public
    kvnumber,oldkn,newkn1,newkn2,sq1,sq2:string;
    obj1,obj2:string;
    parr:array [0..10000] of TM2Point;
    pnames:array [0..10000] of string;
    parrcount:integer;
    function GetPN(x,y:real):string;
    function S:real;
    function Perim:real;

    { Public declarations }
  end;


implementation
uses towrd,Word_TLB,frm, addn, raschets, abrises;


constructor TPlanDrawer.Create;
begin
  inherited;
  partcoords:=TList.Create;
{  bt:=TBitmap.Create;
  bt.Width:=1200;
  bt.Height:=1200;
  bt.PixelFormat:=pf1bit;
  tbt:=TBitmap.Create;
  tbt.Width:=1200;
  tbt.Height:=1200;
  tbt.PixelFormat:=pf1bit;\}
end;



procedure TPlanDrawer.SelectScale(wx, wy, mx, my: real);
var i:integer;
begin
  for i:=2 to 10 do
  begin
    if ((wx/scales[i])<my) and ((wy/scales[i])<mx) then
    begin
      scale:=scales[i];
      exit;
    end;
  end;
end;

function TPlanDrawer.CVX(x: real): integer;
begin
  Result:=Round(x/scale/0.0254*dpi);
end;


function TPlanDrawer.CalcAngle(x1, y1, x2, y2: real): string;
var an:real;
begin
  an:=ArcTan2((y2-y1),(x2-x1));
  an:=an*360/(2*pi);
  if an<0 then an:=an+360;
  Result:=Format('%.0f° %.1f''',[an,Frac(an)*60]);
//  Result:=IntToStr(Round(an))+' '+
//         (Round() div 60)+''' '+
//         IntToStr(Round(Frac(an)*3600) mod 60)+'"';
end;

function TPlanDrawer.S: real;
var i:integer;
    sq:real;
begin
  sq:=0;
  REsult:=gAddon2.ActiveDb.MapObjects.GetObject(obj).Square;
{  for i:=1 to ptcount do
  begin
    sq:=sq+(ptx[i]+ptx[i+1])*(pty[i+1]-pty[i]);
  end;
  Result:=Abs(sq/2);}
end;

procedure TPlanDrawer.DrawPlan2(bt:TBitMap);
var elsize,i,rx,tx,ty:integer;
    maxy,maxx,miny,minx,dx,dy,a:real;
    cx,cy,maxdx,maxdy:real;
begin
  with bt.Canvas do
  begin
    Brush.Style:=bsSolid;
    Brush.Color:=clWhite;
    Pen.Style:=psClear;
    Rectangle(0,0,bt.Width,bt.Height);
    Pen.Style:=psSolid;
  end;
  SetBkMode(bt.Canvas.Handle,TRANSPARENT);
//  dpi:=300;
  bt.Canvas.Font.Name:='Arial Cyr';
  bt.Canvas.Font.Height:=40*dpi div 300;
  elsize:=3*dpi div 300;
  if elsize=0 then elsize:=1;
  maxy:=pty[1];  maxx:=ptx[1];  miny:=pty[1];  minx:=ptx[1];
  for i:=2 to ptcount do
  begin
    if pty[i]>maxy then maxy:=pty[i];
    if pty[i]<miny then miny:=pty[i];
    if ptx[i]>maxx then maxx:=ptx[i];
    if ptx[i]<minx then minx:=ptx[i];
  end;
  dx:=maxx-minx;
  dy:=maxy-miny;
  maxdx:=bt.Width/dpi*0.0254;
  maxdy:=bt.Height/dpi*0.0254;
  SelectScale(dx,dy,maxdx,maxdy);
  cx:=(maxdy*scale-dx)/2;
  cy:=(maxdx*scale-dy)/2;
  bt.Canvas.Pen.Color:=clBlack;
  rx:=bt.Height;
  with bt.Canvas do
  begin
    MoveTo(CVX(pty[1]-miny+cy),-CVX(ptx[1]-minx+cx)+rx);
    for i:=2 to ptcount+1 do
    begin
      LineTo(CVX(pty[i]-miny+cy),-CVX(ptx[i]-minx+cx)+rx);
    end;
    for i:=1 to ptcount do
    begin
      Ellipse(CVX(pty[i]-miny+cy)-elsize,-CVX(ptx[i]-minx+cx)-elsize+rx,
              CVX(pty[i]-miny+cy)+elsize,-CVX(ptx[i]-minx+cx)+elsize+rx);
      SelectDelta(a,i);
      ty:=Round(sin(a)*elsize*13);
      tx:=Round(cos(a)*elsize*13);
      tx:=tx-TextWidth(ptn[i]) div 2;
      ty:=ty+TextHeight(ptn[i]) div 2;
      TextOut(CVX(pty[i]-miny+cy)+tx,-CVX(ptx[i]-minx+cx)+rx-ty,ptn[i]);
    end;
  end;
//  DrawPlanT;
//  tbt.TransparentColor:=clWhite;
//  bt.Canvas.CopyMode:=cmMergePaint;
//  bt.Canvas.Draw(0,0,tbt);
end;

procedure TPlanDrawer.DrawPlanT;
var i,rx:integer;
    maxy,maxx,miny,minx,dx,dy:real;
    cx,cy,maxdx,maxdy:real;
    pnts:array [1..1000] of TPoint;
begin
  with tbt.Canvas do
  begin
    Brush.Style:=bsSolid;
    Brush.Color:=clBlack;
    Pen.Style:=psClear;
    Rectangle(0,0,bt.Width,bt.Height);
    Pen.Style:=psSolid;
  end;
  maxy:=pty[1];  maxx:=ptx[1];  miny:=pty[1];  minx:=ptx[1];
  for i:=2 to ptcount do
  begin
    if pty[i]>maxy then maxy:=pty[i];
    if pty[i]<miny then miny:=pty[i];
    if ptx[i]>maxx then maxx:=ptx[i];
    if ptx[i]<minx then minx:=ptx[i];
  end;

  dx:=maxx-minx;
  dy:=maxy-miny;
  maxdx:=bt.Width/dpi*0.0254;
  maxdy:=bt.Height/dpi*0.0254;
  SelectScale(dx,dy,maxdx,maxdy);
  cx:=(maxdy*scale-dx)/2;
  cy:=(maxdx*scale-dy)/2;

  rx:=tbt.Height;

  for i:=1 to ptcount do
  begin
    pnts[i].x:=CVX(pty[i]-miny+cy);
    pnts[i].y:=-CVX(ptx[i]-minx+cx)+rx;
  end;

  with tbt.Canvas do
  begin
    Brush.Style:=bsSolid;
    Brush.Color:=clWhite;
    Polygon(Slice(pnts,ptcount));
  end;

end;


procedure TPlanDrawer.DrawContour(bt:TBitMap);
var i,rx:integer;
    maxy,maxx,miny,minx,dx,dy:real;
    cx,cy,maxdx,maxdy:real;
begin
  bt.Canvas.Pen.Style:=psSolid;
  bt.Canvas.Pen.Color:=clBlack;
  SetBkMode(bt.Canvas.Handle,TRANSPARENT);
//  dpi:=300;
  bt.Canvas.Font.Name:='Arial Cyr';
  bt.Canvas.Font.Height:=40*dpi div 300;
  maxy:=pty[1];  maxx:=ptx[1];  miny:=pty[1];  minx:=ptx[1];
  for i:=2 to ptcount do
  begin
    if pty[i]>maxy then maxy:=pty[i];
    if pty[i]<miny then miny:=pty[i];
    if ptx[i]>maxx then maxx:=ptx[i];
    if ptx[i]<minx then minx:=ptx[i];
  end;
  dx:=maxx-minx;
  dy:=maxy-miny;
  maxdx:=bt.Width/dpi*0.0254;
  maxdy:=bt.Height/dpi*0.0254;
  SelectScale(dx,dy,maxdx,maxdy);
  cx:=(maxdy*scale-dx)/2;
  cy:=(maxdx*scale-dy)/2;

  rx:=bt.Height;
  with bt.Canvas do
  begin
    MoveTo(CVX(cpty[1]-miny+cy),-CVX(cptx[1]-minx+cx)+rx);
    for i:=2 to cptcount+1 do
    begin
      LineTo(CVX(cpty[i]-miny+cy),-CVX(cptx[i]-minx+cx)+rx);
    end;
  end;

end;

procedure TPlanDrawer.DrawContourRed(bt:TBitmap);
var i,rx:integer;
    maxy,maxx,miny,minx,dx,dy:real;
    cx,cy,maxdx,maxdy:real;
begin
  bt.Canvas.Pen.Style:=psSolid;
  bt.Canvas.Pen.Color:=clRed;

//  SetBkMode(bt.Canvas.Handle,TRANSPARENT);
  bt.Canvas.Font.Name:='Arial Cyr';
  bt.Canvas.Font.Height:=40;
  maxy:=pty[1];  maxx:=ptx[1];  miny:=pty[1];  minx:=ptx[1];
  for i:=2 to ptcount do
  begin
    if pty[i]>maxy then maxy:=pty[i];
    if pty[i]<miny then miny:=pty[i];
    if ptx[i]>maxx then maxx:=ptx[i];
    if ptx[i]<minx then minx:=ptx[i];
  end;
  dx:=maxx-minx;
  dy:=maxy-miny;
  maxdx:=bt.Width/dpi*0.0254;
  maxdy:=bt.Height/dpi*0.0254;
  SelectScale(dx,dy,maxdx,maxdy);
  cx:=(maxdy*scale-dx)/2;
  cy:=(maxdx*scale-dy)/2;

  rx:=bt.Height;
  with bt.Canvas do
  begin
    MoveTo(CVX(cpty[1]-miny+cy),-CVX(cptx[1]-minx+cx)+rx);
    for i:=2 to cptcount+1 do
    begin
      LineTo(CVX(cpty[i]-miny+cy),-CVX(cptx[i]-minx+cx)+rx);
    end;
  end;

end;


function TPlanDrawer.Perim: real;
var i:integer;
    p:real;
begin
  p:=0;
  for i:=1 to ptcount do
  begin
    p:=p+StrToFloat(len[i]);
  end;
  Result:=p;
end;



procedure TPlanDrawer.SaveToWord;
var s1,s2,lft,top,wdt,hgt,anchor:OleVariant;
    i,cc,lw:integer;
    addr,fl,tss,sv:string;
    wapp:Variant;

begin
  savepoints:=TStringList.Create;
  LoadOptions;
  fl:=ExtractFilePath(ParamStr(0))+'temp.bmp';
  if not PacketMode then
  try
    wapp:=GetActiveOleObject('Word.Application');
  except
    wapp:=CreateOLEObject('Word.Application');
  end else wapp:=CreateOLEObject('Word.Application');

  s2:=False;
  wapp.Documents.Add(s1,s2);
//  bt.PixelFormat:=pf8bit;

  cc:=wapp.ActiveDocument.Bookmarks.Count;
  for i:=1 to cc do
  begin
    tss:=wapp.ActiveDocument.Bookmarks.Item(i).Name;
    if ssf.Values[tss]<>'' then
    begin
      sv:=ssf.Values[tss];
      if sv='Площадь участка 1' then
      begin
        OutSquare1(wapp,tss);
        continue;
      end;
      if sv='Площадь участка 2' then
      begin
        OutSquare2(wapp,tss);
        continue;
      end;
      if sv='Кадастровый номер старый' then
      begin
        OutCadNumOld(wapp,tss);
        continue;
      end;
      if sv='Кадастровый номер новый 1' then
      begin
        OutCadNum1(wapp,tss);
        continue;
      end;
      if sv='Кадастровый номер новый 2' then
      begin
        OutCadNum2(wapp,tss);
        continue;
      end;
      if sv='Границы и точки 1' then
      begin
        OutGeoData1(wapp,tss);
        continue;
      end;
      if sv='Границы и точки 2' then
      begin
        OutGeoData2(wapp,tss);
        continue;
      end;
      if sv='Изображение участка полное' then
      begin
        OutMainImage(wapp,tss);
        continue;
      end;
      if sv='Номер квартала' then
      begin
        OutKvartal(wapp,tss);
        continue;
      end;
      OutSemdata(wapp,tss,sv);
    end;
  end;

  wapp.Visible:=True;
//  cc:=DataModule2.tSmez.RecordCount;
end;

procedure TPlanDrawer.SelectDelta(var ma:real;j:integer);
var MaxS,a,ox,oy:real;
begin
  a:=0;
  ox:=ptx[j];
  oy:=pty[j];
  maxS:=0;
  ma:=a;
  repeat
    ptx[j]:=ox+sin(a)*2;
    pty[j]:=oy+cos(a)*2;
    if S>maxS then
    begin
      maxS:=S;
      ma:=a;
    end;
    a:=a+0.1;
  until a>(2*Pi);
  ptx[j]:=ox;
  pty[j]:=oy;
end;

procedure TPlanDrawer.LoadOptions;
var
    i:integer;
    s:string;
begin
  s:=Copy(s,1,Length(s)-4)+'.ini';
  ssf:=TStringList.Create;
  try
  ssf.LoadFromFile(s);
  except
  end;
  try
  geotable:=ifthen(ssf.Values['GeodataOutTable']<>'',
                   StrToInt(ssf.Values['GeodataOutTable']),1);
  except
  end;
end;

procedure TPlanDrawer.OutCoords(w: variant; table: string);
var s1,s2,s3,s4,s5,s6:OleVariant;
    tbl:variant;
    i:integer;
    strm:string;
begin
//***********************************
//  w.ActiveDocument.Bookmarks.
  s1:=table;
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  tbl:=w.Selection.Tables.Item(s1);
//  .Tables.Items(s2);
  if ptcount=0 then exit;
try
  tbl.Rows.Item(2).Select;
  w.Selection.InsertRows(ptcount);
{  for i:=1 to ptcount-1 do
  begin
    s2:=tbl.Rows.Item(2);
    tbl.Rows.Add(s2);
  end;}
  for i:=1 to ptcount do
  begin
    tbl.Cell(i+1,1).Select;
    w.Selection.InsertAfter(ptn[i]);
    if ssf.Values['GeoDataCoordsOut']='1' then
    begin
    tbl.Cell(i+1,2).Select;
    w.Selection.TypeText(Format('%12.4f',[ptx[i]]));

    tbl.Cell(i+1,3).Select;
    w.Selection.TypeText(Format('%12.4f',[pty[i]]));
    end;

    if ssf.Values['GeoDataCoordsOut']='1' then
    begin
    tbl.Cell(i+1,4).Select;
    w.Selection.TypeText(ang[i]);

    tbl.Cell(i+1,5).Select;
    w.Selection.TypeText(len[i]);
    end;
  end;
  except
    on E:Exception do ShowMessage('Ошибка вывода координат:'+e.Message);
  end;

end;

procedure TPlanDrawer.OutExplication(w: variant; table: string);
begin
end;

procedure TPlanDrawer.OutSemdata(w: variant; wfield, sfield: string);
var tss:string;
    s1:OleVariant;
begin
    try
      s1:=wfield;
      w.ActiveDocument.Bookmarks.Item(s1).Select;
      w.Selection.TypeText(tss);
//      Result:=tss;
    except
      ShowMessage('Поле документа '+wfield+' не найдено!');
    end;
end;

procedure TPlanDrawer.OutSmezes(w: variant; table: string);
var s1,s2:OleVariant;
    tbl:variant;
    i:integer;
begin
//***********************************
//  w.ActiveDocument.Bookmarks.
  s1:=table;
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  tbl:=w.Selection.Tables.Item(s1);
//  .Tables.Items(s2);
  if smcount=0 then exit;
try
  tbl.Rows.Item(2).Select;
  w.Selection.InsertRows(smcount);

  for i:=0 to smcount do
  begin
    tbl.Cell(i+2,1).Select;
    w.Selection.InsertAfter(sms[i,0]);
    tbl.Cell(i+2,2).Select;
    w.Selection.InsertAfter(sms[i,1]);
    tbl.Cell(i+2,3).Select;
    w.Selection.InsertAfter(sms[i,3]);
    tbl.Cell(i+2,4).Select;
    w.Selection.InsertAfter(sms[i,2]);
  end;
  except
    on E:Exception do ShowMessage('Ошибка вывода смежеств:'+e.Message);

  end;

end;

{ TCoordData }

constructor TCoordData.Create(aname: string);
begin
end;

procedure TPlanDrawer.OutPartCoords(w: variant; table: string);
var s1,s2:OleVariant;
    tbl:variant;
    i:integer;
begin
//***********************************
//  w.ActiveDocument.Bookmarks.
  s1:=table;
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  tbl:=w.Selection.Tables.Item(s1);
//  .Tables.Items(s2);
  if pdatacount=0 then exit;
try
  tbl.Rows.Item(2).Select;
  w.Selection.InsertRows(pdatacount);

  for i:=1 to pdatacount do
  begin
    tbl.Cell(i+1,1).Select;
    w.Selection.InsertAfter(pdata[i].id);
    if pdata[i].h then
    begin
      s1:=i+1;
      tbl.Rows.Item(s1).Select;
      w.Selection.Cells.Merge;
      continue;
    end;
    if ssf.Values['GeoDataCoordsOut']='1' then
    begin
    tbl.Cell(i+1,2).Select;
    w.Selection.InsertAfter(Format('%12.4f',[pdata[i].x]));

    tbl.Cell(i+1,3).Select;
    w.Selection.InsertAfter(Format('%12.4f',[pdata[i].y]));
    end;

    if ssf.Values['GeoDataCoordsOut']='1' then
    begin
    tbl.Cell(i+1,4).Select;
    w.Selection.InsertAfter(pdata[i].a);

    tbl.Cell(i+1,5).Select;
    w.Selection.InsertAfter(pdata[i].d);
    end;
  end;
  except
  end;

end;

procedure TPlanDrawer.OutMainImage(w: variant; bookm: string);
var fl:string;
    s1,s2,s3,anchor,shape:olevariant;
    lw,lft,wdt,hgt:real;
begin
    fl:=ExtractFilePath(ParamStr(0))+'temp.bmp';
    bt.SaveToFile(fl);

    try
    s1:=bookm;
    s3:=1;
  //  DrawPlan2;
    w.ActiveDocument.Bookmarks.Item(s1).Select;
    w.Selection.MoveRight;
    s2:=w.ActiveDocument.Bookmarks.Item(s1).Range;
//    w.ActiveDocument.Bookmarks.Item(s1).Range.Paragraphs.Item(s3).;
    lw:=w.ActiveDocument.PageSetup.PageWidth-w.ActiveDocument.PageSetup.LeftMargin-
        w.ActiveDocument.PageSetup.RightMargin;
    lft:=(lw-ph/2.54*72)/2;
    wdt:=ph/2.54*72;
    hgt:=pw/2.54*72;

    anchor:= w.ActiveDocument.Bookmarks.Item(s1).Range;
    shape:=w.ActiveDocument.Shapes.AddPicture(fl,,,0{lft},0{top},wdt,hgt,anchor);
    shape.ConvertToInlineShape;
    s1:=1;
//    w.ActiveDocument.Shapes.Item(s1).WrapFormat.Type:=0;
    except
     on E:Exception do ShowMessage('Ошибка вывода изображения:'+e.Message);
    end;

end;

procedure TPlanDrawer.OutPerim(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,Format('%12.2f',[Perim]));
end;

procedure TPlanDrawer.OutScale(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,Format('%d',[scale]));

end;

procedure TPlanDrawer.OutSquare(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,Format('%12.0f',[S]));
end;

procedure TPlanDrawer.OutLines(w: variant; bookm: string);
var i,p1,p2,z:integer;
    s1,s2,s3,s4,s5,s6:OleVariant;
    tbl:variant;
    dss,sts,strm:string;

begin

  s1:=bookm;
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  z:=3;
  tbl:=w.Selection.Tables.Item(s1);


end;

procedure TPlanDrawer.OutPoints(w: variant; bookm: string);
var Z,i:integer;
    s1,s2,s3,s4,s5,s6:OleVariant;
    tbl:variant;
    sts,strm:string;

begin
  s1:=bookm;
//  gpprec:=f
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  z:=4;
  tbl:=w.Selection.Tables.Item(s1);
end;

function TPlanDrawer.llen(x1, y1, x2, y2: real): string;
var r:real;
begin
  r:=SQRT(SQR(x1-x2)+SQR(y1-y2));
  Result:=Format('%12.2f',[r]);
end;

procedure TPlanDrawer.OutF1_1(w: variant);
var n,i:integer;
begin
end;

procedure TPlanDrawer.OutF1_2(w: variant);
var tbl:variant;
    i,c:integer;
    tn:string;
    s1:OLEVariant;
begin
  if Trim(gright)='' then exit;
  tn:=Copy(gright,2,Length(gright)-2);
  Delete(tn,Pos('.',tn),500);
  s1:='ПРАВА';

  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  tbl:=w.Selection.Tables.Item(s1);
  c:=gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetRecCount(tn);
  for i:=0 to c-1 do
  begin
    tn:= GetByFormat(obj,gright);
         tbl.Cell(i+7,2).Select;
         w.Selection.InsertAfter(IntToStr(i+1));
         tbl.Cell(i+7,3).Select;
         w.Selection.InsertAfter(tn);
    tn:= GetByFormat(obj,grsubj);
         tbl.Cell(i+7,4).Select;
         w.Selection.InsertAfter(tn);
  end;
end;

procedure TPlanDrawer.OutF1_3(w: variant);
var tbl:variant;
    i,c:integer;
    tn,pn:string;
    s1:OLEVariant;
begin
//  tn:=Copy(gright,2,Length(gright)-2);
//  Delete(tn,Pos('.',tn),500);
  s1:='ЧАСТИ';

  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  tbl:=w.Selection.Tables.Item(s1);
//  c:=gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetRecCount(tn);
  for i:=1 to partcontourCount do
  begin
    tn:= partnames[i];
    pn:=RightStr( partkns[i],3);
         tbl.Cell(i+6,2).Select;
         w.Selection.InsertAfter(pn);
         tbl.Cell(i+6,3).Select;
         w.Selection.InsertAfter(Format('%.0f кв.м',[gAddon.GeometryLib.CalcContourSquare(partcontours[i]) ]));
         tbl.Cell(i+6,4).Select;
         w.Selection.InsertAfter(tn);

  end;
end;

function TPlanDrawer.GetCategoryN(s: string): integer;
begin
  Result:=8;
  if (Pos('сель',s)<>0) and (Pos('хоз',s)<>0) then Result:=1;
  if (Pos('поселен',s)<>0) then Result:=2;
  if (Pos('населен',s)<>0) then Result:=2;
  if (Pos('пром',s)<>0) then Result:=3;
  if (Pos('особ',s)<>0) and (Pos('охран',s)<>0) then Result:=4;
  if (Pos('лесн',s)<>0) then Result:=5;
  if (Pos('водн',s)<>0) then Result:=6;
  if (Pos('запас',s)<>0) then Result:=7;
end;

function TPlanDrawer.GetSquareWithPrecision: string;
var t,ds,gs:extended;
    ts:string;
begin
  t:=0.2;
  ds:=0.0;
  ts:=MainForm.GetByFormat(obj,gdocsq);
  MTryStrToFloat(Trim(ts),ds);
  if gsqtype then
  begin
    ds:=ds;
    ts:=MainForm.GetByFormat(obj,gpprec);
    MTryStrToFloat(Trim(ts),t);
    Result:=Format('%.0f кв.м ± %.0f',[S, 3.5*t*SQRT(ds)]);
  end else
  begin
    ds:=ds;
    ts:=MainForm.GetByFormat(obj,gpprec);
    MTryStrToFloat(Trim(ts),t);
    gs:=s/10000;
    Result:=Format('%.4f га ± %.4f',[gS, 0.035*t*SQRT(ds)]);
  end;

end;


function TPlanDrawer.Calc(obj: TM2ID; expr: string): string;
var r:TfRaschet;
begin
 //*********
  r:=TfRaschet.Create;
  Result:=FloatToStr(r.Calc1(expr));
  expr:=Trim(expr);
  if Copy(expr,1,1)=',' then
  begin
    Delete(expr,1,1);
    expr:=Trim(expr);
//    REsult:=FormatResult(REsult,expr);
  end;
  if Copy(expr,1,1)='%' then
  begin
//    Delete(expr,1,1);
    REsult:=FormatResult(REsult,expr);
  end;
  r.Free;

end;

function TPlanDrawer.FormatResult(res, fmt: string): string;
begin
  try
    Result:=Format(fmt,[StrToFloat(res)]);
  except
    REsult:=REs;
  end;
end;


function TPlanDrawer.GetByFormat(obj: TM2ID; field: string): string;
var s:string;
begin
  s:=field;
  Result:='';

  while (Pos('[',s)<>0) and (Pos(']',s)<>0) do
  begin
    try
    Result:=Result+Copy(s,1,Pos('[',s)-1)+
        Calc(obj,Copy(s,Pos('[',s)+1,Pos(']',s)-Pos('[',s)-1));

    Delete(s,1,Pos(']',s));
    except
      on e:Exception do
      begin
        ShowMessage('?????? ?????????? '+field);
      end;
    end;
  end;
//  Result:=Result+s;
  s:=Result+s;
  REsult:='';
  while (Pos('{',s)<>0) and (Pos('}',s)<>0) do
  begin
    try
    Result:=Result+Copy(s,1,Pos('{',s)-1)+
        GetObjData(obj,Copy(s,Pos('{',s)+1,Pos('}',s)-Pos('{',s)-1));
    Delete(s,1,Pos('}',s));
    except
      on e:Exception do
      begin
        Delete(s,1,Pos('}',s));
        ShowMessage('?????? ?????????? '+field);
      end;
    end;

  end;
  Result:=Result+s;
end;

function TPlanDrawer.GetObjData(obj: TM2ID; field: string): string;
var t,f,s:string;
    tc,i:integer;
    v:olevariant;
begin
  REsult:='';
  t:=Copy(field,1,Pos('.',field)-1);
  f:=Copy(field,Pos('.',field)+1,200);
  tc:=gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetRecCount(t);
//  gAddon2.ActiveDb.LayerFromID(gAddon2.ActiveDb.MapObjects.GetObject(obj).LayerID).SemTables.Item[i].LinkType

  if Pos('.',f)>0 then
  begin
    s:=Copy(f,Pos('.',f)+1,200);
    f:=Copy(f,1,Pos('.',f)-1);
    i:=StrToInt(s);
    if (i+1)>tc then exit;
    try
      v:=gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetDisplayText(t,f,i);
//    v:=VarToStr(gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetValue(t,f,i));
    except
//      on e:Exception do if not gnoerrors then ShowMessage('?????? ?????????? 2 {'+t+'.'+f+'}');
    end;
    if VarIsNull(v) then exit;
    s:=v;
    Result:=s;
    exit;
  end;

  s:='';
  for i:=0 to tc-1 do
  begin
    if i>0 then s:=s+',';
    try
    v:='';
    v:=gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetDisplayText(t,f,i);
//    v:= VarToStr(gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetValue(t,f,i));
    except
//      on e:Exception do if not gnoerrors then ShowMessage('?????? ?????????? 1 {'+t+'.'+f+'}');
    end;
    if VarIsNull(v) then continue;
    s:=s+v;
  end;
  Result:=s;
end;

procedure TPlanDrawer.OutAbrises(w: variant);
var i,p1,p2,z,r,c:integer;
    shape,anchor,s1,s2,s3,s4,s5,s6:OleVariant;
    tbl:variant;
    strm,fl:string;
    wdt,hgt:real;
begin
  if MainForm.abrcount=0 then exit;
  s1:='АБРИСЫ';
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  s1:=1;
  tbl:=w.Selection.Tables.Item(s1);
  tbl.Rows.Item(2).Select;
  w.Selection.InsertRows(MainForm.abrcount div 2+1);

  for i:=0 to MainForm.abrCount-1 do
  begin
    try
      r:=i div 2+2;
      c:=i mod 2+1;
      ;
      fl:=ExtractFilePath(ParamStr(0))+'atemp.bmp';
      MainForm.abrlist[i].b.SaveToFile(fl);
      if MainForm.abrlist[i].b=nil then continue;
//    w.ActiveDocument.Bookmarks.Item(s1).Range.Paragraphs.Item(s3).;
      wdt:=250/ares*72;
      hgt:=250/ares*72;
      anchor:= tbl.Cell(r,c).Range;
      shape:=w.ActiveDocument.Shapes.AddPicture(fl,,,0{lft},0{top},wdt,hgt,anchor);
      shape.ConvertToInlineShape;
      tbl.Cell(r,c).Select;
      w.Selection.InsertBefore(MainForm.abrlist[i].pn+#13#10);
    except
    end;
  end;     //for


end;

procedure TPlanDrawer.OutKvartal(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,kvnumber);
end;

procedure TPlanDrawer.OutCadNum1(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,newkn1);

end;

procedure TPlanDrawer.OutCadNum2(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,newkn2);

end;

procedure TPlanDrawer.OutCadNumOld(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,oldkn);

end;

procedure TPlanDrawer.OutGeoData1(w: variant; bookm: string);
var mobj:IIngeoMapObject;
    i,j,k:integer;
    contr:IIngeoContour;
    contrp:IIngeoContourPart;
    bwx,bwy,wx,wy,pwx,ll,pwy,wcc:double;
    s1:OleVariant;
    pn,ang:string;
begin
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(obj1);
  s1:=bookm;
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  for i:=0 to mobj.Shapes.Count-1 do
  begin
    contr:=mobj.Shapes.Item[i].Contour;
    for j:=0 to contr.Count-1 do
    begin
      contrp:=contr.Item[j];
      contrp.GetVertex(0,wx,wy,wcc);
      bwx:=wx;bwy:=wy;
      pwx:=wx;pwy:=wy;
//      w.Selection.TypeText(pn);
      for k:=0 to contrp.VertexCount-2 do
      begin
        contrp.GetVertex(k,wx,wy,wcc);
        contrp.GetVertex(k+1,pwx,pwy,wcc);
        pn:=GetPN(wx,wy);
        w.Selection.TypeText(pn);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wx]));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wy]));
        ang:=CalcAngle(wx,wy,pwx,pwy);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(ang);
        ll:=SQRT(SQR(wx-pwx)+SQR(wy-pwy));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[ll]));
        w.Selection.MoveRight(wdCell);
      end;
      if contrp.Closed then
      begin
        contrp.GetVertex(contrp.VertexCount-1,wx,wy,wcc);
        contrp.GetVertex(0,pwx,pwy,wcc);
        pn:=GetPN(wx,wy);
        w.Selection.TypeText(pn);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wx]));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wy]));
        ang:=CalcAngle(wx,wy,pwx,pwy);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(ang);
        ll:=SQRT(SQR(wx-pwx)+SQR(wy-pwy));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[ll]));
        w.Selection.MoveRight(wdCell);
      end;
    end;
  end;

end;

procedure TPlanDrawer.OutGeoData2(w: variant; bookm: string);
var mobj:IIngeoMapObject;
    i,j,k:integer;
    contr:IIngeoContour;
    contrp:IIngeoContourPart;
    bwx,bwy,wx,wy,pwx,ll,pwy,wcc:double;
    s1:OleVariant;
    pn,ang:string;
begin
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(obj2);
  s1:=bookm;
  w.ActiveDocument.Bookmarks.Item(s1).Select;
  for i:=0 to mobj.Shapes.Count-1 do
  begin
    contr:=mobj.Shapes.Item[i].Contour;
    for j:=0 to contr.Count-1 do
    begin
      contrp:=contr.Item[j];
      contrp.GetVertex(0,wx,wy,wcc);
      bwx:=wx;bwy:=wy;
      pwx:=wx;pwy:=wy;
//      w.Selection.TypeText(pn);
      for k:=0 to contrp.VertexCount-2 do
      begin
        contrp.GetVertex(k,wx,wy,wcc);
        contrp.GetVertex(k+1,pwx,pwy,wcc);
        pn:=GetPN(wx,wy);
        w.Selection.TypeText(pn);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wx]));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wy]));
        ang:=CalcAngle(wx,wy,pwx,pwy);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(ang);
        ll:=SQRT(SQR(wx-pwx)+SQR(wy-pwy));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[ll]));
        w.Selection.MoveRight(wdCell);
      end;
      if contrp.Closed then
      begin
        contrp.GetVertex(contrp.VertexCount-1,wx,wy,wcc);
        contrp.GetVertex(0,pwx,pwy,wcc);
        pn:=GetPN(wx,wy);
        w.Selection.TypeText(pn);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wx]));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[wy]));
        ang:=CalcAngle(wx,wy,pwx,pwy);
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(ang);
        ll:=SQRT(SQR(wx-pwx)+SQR(wy-pwy));
        w.Selection.MoveRight(wdCell);
        w.Selection.TypeText(Format('%.1f',[ll]));
        w.Selection.MoveRight(wdCell);
      end;
    end;
  end;

end;

procedure TPlanDrawer.OutSquare1(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,sq1);
end;

procedure TPlanDrawer.OutSquare2(w: variant; bookm: string);
begin
  OutSemdata(w,bookm,sq2);
end;

function TPlanDrawer.GetPN(x, y: real): string;
var i:integer;
    l:real;
begin
  Result:='';
  for i:=0 to parrcount-1 do
  begin
    l:=SQRT(SQR(x-parr[i].X)+SQR(y-parr[i].Y));
    if l<1e-3 then
    begin
      Result:=pnames[i];
      exit;
    end;
  end;
end;

end.
