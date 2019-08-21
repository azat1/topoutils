unit errorsearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,dllform, Ingeo_TLB;

type
  TfErrorSearch = class(TM2AddonForm)
    Button1: TButton;
    Button2: TButton;
    cbMinP: TCheckBox;
    cbMaxP: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure Operate;
    function CheckObject(objid:string):boolean;
    { Public declarations }
  end;

var
  fErrorSearch: TfErrorSearch;

implementation
uses addn;
{$R *.dfm}

procedure TfErrorSearch.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfErrorSearch.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  Action:=caFree;
end;

procedure TfErrorSearch.Button2Click(Sender: TObject);
begin
  Operate;
end;

procedure TfErrorSearch.Operate;
var i:integer;
    lar,objid:string;
    v,mq:variant;
    z:longint;
    zz:TStringList;
begin
  zz:=TStringList.Create;
  lar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.ID;
  v:=gAddon2.ActiveDb.MapObjects;
  mq:=v.QueryByLayers(lar);
  while not mq.EOF do
  begin
    mq.Fetch(lar,objid,z);
    if CheckObject(objid) then
    begin
      zz.Add(objid);
    end;
  end;
  for i:=0 to zz.Count-1 do
    gAddon2.Selection.Select(zz[i],-1);
  ShowMessage(format('%d объектов выделено',[zz.Count]));
end;

procedure TfErrorSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

function TfErrorSearch.CheckObject(objid: string): boolean;
var mobj:IIngeoMapObject;
    cp,i,minp,maxp:integer;
    shp:IIngeoShape;
begin
  Result:=False;
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(objid);
  for i:=0 to mobj.Shapes.Count-1 do
  begin
    shp:=mobj.Shapes.Item[i];
    minp:=shp.Style.MinPoints;
    maxp:=shp.Style.MaxPoints;
    if shp.Contour.Count=0 then continue;
    cp:=shp.Contour.Item[0].VertexCount;
    if cbMinP.Checked and (cp<minp) then
    begin
      Result:=True;
      exit;
    end;
    if cbMaxP.Checked and (cp>maxp) then
    begin
      Result:=True;
      exit;
    end;
  end; //for
end;  //proc

end.
