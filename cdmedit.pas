unit cdmedit;

interface
uses Windows, M2Addon, M2AddonD, addn, math,Ingeo_TLB, InScripting_TLB;

type
    TCDPointSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
    public
      line:array [0..100000] of tm2point;
      linecount:integer;
      p1,p2:tm2point;
      objstyle:string;
      active:boolean;
 //     procedure Calculate;
      constructor Create(anAddon:TFad);
      destructor Destroy; override;
      function GetEditorOptions: TM2EditorOptions; override;

      procedure HideDragging; override;
      procedure ShowDragging(aMouse: TPoint); override;

      procedure MouseMove(aShift: TM2ShiftState; aMouse: TPoint); override;
      procedure MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint); override;

      function GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList; override;
      procedure ExecuteMacro(aCmd: Longint; const aParams: TM2String); override;
      procedure DrawPoints;
      function FindPoint(p:TM2Point):TM2Point;
      function LineLength(p1,p2:TM2Point):real;
      procedure Calculate;
      function CalcAngle(p1,p2:TM2Point): real;
      function CalcPoint(p:TM2Point;an,d:real):TM2Point;
  		procedure Notification(AWhat: TM2EditorNotification); override;
      procedure LoadOS(obj:string);
      procedure CreateObject;
    end;

//Var PointSelector:TPointSelector;

implementation

uses Controls, SysUtils, Graphics, Linear, navigator;
const
   cmEnterP1=1;
   cmEnterP2=2;
   cmMakeP3=3;
   psize=2;
	kPen: TM2Pen = (
		Style: kpsSolid;
		WidthInMM: 0;
		ForZoomScale: 1/10000;
		Color: clGreen;
	);

	kPen2: TM2Pen = (
		Style: kpsSolid;
		WidthInMM: 0;
		ForZoomScale: 1/10000;
		Color: clRed;
	);

   kContextMacros: array [0..3] of TM2ContextMacroAttrs = (
		( Command: 0;
			Name: '';
			Hint: '';
			Path: '-';
			ShortCut: 0;
			State: 0;	),
		( Command: cmEnterP1;
			Name: 'EnterP1';
			Hint: '';
			Path: '¬вести первую точку';
			ShortCut: 0;
			State: 0; ),
		( Command: cmEnterP2;
			Name: 'EnterP2';
			Hint: '';
			Path: '¬вести вторую точку';
			ShortCut: 0;
			State: 0; ),
		( Command: cmMakeP3;
			Name: 'MakeP3';
			Hint: '';
			Path: '—оздать точку';
			ShortCut: 0;
			State: 0; )
	);

constructor TCDPointSelector.Create;
begin
  inherited Create;
  faddn:=anAddon;
  linecount:=0;
  active:=False;
end;

procedure TCDPointSelector.CreateObject;
var mobjs:IIngeoMapObjects;
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    lar:string;
    cntp:IIngeoContourPart;
begin
  lar:=gAddon2.ActiveDb.StyleFromID(objstyle).Layer.ID;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  mobj:=mobjs.AddObject(lar);
  shp:=mobj.Shapes.Insert(-1,objstyle);
  cntp:=shp.Contour.Insert(-1);
  cntp.InsertVertex(-1,p1.X,p1.Y,0);
  cntp.InsertVertex(-1,p2.X,p2.Y,0);
  mobjs.UpdateChanges;
end;

destructor TCDPointSelector.Destroy;
begin
//  PointSelector:=nil;
  inherited Destroy;
end;

function TCDPointSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or
			eopContextMenu or eopDragging or eopNotification;
end;

procedure TCDPointSelector.HideDragging;
begin
  DrawPoints;
end;

procedure TCDPointSelector.ShowDragging(aMouse: TPoint);
begin
  DrawPoints;
end;

procedure TCDPointSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
  if not active then
      exit;
  HideDragging;
  p1:=gAddon.MapView.PointFromDevice(aMouse);
  Calculate;
  ShowDragging(aMouse);
//  gAddon.MapView.
end;

procedure TCDPointSelector.MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint);
begin
  if not active then
      exit;
  if aButton=kmbLeft then
     CreateObject;
//  inherited MouseDown(aButton,aShift,AmOUSE);
end;

function TCDPointSelector.GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList;
begin
	Result := inherited GetContextMacroList(aMouse);
end;

procedure TCDPointSelector.ExecuteMacro(aCmd: Longint; const aParams: TM2String);
begin
end;

procedure TCDPointSelector.DrawPoints;
var ap:array [0..10] of tm2point;
    ps:double;
    cntr:IIngeoContour;
    surf:IIngeoPaintSurface;
    cntp:IIngeoContourPart;
begin
  cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
  surf:=gAddon2.MainWindow.MapWindow.Surface;
  ps:=Surf.SizeDeviceToWorld(5);
  cntp:=cntr.Insert(-1);
  cntp.InsertVertex(-1,p1.x-ps,p1.y-ps,0);
  cntp.InsertVertex(-1,p1.x+ps,p1.y-ps,0);
  cntp.InsertVertex(-1,p1.x+ps,p1.y+ps,0);
  cntp.InsertVertex(-1,p1.x-ps,p1.y+ps,0);
  Surf.Pen.Style:=inpsSolid;
  Surf.Pen.Color:=clRed;
  Surf.Pen.Mode:=inpmXor;
  surf.PaintContour(cntr,true);
  cntp.Clear;
  cntp.InsertVertex(-1,p1.x,p1.y,0);
  cntp.InsertVertex(-1,p2.x,p2.y,0);
  surf.PaintContour(cntr,true);
end;

function TCDPointSelector.FindPoint(p:TM2Point):TM2Point;
begin
end;

function TCDPointSelector.LineLength(p1,p2:TM2Point):real;
begin
  Result:=SQRT(SQR(p1.X-p2.X)+SQR(p1.Y-p2.Y));
end;

procedure TCDPointSelector.LoadOS(obj: string);
var mobj:IIngeoMapObject;
  i: Integer;
  shp:IIngeoShape;
  cntp:IIngeoContourPart;
  x,y,c:Double;
begin
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(obj);
  shp:=nil;
  for i := 0 to mobj.Shapes.Count - 1 do
  begin
    if mobj.Shapes.Item[i].DefineGeometry then
    begin
       shp:=mobj.Shapes.Item[i];
       break;
    end;
  end;
  cntp:=shp.Contour.Item[0];
//  for I := 0 to shp.Contour.Item.Count - 1 do
  for i := 0 to cntp.VertexCount - 1 do
  begin
    cntp.GetVertex(i,x,y,c);
    line[i].X:=x;
    line[i].Y:=y;
  end;
  linecount:=cntp.VertexCount;
end;

procedure TCDPointSelector.Calculate;
var
  I: Integer;
  ap1,ap2,lp1,lp2,ip,ip2:tm2point;
  a,b,c,aa,bb,cc,ml,l:extended;
begin
  ml:=1e20;
  for I := 0 to linecount-2 do
  begin
    lp1:=line[i];
    lp2:=line[i+1];
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
       l:=sqrt(sqr(p1.X-p2.X)+sqr(p1.Y-p2.Y));
       if l<ml then
       begin
         ip:=p2;
         ml:=l;
       end;
     end;

   end;
   p2:=ip;
end;

function TCDPointSelector.CalcAngle(p1,p2:TM2Point): real;
var an:real;
begin
  an:=ArcTan2((p2.y-p1.y),(p2.x-p1.x));
  an:=an*360/(2*pi);
  if an<0 then an:=an+360;
  Result:=an;
end;

function TCDPointSelector.CalcPoint(p:TM2Point;an,d:real):TM2Point;
var np:TM2Point;
begin
end;


procedure TCDPointSelector.Notification(AWhat: TM2EditorNotification);
begin
  if aWhat=enfViewChanged then
  //fNavigator.MapNavigated;
  inherited;
end;

end.
