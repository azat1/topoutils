unit objselectform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, DllForm, Ingeo_TLB, InScripting_TLB;
const
   tNone=0;
   tEqual=1;
   tBigger=2;
   tLower=3;
   tBetween=4;
type
  TfObjectSelect = class(TM2AddonForm)
    Label1: TLabel;
    clbStyles: TCheckListBox;
    Label2: TLabel;
    cbPerimeterOp: TComboBox;
    ePerim1: TEdit;
    ePerim2: TEdit;
    Label3: TLabel;
    cbSquareOp: TComboBox;
    eSquare1: TEdit;
    eSquare2: TEdit;
    Label4: TLabel;
    cbFieldOp: TComboBox;
    cbField: TComboBox;
    cbFieldValue: TComboBox;
    Button1: TButton;
    cbField2: TComboBox;
    cbFieldOp2: TComboBox;
    cbFieldValue2: TComboBox;
    Label5: TLabel;
    cbRange: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     stls: TStringList;
     perimeter_type:integer;
     perimeter_min:double;
     perimeter_max:double;
     square_type:integer;
     square_min,square_max:double;
    { Private declarations }
    procedure LoadStyles;
    procedure LoadFields;
    procedure SelectObjectByLength;
    procedure SelectObjects;
    function PreSelectObjects:TStringList;
    function ObjectHasStyles(objid:string;styles:array of string):boolean;
    function CheckPerimeter(mobj:IIngeoMapObject):boolean;
    function CheckSquare(mobj:IIngeoMapObject):boolean;
    function CheckSemData(mobj:IIngeoMapObject):boolean;
    procedure PreloadChecks;
  public
    app:IIngeoApplication;
    { Public declarations }
  end;

var
  fObjectSelect: TfObjectSelect;

procedure StartObjSelect(app:IIngeoApplication);

implementation
uses objselector, Math;
{$R *.dfm}

procedure StartObjSelect(app:IIngeoApplication);
var f:TfObjectSelect;
begin
  f:=TfObjectSelect.Create(nil);
  f.app:=app;
  f.Show;

end;

procedure TfObjectSelect.Button1Click(Sender: TObject);
var z:double;
begin
  SelectObjects;

  //if TryStrToFloat(ePerim1.Text, z) then
   // SelectObjectByLength();
//  if TryStrToFloat(ePerim1.Text, z) then
//    SelectObjectByLength();
end;

function TfObjectSelect.CheckPerimeter(mobj: IIngeoMapObject): boolean;
begin
  Result:=false;
  case perimeter_type of
  tNone:Result:=true;
  tEqual:Result:=SameValue( mobj.Perimeter,perimeter_min,0.01);
  tBigger:Result:=mobj.Perimeter>perimeter_min;
  tLower:Result:=mobj.Perimeter<perimeter_min;
  tBetween:Result:=(mobj.Perimeter>perimeter_min) and
                                                 (mobj.Perimeter<perimeter_max);
  end;
end;

function TfObjectSelect.CheckSemData(mobj: IIngeoMapObject): boolean;
begin
  Result:=true;  
end;

function TfObjectSelect.CheckSquare(mobj: IIngeoMapObject): boolean;
begin
  Result:=false;
  case square_type of
  tNone:Result:=true;
  tEqual:Result:=SameValue( mobj.Square,square_min,0.01);
  tBigger:Result:=mobj.Square>square_min;
  tLower:Result:=mobj.Square<square_min;
  tBetween:Result:=(mobj.Square>square_min) and
                                                 (mobj.Square<square_max);
  end;
end;

procedure TfObjectSelect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfObjectSelect.FormShow(Sender: TObject);
begin
  LoadStyles;
  LoadFields;
end;

procedure TfObjectSelect.LoadFields;
begin

end;

procedure TfObjectSelect.LoadStyles;
var lar:IIngeoLayer;
  i: Integer;
begin

   stls:=TStringList.Create;
   clbStyles.Items.Clear;
   try
     lar:=app.ActiveProjectView.ActiveLayerView.Layer;//.SelectedLayerView.Layer;
   except
     exit;
   end;
//   if lar. then

   for i := 0 to lar.Styles.Count - 1 do
   begin
     clbStyles.Items.Add(lar.Styles.Item[i].Name);
     stls.Add(lar.Styles.Item[i].ID);
   end;
end;

function TfObjectSelect.ObjectHasStyles(objid: string;
  styles: array of string): boolean;
var
  mobj: IIngeoMapObject;
  i: Integer;
  j: Integer;
begin
  Result:=false;
  mobj:=app.ActiveDb.MapObjects.GetObject(objid);
  for i := 0 to mobj.Shapes.Count - 1 do
  begin
    for j := 0 to High(styles)  do

    if mobj.Shapes[i].StyleID=styles[j]  then
    begin
      Result:=true; exit;
    end;

  end;

end;

procedure TfObjectSelect.PreloadChecks;
begin
  perimeter_type:=cbPerimeterOp.ItemIndex;
  TryStrToFloat(ePerim1.Text,perimeter_min);
  TryStrToFloat(ePerim2.Text,perimeter_max);
  square_type:=cbSquareOp.ItemIndex;
  TryStrToFloat(eSquare1.Text,square_min);
  TryStrToFloat(eSquare2.Text,square_max);
end;

function TfObjectSelect.PreSelectObjects: TStringList;
var styles,lars:array of string;
    x1,y1,x2,y2:double;
  mq: IIngeoMapObjectsQuery;
  i: Integer;
begin
  Result:=TStringList.Create;

  SetLength(styles,0);
  for i := 0 to clbStyles.Items.Count - 1 do
  begin
    if clbStyles.Checked[i] then
    begin
      SetLength(styles,Length(styles)+1);
      styles[Length(styles)-1]:=stls[i];
    end;
  end;
  SetLength(lars,1);
  lars[0]:=app.ActiveProjectView.ActiveLayerView.Layer.ID;
  case cbRange.ItemIndex of
  0: begin
       mq:=app.ActiveDb.MapObjects.QueryByStyle(styles,inqsOneOrMore);
       while not mq.EOF do
       begin
         Result.Add(mq.ObjectID);
         mq.MoveNext;
       end;
     end;
  1:begin
       app.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,0,x1,y1);
       app.MainWindow.MapWindow.Surface.PointDeviceToWorld(
         app.MainWindow.MapWindow.Surface.DeviceRight,
         app.MainWindow.MapWindow.Surface.DeviceBottom,
         x2,y2);
       mq:=app.ActiveDb.MapObjects.QueryByRect(lars,x1,y1,x2,y2,false);
       while not mq.EOF do
       begin
         if ObjectHasStyles(mq.ObjectID,styles) then
           Result.Add(mq.ObjectID);
         mq.MoveNext;
       end;
    end;
   2: begin
        for i := 0 to app.Selection.Count - 1 do
        begin
          if ObjectHasStyles(mq.ObjectID,styles) then
            Result.Add(app.Selection.IDs[i]);
        end;
      end;
   end;

end;

procedure TfObjectSelect.SelectObjectByLength;
var l1,l2:double;
  selector: TObjectSelector;
begin
  if TryStrToFloat(ePerim1.Text,l1) and TryStrToFloat(ePerim2.Text,l2) then
  begin
    selector:=TObjectSelector.Create(app);
    selector.SelectObjectsByLength(l1,l2);
    selector.Free;
  end;
end;

procedure TfObjectSelect.SelectObjects;
var objlist:TStringList;
  i: Integer;
  mobj:IIngeoMapObject;
begin
  objlist:=PreSelectObjects;
  app.Selection.DeselectAll;
  PreloadChecks;
  for i := 0 to objlist.Count - 1 do
  begin
    mobj:=app.ActiveDb.MapObjects.GetObject(objlist[i]);
    if CheckPerimeter(mobj) and
       CheckSquare(mobj) and
       CheckSemData(mobj)
       then   app.Selection.Select(objlist[i],0);

  end;

end;

end.
