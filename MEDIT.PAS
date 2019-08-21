unit medit;

interface
uses Windows, M2Addon, M2AddonD, addn, math;

type
    TPointSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
    public
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
    end;

Var PointSelector:TPointSelector;

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

constructor TPointSelector.Create;
begin
  inherited Create;
  faddn:=anAddon;
end;

destructor TPointSelector.Destroy;
begin
//  PointSelector:=nil;
  inherited Destroy;
end;

function TPointSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or
			eopContextMenu or eopDragging or eopNotification;
end;

procedure TPointSelector.HideDragging;
begin
end;

procedure TPointSelector.ShowDragging(aMouse: TPoint);
begin
end;

procedure TPointSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
end;

procedure TPointSelector.MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint);
begin
end;

function TPointSelector.GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList;
begin
	Result := inherited GetContextMacroList(aMouse);
end;

procedure TPointSelector.ExecuteMacro(aCmd: Longint; const aParams: TM2String);
begin
end;

procedure TPointSelector.DrawPoints;
begin
end;

function TPointSelector.FindPoint(p:TM2Point):TM2Point;
begin
end;

function TPointSelector.LineLength(p1,p2:TM2Point):real;
begin
  Result:=SQRT(SQR(p1.X-p2.X)+SQR(p1.Y-p2.Y));
end;

procedure TPointSelector.Calculate;
begin
end;

function TPointSelector.CalcAngle(p1,p2:TM2Point): real;
var an:real;
begin
  an:=ArcTan2((p2.y-p1.y),(p2.x-p1.x));
  an:=an*360/(2*pi);
  if an<0 then an:=an+360;
  Result:=an;
end;

function TPointSelector.CalcPoint(p:TM2Point;an,d:real):TM2Point;
var np:TM2Point;
begin
end;


procedure TPointSelector.Notification(AWhat: TM2EditorNotification);
begin
  if aWhat=enfViewChanged then
  fNavigator.MapNavigated;
  inherited;
end;

end.
