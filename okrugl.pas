unit okrugl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Ingeo_TLB;
const
   rkey='\Software\AzSoft\TopoUtils\Okrugl';
type
  TfOkrugl = class(TForm)
    Label1: TLabel;
    eSetkaStep: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure SAveParams;
    procedure MakeOkrugl;
  public
    { Public declarations }
  end;

var
  fOkrugl: TfOkrugl;

implementation
uses registry, addn;
{$R *.dfm}

procedure TfOkrugl.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfOkrugl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SAveParams;
  Action:=caFree;
end;

procedure TfOkrugl.SAveParams;
var r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(rkey,True);
  r.WriteString('Step',eSetkaStep.Text);
  r.Free;
end;

procedure TfOkrugl.FormCreate(Sender: TObject);
var r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(rkey,True);
  if r.ValueExists('Step') then
    eSetkaStep.Text:= r.ReadString('Step');
  r.Free;
end;

procedure TfOkrugl.Button1Click(Sender: TObject);
begin
  MakeOkrugl;
end;

procedure TfOkrugl.MakeOkrugl;
var i,si,ci,vi,ocount,scount,vcount:integer;
    objid:string;
    mobjs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    x,y,cv,stp:double;
begin
  if not TryStrToFloat(eSetkaStep.Text,stp) then
  begin
    ShowMessage('Неправильный ввод шага!');
    exit;
  end;
  ocount:=0;vcount:=0;scount:=0;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    objid:=gAddon2.Selection.IDs[i];
    obj:=mobjs.GetObject(objid);
    for si:=0 to obj.Shapes.Count-1 do
    begin
      shp:=obj.Shapes.Item[si];
      if not shp.DefineGeometry then continue;
      inc(scount);
      for ci:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[ci];

        for vi:=0 to cntp.VertexCount-1 do
        begin
          cntp.GetVertex(vi,x,y,cv);
          x:=Round(x/stp)*stp;
          y:=Round(y/stp)*stp;
          cntp.SetVertex(vi,x,y,cv);
          inc(vcount);
        end; //vi
      end;  //ci
    end;   //si
    inc(ocount);
  end;   //i

  mobjs.UpdateChanges;
  ShowMessage(Format('%d объектов, %d контуров, %d точек округлено',[ocount,scount,vcount]));
end;

end.
