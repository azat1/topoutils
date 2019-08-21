unit divider;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,DllForm, M2Addon, M2AddonD,Ingeo_TLB, StdCtrls, ExtCtrls;

type
  TfDivider = class(TM2AddonForm)
    leMObjId: TLabeledEdit;
    Button1: TButton;
    lbDivObj: TListBox;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure DivideObj;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDivider: TfDivider;

implementation
uses addn;
{$R *.dfm}

procedure TfDivider.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfDivider.Button1Click(Sender: TObject);
begin
  if GAddon2.Selection.Count=0 then exit;
  leMObjId.Text:=gAddon2.Selection.IDs[0];
end;

procedure TfDivider.Button2Click(Sender: TObject);
var i:integer;
begin
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    lbDivObj.Items.Add(gAddon2.Selection.IDs[i]);
  end;
end;

procedure TfDivider.Button3Click(Sender: TObject);
begin
  lbDivObj.Items.Clear;
end;

procedure TfDivider.Button4Click(Sender: TObject);
begin
  DivideObj;
end;

procedure TfDivider.DivideObj;
var mobjs:IIngeoMapObjects;
    mobj,secobj,newobj:IIngeoMapObject;

    shp,shp2,newshp:IIngeoShape;
    cnt,cnt2,newcnt:IIngeoContour;
    cntp:IIngeoContourPart;
    i:integer;
begin
  mobjs:=Gaddon2.ActiveDb.MapObjects;
  mobj:=mobjs.GetObject(leMObjId.Text);
  shp:=mobj.Shapes.Item[0];
  cnt:=shp.Contour;
  for i:=0 to lbDivObj.Count-1 do
  begin
    secobj:=mobjs.GetObject(lbDivObj.Items[i]);
    shp2:=secobj.Shapes.Item[0];
    cnt2:=shp2.Contour;
    newobj:=mobjs.AddObject(mobj.LayerID);
    newshp:=newobj.Shapes.Insert(0,shp.StyleID);
    newshp.Contour.AddPartsFrom(cnt);
    newshp.Contour.Combine(inccAnd,cnt2);
    if newshp.Contour.Square>0 then
       mobjs.UpdateChanges else mobjs.DropChanges;
  end;
//  shp.Contour.
end;

end.
