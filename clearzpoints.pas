unit clearzpoints;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Ingeo_TLB, InScripting_TLB, ComCtrls, ExtCtrls, StrUtils;

type
  TfClearZPoints = class(TForm)
    Label1: TLabel;
    eminDist: TEdit;
    Label2: TLabel;
    eMaxDZ: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    cbZField: TComboBox;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    RadioGroup1: TRadioGroup;
    Label5: TLabel;
    cbExlStyle: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    stop:boolean;
    exstl:string;
    function GetObjectXY(obj: IIngeoMapObject; var x, y: double): boolean;
    procedure LoadFields;
    procedure ClearPoints(oid:string;mind,maxz:double;field:string);
    procedure LoadParams;
    procedure SaveParams;
    function ObjectHaveStyle(obj:IIngeoMapObject):boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fClearZPoints: TfClearZPoints;

implementation
uses addn;
{$R *.dfm}

procedure TfClearZPoints.Button1Click(Sender: TObject);
var mindist,maxz:double;
    alar,field:string;
    mq:IIngeoMapObjectsQuery;
    spi,ii:integer;
    larid,oid:widestring;
    objectlist:TStringList;
  i,cc: Integer;
begin
  if Button1.Caption='Стоп' then
  begin
    stop:=True;
  end;

  Button1.Caption:='Стоп';
  try
  stop:=False;
  if not TryStrToFloat(eminDist.Text,mindist) then
  begin
    ShowMessage('Неверно введено расстояние!');
    exit;
  end;
  if not TryStrToFloat(eMaxDZ.Text,maxz) then
  begin
    ShowMessage('Неверно введена разница!');
    exit;
  end;
  exstl:=Copy(cbExlStyle.Text,2,Pos(']',cbExlStyle.Text)-2);
  field:='{'+cbZField.Text+'}';
  objectlist:=TStringList.Create;
  case RadioGroup1.ItemIndex of
  0:begin
      if gAddon2.Selection.Count=0 then
      begin
        ShowMessage('Не выделены объекты!');
        exit;
      end;
      for i := 0 to gAddon2.Selection.Count - 1 do
      begin
        objectlist.Add(gAddon2.Selection.IDs[i]);
      end;
    end;
  1:begin
      alar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.ID;
      mq:=gAddon2.ActiveDb.MapObjects.QueryByLayers(alar);
      while not mq.EOF do
      begin
        mq.Fetch(larid,oid,spi);
        objectlist.Add(oid);
      end;
      if objectlist.Count=0 then
      begin
        ShowMessage('Нет объектов!');
        exit;
      end;
    end;
  -1:begin
        ShowMessage('Не выбран режим работы!');
        exit;
     end;
  end;
{  alar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.ID;
  mq:=gAddon2.ActiveDb.MapObjects.QueryByLayers(alar);
  ii:=0;
  while not mq.EOF do
  begin
    mq.Fetch(larid,oid,spi);
    ClearPoints(oid,mindist,maxz,field);
    label4.Caption:=IntToStr(ii);
    inc(ii);
    Application.ProcessMessages;
    if stop then
       break;
  end;}
  cc:=objectlist.Count;
  while objectlist.Count>0 do
  begin
    i:=Random(objectlist.Count);
    ClearPoints(objectlist[i],mindist,maxz,field);
    objectlist.Delete(i);
    label4.Caption:=IntToStr(objectlist.Count);
    ProgressBar1.Position:=objectlist.Count*100 div cc;
    Application.ProcessMessages;
  end;
  {
  for i := 0 to objectList.Count - 1 do
  begin
    ClearPoints(objectlist[i],mindist,maxz,field);
    label4.Caption:=IntToStr(ii);
    ProgressBar1.Position:=i*100 div objectlist.Count;
    Application.ProcessMessages;
  end;}

  finally
    button1.Caption:='Очистить';
  end;
end;

procedure TfClearZPoints.ClearPoints(oid: string; mind, maxz: double;
  field: string);
var mq:IIngeoMapObjectsQuery;
    z1,z2,d,x,y,x1,y1,cv:double;
    obj,nobj:IIngeoMapObject;
    i: Integer;
    flag:boolean;
    larid,noid:widestring;
    spi:integer;
    ts:string;
    mobjs:IIngeoMapObjects;
begin
  if not gAddon2.ActiveDb.MapObjects.IsObjectExists(oid) then exit;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  obj:=mobjs.GetObject(oid);
  if not GetObjectXY(obj,x,y)  then
    exit;
  mq:=mobjs.QueryByRect(obj.LayerID,x-mind,y-mind,x+mind,y+mind,True);
  ts:=obj.FormatText(field);

  if not (TryStrToFloat(ts,z1) and TryStrToFloat(AnsiReplaceStr(ts,'.',','),z1)) then
    exit;
  while not mq.EOF do
  begin
    mq.Fetch(larid,noid,spi);
    if noid=oid then
      continue;
    nobj:=mobjs.GetObject(noid);
    if not GetObjectXY(nobj,x1,y1) then continue;
    if ObjectHaveStyle(nobj) then  continue;

    d:=SQRT(SQR(x1-x)+SQR(y1-y));
    if d<mind then
    begin
      ts:=nobj.FormatText(field);
      if not TryStrToFloat(ts,z2) then
        continue;
      if abs(z2-z1)<maxz  then
      begin
        mobjs.DeleteObject(noid);
      end;
    end;
  end;
  mobjs.UpdateChanges;
end;

function TfClearZPoints.GetObjectXY(obj:IIngeoMapObject;var x,y:double):boolean;
var flag:boolean;
    i:integer;
    cv:double;
begin
  Result:=False;
  for i := 0 to obj.Shapes.Count - 1 do
  begin
    if obj.Shapes.Item[i].DefineGeometry then
    begin
      obj.Shapes.Item[i].Contour.Item[0].GetVertex(0,x,y,cv);
      Result:=True;
      break;
    end;
  end;
end;

procedure TfClearZPoints.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SAveParams;
end;

procedure TfClearZPoints.FormShow(Sender: TObject);
begin
  LoadFields;
  LoadParams;
end;

procedure TfClearZPoints.LoadFields;
var st:IIngeoSemTables;
    i,t:integer;
    sst:IIngeoSemTable;
    fn:string;
    lar:IIngeoLayer;
begin
  cbZField.Items.Clear;
  st:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.SemTables;
  for i:=0 to st.Count-1 do
  begin
    sst:=st.Item[i];
    for t:=0 to sst.FieldInfos.Count-1 do
    begin
      fn:=sst.Name+'.'+sst.FieldInfos.Item[t].FieldName;
      cbZField.Items.Add(fn);
    end;
  end;
  cbExlStyle.Items.Clear;
  lar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
  for i := 0 to lar.Styles.Count - 1 do
  begin
    cbExlStyle.Items.Add(GetStyleNameID( lar.Styles.Item[i].ID));
  end;

//  cbName.Items:=cbZ.Items;
end;

procedure TfClearZPoints.LoadParams;
var exid:string;
begin
  eminDist.Text:= gAddon2.UserProfile.Get(inupGlobal,'','ZCLEAR_MIND','');
  eMaxDZ.Text:= gAddon2.UserProfile.Get(inupGlobal,'','ZCLEAR_MAXZ','');
  cbZField.Text:= gAddon2.UserProfile.Get(inupGlobal,'','ZCLEAR_FIELD','');
  exid:=gAddon2.UserProfile.Get(inupGlobal,'','ZEX_STYLE','');
  cbExlStyle.Text:=GetStyleNameID(exid);
end;

function TfClearZPoints.ObjectHaveStyle(obj: IIngeoMapObject): boolean;
var
  i: Integer;
begin
  if exstl='' then
  begin
    Result:=False;
    exit;
  end;

  for i := 0 to obj.Shapes.Count - 1 do
  begin
    if obj.Shapes.Item[i].StyleID=exstl then
    begin
      Result:=True;
      exit;
    end;
  end;
  Result:=False;
end;

procedure TfClearZPoints.SaveParams;
var exid:string;
begin
  exid:=Copy(cbExlStyle.Text,2,Pos(']',cbExlStyle.Text)-2);
  gAddon2.UserProfile.Put(inupGlobal,'','ZCLEAR_MIND',eminDist.Text);
  gAddon2.UserProfile.Put(inupGlobal,'','ZCLEAR_MAXZ',eMaxDZ.Text);
  gAddon2.UserProfile.Put(inupGlobal,'','ZCLEAR_FIELD',cbZField.Text);
  gAddon2.UserProfile.Put(inupGlobal,'','ZEX_STYLE',exid);
end;

end.
