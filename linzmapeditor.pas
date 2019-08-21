unit linzmapeditor;

interface
uses Windows, M2Addon, M2AddonD, addn, math, Forms, sysutils, graphics;

type
    TLZPointSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
    public
      showsolves:boolean;
      pointselecting:boolean;
      solvecount:integer;
      solvex,solvey:array [0..25] of double;
      npx,npy:double;
      nearpoint:boolean;
      callform:TForm;
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
    end;

implementation
uses Ingeo_TLB, linzasechka, InScripting_TLB;
{ TLZPointSelector }

constructor TLZPointSelector.Create(anAddon: TFad;cform:TForm);
begin
  inherited Create;
  faddn:=anAddon;
  pointselecting:=False;
  showsolves:=False;
  callform:=cform;
end;

destructor TLZPointSelector.Destroy;
begin

  inherited;
end;

procedure TLZPointSelector.DrawNearPoint;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    wx,wy,wd:double;
    surf:IIngeoPaintSurface;
begin
  if not nearpoint then exit;

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

procedure TLZPointSelector.DrawPoints;
begin

end;

procedure TLZPointSelector.ExecuteMacro(aCmd: Integer;
  const aParams: TM2String);
begin
  inherited;

end;

procedure TLZPointSelector.FindNearPoint(mx,my:integer);
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
end;

function TLZPointSelector.FindPoint(p: TM2Point): TM2Point;
begin

end;

function TLZPointSelector.GetContextMacroList(
  aMouse: TPoint): IM2ContextMacroAttrsList;
begin

end;

function TLZPointSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or eopDragging or eopNotification;
end;

function TLZPointSelector.GetObjectNearPoint(oid: string;x,y:double; var fx, fy: double;
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

procedure TLZPointSelector.HideDragging;
begin
  inherited;
  if pointselecting then
    DrawNearPoint;
end;

function TLZPointSelector.LineLength(p1, p2: TM2Point): real;
begin

end;

procedure TLZPointSelector.MouseDown(aButton: TM2MouseButton;
  aShift: TM2ShiftState; aMouse: TPoint);
var cf:TfLinZasechka;
begin
  inherited;
  if (aButton=inmbLeft) and (pointselecting)   then
  begin
    cf:=TfLinZasechka(callform);
    cf.sgData.Cells[1,cf.sgData.Row]:=Format('%.4f',[npx]);
    cf.sgData.Cells[2,cf.sgData.Row]:=Format('%.4f',[npy]);
    cf.Show;
    pointselecting:=False;
  end;
end;

procedure TLZPointSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
  inherited;
  HideDragging;
  FindNearPoint(amouse.X,amouse.Y);
  ShowDragging(aMouse);
end;

procedure TLZPointSelector.Notification(AWhat: TM2EditorNotification);
begin
  inherited;

end;

procedure TLZPointSelector.ShowDragging(aMouse: TPoint);
begin
  inherited;
  if pointselecting then
    DrawNearPoint;
end;

end.
