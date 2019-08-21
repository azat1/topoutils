unit abrises;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, CheckLst,m2addon,m2addond, ExtCtrls;
const
  ares:integer=100;
type
  TPList=record
    pl:array [0..1000] of TM2Point;
    l:array [0..1000] of real;
    count:integer;
  end;
  TBArr=array [0..100] of boolean;
  TAbris=record
    b:TBitmap;
    szs:array [0..100] of real;
    szb:TBArr;
    pn:string;
  end;

  PPList=^TPList;
  TfAbrises = class(TForm)
    Button1: TButton;
    dgA: TDrawGrid;
    clbPointList: TCheckListBox;
    Label1: TLabel;
    clbSizes: TCheckListBox;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure clbPointListClick(Sender: TObject);
    procedure dgADrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure clbSizesClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    astll:TStringList;
    lpointlist:array [0..1000] of TM2Point;
    procedure LoadStyles;
    procedure SaveStyles;
    procedure LoadPointList;
    procedure UpdateImage(i:integer);
    function MakeImage(p:TM2Point;sa:TAbris):TAbris;
    function FindPoints(p:TM2Point;sz:extended):PPList;
    function LLen(p1,p2:TM2Point):real;
    function SelectNear(p:TM2Point;pl:PPList;c:integer):PPList;
    function MakeRect(p:TM2Point;pl:PPList):TM2REct;
    procedure DrawSizes(p:TM2Point;sp:PPList;b:TBitmap;cent:TM2Point;scale:real;szb:TBArr);
    procedure MakeSizeList(n:integer);
    { Private declarations }
  public
    abrlist:array [0..1000] of TAbris;
    { Public declarations }
  end;

var
  fAbrises: TfAbrises;
  function AddP(pl:PPList;p:TM2Point):integer;
implementation
uses mselstyle, addn , frm, math;
{$R *.dfm}

function AddP(pl:PPList;p:TM2Point):integer;
var i:integer;
begin
  Result:=0;
  for i:=0 to pl.count-1 do
  begin
    if (abs(p.X-pl.pl[i].X)<0.5) and (abs(p.Y-pl.pl[i].Y)<0.5) then
    begin
     Result:=i;
     exit;
    end;
  end;
  pl.pl[pl.count]:=p;
  inc(pl.count);
end;

procedure TfAbrises.Button1Click(Sender: TObject);
var ms:TfMSelectStyle;
begin
  ms:=TfMSelectStyle.Create(self,astll);
  ms.ShowModal;
end;

procedure TfAbrises.LoadStyles;
var c,i:integer;
begin
  astll:=TStringList.Create;
  c:=StrToInt(gAddon.Preferences.GetString(kprProject,kNoID,'k_ABRISESTYLECOUNT','0'));
  for i:=0 to c-1 do
  begin
    astll.Add(gAddon.Preferences.GetString(kprProject,kNoID,'k_ABRISESTYLE'+IntToStr(i),''));
  end;
end;

procedure TfAbrises.SaveStyles;
var c,i:integer;
begin
//  astll:=TStringList.Create;
  gAddon.Preferences.SetString(kprProject,kNoID,'k_ABRISESTYLECOUNT',IntToStr(astll.Count));
  for i:=0 to astll.Count-1 do
  begin

    gAddon.Preferences.SetString(kprProject,kNoID,'k_ABRISESTYLE'+IntToStr(i),astll.Strings[i]);
  end;
end;

procedure TfAbrises.FormShow(Sender: TObject);
begin
  LoadPointList;
  LoadStyles;
end;

procedure TfAbrises.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveStyles;
end;

procedure TfAbrises.LoadPointList;
var i:integer;
begin
end;

procedure TfAbrises.clbPointListClick(Sender: TObject);
begin
  if clbPointList.Checked[clbPointList.ItemIndex] then
  begin
    UpdateImage(clbPointList.ItemIndex);
    dgA.Col:=clbPointList.ItemIndex mod 2;
    dgA.Row:=clbPointList.ItemIndex div 2;
    dgA.Repaint;

  end;
  MakeSizeList(clbPointList.ItemIndex);
end;

procedure TfAbrises.UpdateImage(i: integer);
var p:TM2Point;
    b:TAbris;
begin
  p:=lpointlist[i];
  b:=MakeImage(p,abrlist[i]);
  abrlist[i]:=b;
//  Image1.Picture.Bitmap:=b;
end;

function TfAbrises.MakeImage(p: TM2Point;sa:TAbris):TAbris;
var vp,sp:PPList;
    sz,scale:extended;
    r:TM2REct;
    fn:string;
    cent:TM2Point;
    b:TBitmap;
    i:integer;
begin
  b:=nil;
  fn:=ExtractFilePath(ParamStr(0))+'atemp.bmp';
  sz:=50;
  vp:=FindPoints(p,sz);
  sp:=SelectNear(p,vp,5);
  r:=MakeRect(p,sp);
//  {$O-}
  if sp.count=0 then
  begin
//    b:=TBitmap.Create;
//    b:=nil;
    Result.b:=nil;
    exit;
  end;
//  {$O+}
  cent.x:=(r.X1+r.X2)/2;
  cent.y:=(r.y1+r.y2)/2;
  scale:=Min(2/((r.x2-r.x1)/0.0254),2/((r.Y2-r.Y1)/0.0254))/1.1;
  gAddon2.ActiveProjectView.MakeImageFile(ares,ares,250,
                                      250,cent.X,cent.Y,scale,90,True,clWhite,fn);
  b:=TBitmap.Create;
  b.LoadFromFile(fn);
  DrawSizes(p,sp,b,cent,scale,sa.szb);
  REsult.b:=b;
  FillChar(sa.szs,SizeOf(sa.szs),0);
  for i:=0 to sp.count-1 do
  begin
    Result.szs[i]:=sp.l[i];
    Result.szb:=sa.szb;
  end;
end;

function TfAbrises.FindPoints(p: TM2Point; sz: extended): PPList;
var r:TM2Rect;
    objl:TM2IDsList;
    i,si,ci:integer;
    spl:TM2ShapeList;
    cont:TM2Contour;
    cmd:TM2ContourCommand;
    l:real;
begin
  New(Result);
  Result.count:=0;
  r:=M2Rect(p.X-sz,p.Y-sz,p.X+sz,p.Y+sz);
  objl.OleObject:= gAddon.MapObjects.FindIntersectedObjects(kNoID,False,r,False);
  for i:=0 to objl.Count-1 do
  begin
    spl.OleObject:=gAddon.MapObjects.GetObjectShapeList(objl.Items(i));
    for si:=0 to spl.Count-1 do
    begin
      if astll.IndexOf(spl.StyleIDs(si))<>-1 then
      begin
        cont.OleObject:=spl.Contours(si);
        for ci:=0 to cont.Count-1 do
        begin
          cont.GetCommand(ci,cmd);
          case cmd.CommandType of
          ccLineTo,ccMoveTo:
            begin
              l:=LLen(p,cmd.MoveTo.Point);
              if (l<sz) and (l>0.5) then
              begin
//                l:=LLen(p,cmd.MoveTo.Point);
                AddP(Result,cmd.MoveTo.Point);
              end //if
            end;
          end; //case
        end; //for ci
      end;  //if
    end;   //for si
  end;    //for i
end;

function TfAbrises.LLen(p1, p2: TM2Point): real;
begin
  Result:=SQRT(SQR(p1.X-p2.X)+SQR(p1.Y-p2.Y));
end;

function TfAbrises.SelectNear(p: TM2Point; pl: PPList;c:integer): PPList;
var ci,i,fi:integer;
    minl:real;
begin
  New(Result);
  Result.count:=0;
  for i:=0 to pl.count-1 do
  begin
    pl.l[i]:=LLen(p,pl.pl[i]);
  end;
  for ci:=1 to c do
  begin
    minl:=1e10;
    fi:=-1;
    for i:=0 to pl.count-1 do
    begin
      if pl.l[i]<minl then
      begin
        fi:=i;
        minl:=pl.l[i];
      end;
    end;
    if fi<>-1 then
    begin
      Result.pl[Result.count]:=pl.pl[fi];
      Result.l[Result.count]:=pl.l[fi];
      inc(Result.count);
      pl.l[fi]:=1e10;
    end;
  end;
end;

function TfAbrises.MakeRect(p: TM2Point; pl: PPList): TM2REct;
var i:integer;
begin
  Result:=M2Rect(p.X,p.Y,p.X,p.Y);
  for i:=0 to pl.count-1 do
  begin
    REsult.X1:=Min(Result.X1,pl.pl[i].X);
    REsult.Y1:=Min(Result.y1,pl.pl[i].y);
    REsult.X2:=Max(Result.X2,pl.pl[i].X);
    REsult.y2:=Max(Result.y2,pl.pl[i].y);
  end;
end;

procedure TfAbrises.dgADrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var i:integer;
begin
  i:=arow*2+acol;
  if abrlist[i].b<>nil then
  begin
    dgA.Canvas.TextOut(rect.Left+1,rect.Top+1,clbPointList.Items.Strings[i]);
    dgA.Canvas.Draw(rect.Left+10,rect.Top+20,abrlist[i].b);
  end;
end;

procedure TfAbrises.DrawSizes(p: TM2Point; sp: PPList; b: TBitmap;
  cent: TM2Point; scale: real;szb:TBArr);
var dx,dy:real;
    i:integer;
    function M2X(x:real):integer;
    begin
      Result:=Round(-x*scale*1000/25.4*ares+dx);
    end;

    function M2Y(y:real):integer;
    begin
      Result:=Round(y*scale*1000/25.4*ares+dy);
    end;
    function CalcAngle2(p1, p2: TM2Point): real;
    var an:real;
    begin
      an:=ArcTan2((p2.y-p1.y),(p2.x-p1.x));
    //  if an<0 then an:=an+2*pi;
      Result:=an;
    end;
    procedure DrawArrow(p1,p2:TM2Point);
    var a,a1,a2,arlen,ai:real;
    begin
      a:=CalcAngle2(p1,p2);
      a1:=a-pi/6;
      a2:=a+pi/6;
      arlen:=0.002/scale;//Round(gpointsize*(Image3.Picture.Bitmap.Width/(gplsize.X*10)));
      with b.Canvas do
      begin
        MoveTo(M2Y(p1.Y),M2X(p1.X));
        LineTo(M2Y(p1.Y+arlen*sin(a1)),M2X(p1.X+arlen*cos(a1)));
        MoveTo(M2Y(p1.Y),M2X(p1.X));
        LineTo(M2Y(p1.Y+arlen*sin(a2)),M2X(p1.X+arlen*cos(a2)));

      end;
    end;

    procedure DrawSizeText(p1,p2:TM2Point;fmtstr:string);
    var a,a1,a2,arlen:real;
        z:TM2Point;
        dc:HDC;
        hf:HFONT;
        x,y,ai,dx,dy:integer;
        sstr:string;
    begin
      sstr:=Format(fmtstr,[LLen(p1,p2)]);
      a:=CalcAngle2(p1,p2);
      if a<0 then a:=a+pi*2;
      if a>pi then
      begin
        z:=p1;
        p1:=p2;
        p2:=z;
        a:=CalcAngle2(p1,p2);
      end;
      arlen:=LLen(p1,p2)/2;
      ai:=Round((-a+pi/2)*180/pi*10);
      x:=M2Y(p1.Y+arlen*sin(a));
      y:=M2X(p1.X+arlen*cos(a));
      dx:={Round(gfontdx/25.4*ares)+}Round(gfontheight/25.4*ares*1.5)+4;
      a1:=a-pi/2;
      x:=Round(x+sin(a1)*dx);
      y:=Round(y-cos(a1)*dx);

      dy:=Round(gfontdy/25.4*ares);
      with B.Canvas do
      begin
          Font.Name:='Arial';
          Font.Height:=Round(gfontheight/25.4*ares*2);
          SetBkMode(Handle,TRANSPARENT);
          dc:=Handle;
          hf:=CreateFont(-Round(gfontheight/25.4*ares*1.5),0,ai,ai,0,0,0,0,
                      ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,
                      DEFAULT_QUALITY,DEFAULT_PITCH,'Arial');
          SelectObject(dc,hf);
          SetTextAlign(dc,TA_CENTER);
          SetTextColor(dc,clRed);
          Windows.TextOut(dc,x,y,pchar(sstr),Length(sstr));


      end;
    end;
var ps:integer;
begin
  ps:=Round(1/25.4*ares);
  dx:=-(-cent.X*scale/0.0254*ares-b.Height div 2);
  dy:=-(cent.Y*scale/0.0254*ares-b.Width div 2);
  b.Canvas.Pen.Color:=clRed;
  for i:=0 to sp.count-1 do
  begin
    if not szb[i] then continue;
    b.Canvas.MoveTo(m2y(sp.pl[i].Y),m2x(sp.pl[i].x));
    b.Canvas.LineTo(m2y(p.Y),m2x(p.x));

    DrawSizeText(p,sp.pl[i],'%.2f');
    DrawArrow(p,sp.pl[i]);
    DrawArrow(sp.pl[i],p);
  end;
  b.Canvas.Ellipse(m2y(p.Y)-ps,m2x(p.X)-ps,m2y(p.Y)+ps,m2x(p.X)+ps);
//  b.Canvas.Text(m2y(p.Y)-ps,m2x(p.X)+ps,);
end;

procedure TfAbrises.MakeSizeList(n: integer);
var i:integer;
begin
  //---------------
  clbSizes.Clear;
  for i:=0 to 100 do
  begin
    if  SameValue(abrlist[n].szs[i],0,0.1) then break;
    clbSizes.Items.Add(Format('%.2f',[ abrlist[n].szs[i]]));
    clbSizes.Checked[clbSizes.Count-1]:=abrlist[n].szb[i];
  end;
end;

procedure TfAbrises.clbSizesClick(Sender: TObject);
begin
  abrlist[clbPointList.ItemIndex].szb[clbSizes.ItemIndex]:=
      clbSizes.Checked[clbSizes.ItemIndex];
  if clbPointList.Checked[clbPointList.ItemIndex] then
  begin
    UpdateImage(clbPointList.ItemIndex);
    dgA.Repaint;
  end;

end;

procedure TfAbrises.Button3Click(Sender: TObject);
var i:integer;
begin
  for i:=0 to clbPointList.Count-1 do
  begin
    clbPointList.Checked[i]:=True;
    clbPointList.ItemIndex:=i;
    clbPointListClick(self);
  end;
end;

end.
