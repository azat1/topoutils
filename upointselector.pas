unit upointselector;

interface
uses Windows, M2Addon, M2AddonD, addn, math, Forms, sysutils, graphics, stdctrls;

type
    TUPointSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
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
      constructor Create(anAddon:TFad;cform:TForm);
      destructor Destroy; override;
      function GetEditorOptions: TM2EditorOptions; override;

      procedure HideDragging; override;
      procedure ShowDragging(aMouse: TPoint); override;

      procedure MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint); override;
      procedure MouseMove(aShift: TM2ShiftState; aMouse: TPoint); override;

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
uses Ingeo_TLB, linzasechka, InScripting_TLB;
function SelectPoint(f:TForm;var x,y:double):boolean;
begin

end;

{ TLZPointSelector }

constructor TUPointSelector.Create(anAddon: TFad;cform:TForm);
begin
  inherited Create;
  faddn:=anAddon;
  pointselecting:=False;
//  showsolves:=False;
  callform:=cform;
  angle:=0;
  pcount:=1;
end;

procedure TUPointSelector.CreateObject;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    wx,wy,wd,r:double;
    surf:IIngeoPaintSurface;
  i: Integer;
    objs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    larid,stlid:string;
    shp:IIngeoShape;
begin
    objs:=gAddon2.ActiveDb.MapObjects;
    if rtype=0 then
    begin
      r:=er/cos(Pi/pcount);
    end else
    begin
      r:=er;
    end;
    larid:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.ID;
    stlid:=styleid;
    obj:=objs.AddObject(larid);
    shp:=obj.Shapes.Insert(-1,stlid);

    cntr:=shp.Contour;// gAddon2.CreateObject(inocContour,0) as IIngeoContour;
//    surf:=gAddon2.MainWindow.MapWindow.Surface;
//    wd:=Surf.SizeDeviceToWorld(3);
    cntp:=cntr.Insert(-1);

    for i := 0 to pCount - 1 do
    begin
      wx:=npx+r*cos(angle+2*pi*i/pcount);
      wy:=npy+r*sin(angle+2*pi*i/pcount);
      cntp.InsertVertex(-1,wx,wy,0);
    end;
    cntp.Closed:=True;
    objs.UpdateChanges;
//    Surf.Pen.Style:=inpsSolid;
//    Surf.Pen.Color:=clGray;
 //   Surf.Pen.Mode:=inpmXor;
 //   surf.Brush.Style:=inbsClear;
  //  surf.PaintContour(cntr,true);
end;

destructor TUPointSelector.Destroy;
begin

  inherited;
end;

procedure TUPointSelector.DrawNearPoint;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    wx,wy,wd:double;
    surf:IIngeoPaintSurface;
begin
  if not nearpoint then
  begin
    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    wx:=npx;wy:=npy;
    surf:=gAddon2.MainWindow.MapWindow.Surface;
    wd:=Surf.SizeDeviceToWorld(3);
    cntp:=cntr.Insert(-1);
    cntp.InsertVertex(-1,wx-wd,wy-wd,0);
    cntp.InsertVertex(-1,wx+wd,wy-wd,0);
    cntp.InsertVertex(-1,wx+wd,wy+wd,0);
    cntp.InsertVertex(-1,wx-wd,wy+wd,0);
    Surf.Pen.Style:=inpsSolid;
    Surf.Pen.Color:=clBlue;
    Surf.Pen.Mode:=inpmXor;
    surf.PaintContour(cntr,true);
    exit;
  end;

  cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
  wx:=npx;wy:=npy;
  surf:=gAddon2.MainWindow.MapWindow.Surface;
  wd:=Surf.SizeDeviceToWorld(5);
  cntp:=cntr.Insert(-1);
  cntp.InsertVertex(-1,wx-wd,wy-wd,0);
  cntp.InsertVertex(-1,wx+wd,wy-wd,0);
  cntp.InsertVertex(-1,wx+wd,wy+wd,0);
  cntp.InsertVertex(-1,wx-wd,wy+wd,0);
  Surf.Pen.Style:=inpsSolid;
  Surf.Pen.Color:=clRed;
  Surf.Pen.Mode:=inpmXor;
  surf.PaintContour(cntr,true);
//  gAddon2.MainWindow.MapWindow.Surface.
end;

procedure TUPointSelector.DrawPoints;
begin

end;

procedure TUPointSelector.DrawPolygon;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    an,wx,wy,wd,r:double;
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
    an:=angle;
    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    surf:=gAddon2.MainWindow.MapWindow.Surface;
    wd:=Surf.SizeDeviceToWorld(3);
    cntp:=cntr.Insert(-1);

    for i := 0 to pCount - 1 do
    begin
      wx:=npx+r*cos(an+2*pi*i/pcount);
      wy:=npy+r*sin(an+2*pi*i/pcount);
      cntp.InsertVertex(-1,wx,wy,0);
    end;
    cntp.Closed:=True;
    Surf.Pen.Style:=inpsSolid;
    Surf.Pen.Color:=clGray;
    Surf.Pen.Mode:=inpmXor;
    surf.Brush.Style:=inbsClear;
    surf.PaintContour(cntr,true);
end;

procedure TUPointSelector.ExecuteMacro(aCmd: Integer;
  const aParams: TM2String);
begin
  inherited;

end;

procedure TUPointSelector.FindNearPoint(mx,my:integer);
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
  SetLength(lars,1000);
//  for I := 0 to List.Count - 1 do
//  mq:=gAddon2.ActiveDb.MapObjects.QueryByRect()
  larcount:=0;
  for i := 0 to gAddon2.ActiveProjectView.MapViews.Count - 1 do
  begin
    mv:=gAddon2.ActiveProjectView.MapViews.Item[i];
    if not mv.Visible then continue;
    if mv.Map.MapType<>inmtVector then continue;
     vmap:=mv.Map as IIngeoVectorMap;
    for li := 0 to vmap.Layers.Count - 1 do
    begin
      lars[larcount]:=vmap.Layers.Item[li].ID;
      inc(larcount);
      if larcount>Length(lars) then SetLength(lars,Length(lars)+1000);
    end;
  end;
  SetLength(lars,larcount);
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(mx,my,wx,wy);
  wd:=gAddon2.MainWindow.MapWindow.Surface.SizeDeviceToWorld(10);
  mq:=gAddon2.ActiveDb.MapObjects.QueryByRect(lars,wx-wd,wy-wd,wx+wd,wy+wd,false);
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

function TUPointSelector.FindPoint(p: TM2Point): TM2Point;
begin

end;

function TUPointSelector.GetContextMacroList(
  aMouse: TPoint): IM2ContextMacroAttrsList;
begin

end;

function TUPointSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or eopDragging or eopNotification;
end;

function TUPointSelector.GetObjectNearPoint(oid: string;x,y:double; var fx, fy: double;
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

procedure TUPointSelector.HideDragging;
begin
  inherited;
  if pointselecting then
    DrawNearPoint;
  if pcount>2 then
  begin
    DrawPolygon;
  end;
end;

function TUPointSelector.LineLength(p1, p2: TM2Point): real;
begin

end;

procedure TUPointSelector.MouseDown(aButton: TM2MouseButton;
  aShift: TM2ShiftState; aMouse: TPoint);
var cf:TfLinZasechka;
begin
  inherited;
  if (aButton=inmbLeft) and (pointselecting)   then
  begin
    eX.Text:=Format('%.4f',[npx]);
    eY.Text:=Format('%.4f',[npy]);

    callform.Show;
//    cf:=TfLinZasechka(callform);
//    cf.sgData.Cells[1,cf.sgData.Row]:=Format('%.4f',[npx]);
//    cf.sgData.Cells[2,cf.sgData.Row]:=Format('%.4f',[npy]);
//    cf.Show;
    pointselecting:=False;
  end;
end;

procedure TUPointSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
  inherited;
  HideDragging;
  if pointselecting then
    FindNearPoint(amouse.X,amouse.Y);
  ShowDragging(aMouse);
end;

procedure TUPointSelector.Notification(AWhat: TM2EditorNotification);
begin
  inherited;

end;

procedure TUPointSelector.ShowDragging(aMouse: TPoint);
begin
  inherited;
  if pointselecting then
    DrawNearPoint;
  if pcount>2 then
  begin
    DrawPolygon;
  end; 
end;

end.
