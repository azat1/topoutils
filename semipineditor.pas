unit semipineditor;

interface
uses Windows, M2Addon, M2AddonD, addn, math, Forms, sysutils, graphics, stdctrls, Ingeo_TLB;

type
    TSemiPinPointSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
    function CalcPoint2(x1, y1, x2, y2: double; p: TM2Point; d: double;
      var res: TM2Point): boolean;
    public

      pointselecting:boolean;
      npx,npy:double;
      nearpoint:boolean;
      callform:TForm;
      eX,eY:TEdit;
      cx,cy,er:double;
      pcount:integer;
      rtype:integer;
      angle:double;
      styleid:string;
      nearobj:IINgeoMapObject;
      nearshape:IIngeoShape;
      nearcntr:IIngeoContourPart;
      nearindex:integer;
      commlayer:string;
      pinstyle:string;
      p1,p2, cpp:TM2Point;
      mobjs:IIngeoMapObjects;
      selectedobj:IIngeoMapObject;
      selectedcnt:IIngeoContourPart;
      selectedpnt:integer;
//      findobj:IINgeoMapObject;
      constructor Create(anAddon:TFad;cform:TForm);
      destructor Destroy; override;
      function GetEditorOptions: TM2EditorOptions; override;

      procedure HideDragging; override;
      procedure ShowDragging(aMouse: TPoint); override;

      procedure MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint); override;
      procedure MouseMove(aShift: TM2ShiftState; aMouse: TPoint); override;
      procedure Calculate;

      function GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList; override;
      procedure ExecuteMacro(aCmd: Longint; const aParams: TM2String); override;
      procedure DrawPoints;
      function FindPoint(p:TM2Point):TM2Point;
      function LineLength(p1,p2:TM2Point):real;
  		procedure Notification(AWhat: TM2EditorNotification); override;
      procedure DrawNearPoint;
      procedure FindNearPoint(mx,my:integer);
      function GetObjectNearPoint(oid:string;x,y:double;var fx,fy:double;maxd:double):boolean;
      procedure DrawPolygon;
      procedure CreateObject;
    end;

function SelectPoint(f:TForm;var x,y:double):boolean;

implementation
uses linzasechka, InScripting_TLB;
function SelectPoint(f:TForm;var x,y:double):boolean;
begin

end;

{ TLZPointSelector }

procedure TSemiPinPointSelector.Calculate;
var
  I: Integer;
  ap1,ap2,lp1,lp2,ip,ip2:tm2point;
  a,b,c,aa,bb,cc,ml,l:extended;
  ps,rps:double;
  mq:IIngeoMapObjectsQuery;
  mobj:IIngeoMapObject;
  shp:IIngeoShape;
  cntp:IIngeoContourPart;
  larid,objid:widestring;
  spi:integer;
  j: Integer;
  vi: Integer;
  pp1,pp2:TM2Point;
  x1,y1,x2,y2,cv:double;
begin
  ml:=1e20;
  ps:=gAddon.MapView.SizeFromDevice(5);
  if commlayer='' then
    exit;
  mq:=mobjs.QueryByRect(commlayer,p1.X-ps,p1.Y-ps,p1.X+ps,p1.Y+ps,False);
  ml:=1e20;
  selectedobj:=nil;
  selectedcnt:=nil;
  selectedpnt:=-1;
  while not mq.EOF do
  begin
    mq.Fetch(larid,objid,spi);
    mobj:=mobjs.GetObject(objid);
    for i := 0 to mobj.Shapes.Count - 1 do
    begin
      if mobj.Shapes.Item[i].DefineGeometry then
      begin
        shp:=mobj.Shapes.Item[i];
        for j := 0 to shp.Contour.Count - 1 do
        begin
          cntp:=shp.Contour.Item[j];
          for vi := 0 to cntp.VertexCount - 1 do
          begin
            cntp.GetVertex(vi,x1,y1,cv);
            if (vi=(cntp.VertexCount-1)) then
            begin
              if cntp.Closed then
                cntp.GetVertex(0,x2,y2,cv) else break;
            end else
              cntp.GetVertex(vi+1,x2,y2,cv);
            if CalcPoint2(x1,y1,x2,y2,p1,ps,p2) then
            begin
              l:=SQRT(SQR(p1.X-p2.X)+SQR(p1.Y-p2.Y));
              if l<ml then
              begin
                selectedobj:=mobj;
                selectedcnt:=cntp;
                selectedpnt:=vi;
                ml:=l;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSemiPinPointSelector.CalcPoint2(x1,y1,x2,y2:double;p:TM2Point;d:double;var res:TM2Point): boolean;
var lp1,lp2,p2:TM2Point;
    a,b,c,aa,bb,cc,l:extended;
begin
  lp1.X:=x1;lp2.X:=x2;
  lp1.Y:=y1;lp2.Y:=y2;
     a:=lp1.y-lp2.Y;
     b:=-(lp1.X-lp2.X);
     c:=lp1.X*lp2.Y-lp2.X*lp1.Y;
     aa:=-b;
     bb:=a;
     //c=-ax-by;
     cc:=-aa*p1.X-bb*p1.Y;
     p2.X:=(b*cc-c*bb)/(a*bb-aa*b);
     p2.Y:=(c*aa-cc*a)/(a*bb-aa*b);
     if (p2.X<=max(lp1.X,lp2.X)) and (p2.X>=min(lp1.X,lp2.X)) and
        (p2.y<=max(lp1.y,lp2.y)) and (p2.y>=min(lp1.y,lp2.y)) then
     begin

       l:=sqrt(sqr(p.X-p2.X)+sqr(p.Y-p2.Y));
       if l<d then
       begin
         REsult:=True;
         res:=p2;
       end else REsult:=False;
     end else Result:=False;

end;

constructor TSemiPinPointSelector.Create(anAddon: TFad;cform:TForm);
begin
  inherited Create;
  faddn:=anAddon;
  pointselecting:=False;
//  showsolves:=False;
  callform:=cform;
  angle:=0;
  pcount:=1;
  mobjs:=gAddon2.ActiveDb.MapObjects;
end;

procedure TSemiPinPointSelector.CreateObject;
var
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    lar:string;
    cntp:IIngeoContourPart;
    cc,ind:integer;
    dist,wx,wy,x1,y1,x2,y2,cv:double;
    style:string;
    ev,pv,lv:TM2Point;
  I,pcc: Integer;
  ilar:IIngeoLayer;
  pinlar:string;
begin
  if selectedobj=nil then
  begin
    MessageBox(0,'Не выбрана линия!','Создание опор',MB_OK+MB_ICONSTOP);
    exit;
  end;

  selectedcnt.InsertVertex(selectedpnt+1,p2.x,p2.y,0);

  ind:=selectedpnt+1;
  if ind=selectedcnt.VertexCount then
    ind:=0;
  selectedcnt.GetVertex(ind,x2,y2,cv);
      pinlar:= gAddon2.ActiveDb.StyleFromID(pinstyle).Layer.ID;
      mobj:=mobjs.AddObject(pinlar);
      shp:=mobj.Shapes.Insert(-1,pinstyle);
      cntp:=shp.Contour.Insert(-1);
      cntp.InsertVertex(-1,p2.X,p2.y,0);

  mobjs.UpdateChanges;
end;

destructor TSemiPinPointSelector.Destroy;
begin

  inherited;
end;

procedure TSemiPinPointSelector.DrawNearPoint;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    wx,wy,wd:double;
    surf:IIngeoPaintSurface;
begin
  if selectedobj<>nil then
  begin
    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    wx:=p2.X;wy:=p2.Y;
    surf:=gAddon2.MainWindow.MapWindow.Surface;
    wd:=Surf.SizeDeviceToWorld(10);
    cntp:=cntr.Insert(-1);
    cntp.InsertVertex(-1,wx-wd,wy-wd,0);
    cntp.InsertVertex(-1,wx+wd,wy-wd,0);
    cntp.InsertVertex(-1,wx+wd,wy+wd,0);
    cntp.InsertVertex(-1,wx-wd,wy+wd,0);
    Surf.Pen.Style:=inpsSolid;
    Surf.Pen.Color:=clRed;
    Surf.Pen.Mode:=inpmXor;
    surf.PaintContour(cntr,true);
    exit;
  end;
//  gAddon2.MainWindow.MapWindow.Surface.
end;

procedure TSemiPinPointSelector.DrawPoints;
begin

end;

procedure TSemiPinPointSelector.DrawPolygon;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    wx,wy,wd,r:double;
    surf:IIngeoPaintSurface;
  i: Integer;
begin
    if rtype=0 then
    begin
      r:=er/cos(Pi/pcount);
    end else
    begin
      r:=er;
    end;

    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    surf:=gAddon2.MainWindow.MapWindow.Surface;
    wd:=Surf.SizeDeviceToWorld(3);
    cntp:=cntr.Insert(-1);

    for i := 0 to pCount - 1 do
    begin
      wx:=npx+r*cos(angle+2*pi*i/pcount);
      wy:=npy+r*sin(angle+2*pi*i/pcount);
      cntp.InsertVertex(-1,wx,wy,0);
    end;
    cntp.Closed:=True;
    Surf.Pen.Style:=inpsSolid;
    Surf.Pen.Color:=clGray;
    Surf.Pen.Mode:=inpmXor;
    surf.Brush.Style:=inbsClear;
    surf.PaintContour(cntr,true);
end;

procedure TSemiPinPointSelector.ExecuteMacro(aCmd: Integer;
  const aParams: TM2String);
begin
  inherited;

end;

procedure TSemiPinPointSelector.FindNearPoint(mx,my:integer);
var mq:IIngeoMapObjectsQuery;
    i:integer;
    vmap:IIngeoVectorMap;
    mv:IIngeoMapView;
    lars:array of string;
  mi,li: Integer;
  larcount: integer;
  fx,fy,wd,wx,wy,x1,y1,x2,y2:double;
  foid,larid:widestring;
  l,spi:integer;
  tl,ml: double;
begin
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(mx,my,wx,wy);
  wd:=gAddon2.MainWindow.MapWindow.Surface.SizeDeviceToWorld(10);
  mq:=gAddon2.ActiveDb.MapObjects.QueryByRect(commlayer,wx-wd,wy-wd,wx+wd,wy+wd,false);
  nearpoint:=False;
  ml:=wd;
  while Not mq.EOF do
  begin
    mq.Fetch(larid,foid,spi);
    if GetObjectNearPoint(foid,wx,wy,fx,fy,wd) then
    begin
      nearpoint:=True;
      tl:=SQRT(SQR(wx-fx)+SQr(wy-fy));
      if tl<ml then
      begin
        npx:=fx;npy:=fy;
        ml:=tl;
      end;
    end;
  end;
  if not nearpoint then
  begin
    npx:=wx;
    npy:=wy;
  end;
end;

function TSemiPinPointSelector.FindPoint(p: TM2Point): TM2Point;
begin

end;

function TSemiPinPointSelector.GetContextMacroList(
  aMouse: TPoint): IM2ContextMacroAttrsList;
begin

end;

function TSemiPinPointSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or eopDragging or eopNotification;
end;

function TSemiPinPointSelector.GetObjectNearPoint(oid: string;x,y:double; var fx, fy: double;
  maxd: double): boolean;
var obj:IIngeoMapObject;
  si: Integer;
  sp:IIngeoShape;
  ci: Integer;
  cntp:IIngeoContourPart;
  vi: Integer;
  wx,wy,cv,ml,l:double;
begin
  obj:=gAddon2.ActiveDb.MapObjects.GetObject(oid);
  ml:=maxd;
  REsult:=False;
  for si := 0 to obj.Shapes.Count - 1 do
  begin
    sp:=obj.Shapes.Item[si];
    if not sp.DefineGeometry then continue;
    for ci := 0 to sp.Contour.Count - 1 do
    begin
      cntp:=sp.Contour.Item[ci];
      for vi := 0 to cntp.VertexCount - 1 do
      begin
        cntp.GetVertex(vi,wx,wy,cv);
        if (abs(wx-x)>maxd) or (abs(wy-y)>maxd)  then continue;
        l:=SQRT(SQR(x-wx)+SQR(y-wy));
        if l<ml then
        begin
          ml:=l;
          Result:=True;
          fx:=wx;fy:=wy;
        end;
      end;
    end;
  end;
end;

procedure TSemiPinPointSelector.HideDragging;
begin
  inherited;
  DrawNearPoint;
end;

function TSemiPinPointSelector.LineLength(p1, p2: TM2Point): real;
begin

end;

procedure TSemiPinPointSelector.MouseDown(aButton: TM2MouseButton;
  aShift: TM2ShiftState; aMouse: TPoint);
var cf:TfLinZasechka;
begin
  inherited;
  if aButton=kmbLeft then
     CreateObject;
end;

procedure TSemiPinPointSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
  inherited;
  HideDragging;
  p1:=gAddon.MapView.PointFromDevice(aMouse);
  Calculate;
  ShowDragging(aMouse);
end;

procedure TSemiPinPointSelector.Notification(AWhat: TM2EditorNotification);
begin
  inherited;

end;

procedure TSemiPinPointSelector.ShowDragging(aMouse: TPoint);
begin
  inherited;
  DrawNearPoint;
end;

end.
