unit okruglform2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Ingeo_TLB,InScripting_TLB, math;

type
  TfOkruglForm2 = class(TForm)
    Button2: TButton;
    Button1: TButton;
    eSetkaStep: TEdit;
    Label1: TLabel;
    rgType: TRadioGroup;
    Button3: TButton;
    Label2: TLabel;
    cbNotAll: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    layer:string;
    prec:integer;
    intersectionflag:boolean;
    procedure SelectLayer;
    procedure StartOkrugl;
    procedure OkruglOneShape(cntr,checkcntr:IIngeoContour);
    function GetCheckCntr(x1,y1,x2,y2:double):IIngeoContour;
    function NeedRound(z:double):boolean;
    function RoundUp(z:double):double;
    function RoundDown(z:double):double;
    function CheckPoint(cntr,checkcntr:IIngeoContour):boolean;
    procedure LoadParams;
    procedure SaveParams;
    function GetLayerName(layer:string):string;
  public
   app:IIngeoApplication;
    { Public declarations }
  end;

var
  fOkruglForm2: TfOkruglForm2;

implementation

uses SELLAYER;

{$R *.dfm}

procedure TfOkruglForm2.Button1Click(Sender: TObject);
begin
  StartOkrugl;
end;

procedure TfOkruglForm2.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfOkruglForm2.Button3Click(Sender: TObject);
begin
  SelectLayer;
end;

function TfOkruglForm2.CheckPoint(cntr, checkcntr: IIngeoContour): boolean;
var
  z: Cardinal;
begin
  z:=cntr.TestRelation(checkcntr);
  //  iflag true if do not intersect
  //
  //  iflag          true    true     false    false
  //  intersected    false   true     false    true
  //  result         true    false    false    true
  Result:= ((z and incrIntersected)>0) <> intersectionflag;
end;

procedure TfOkruglForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
end;

procedure TfOkruglForm2.FormShow(Sender: TObject);
begin
  LoadParams;
end;

function TfOkruglForm2.GetCheckCntr(x1,y1,x2,y2:double): IIngeoContour;
var
  mq: IIngeoMapObjectsQuery;
  mobj: IIngeoMapObject;
  i: Integer;
begin
  Result:=app.CreateObject(inocContour,0) as IIngeoContour;
  mq:=app.ActiveDb.MapObjects.QueryByRect(layer,x1,y1,x2,y2,false);
  while not mq.Eof do
  begin
    mobj:=app.ActiveDb.MapObjects.GetObject(mq.ObjectID);
    for i := 0 to mobj.Shapes.Count - 1 do
    begin
      if mobj.Shapes[i].DefineGeometry then
        REsult.Combine(inccOr,mobj.Shapes[i].Contour);
    end;

    mq.MoveNext;
  end;
end;

function TfOkruglForm2.GetLayerName(layer: string): string;
begin
  Result:='';
  if layer='' then
    exit;
  if app.ActiveDb.LayerExists(layer) then
  begin
    Result:=app.ActiveDb.LayerFromID(layer).Map.Name+'/'+
      app.ActiveDb.LayerFromID(layer).Name;
  end;
end;

procedure TfOkruglForm2.LoadParams;
var
  z: string;
  index: Integer;
begin
  try
  layer:=app.UserProfile.Get(inupUser,'','OKRUGL2_LAYER','');
  z:=app.UserProfile.Get(inupUser,'','OKRUGL2_TYPE','0');
  if TryStrToInt(z,index) then rgType.ItemIndex:=index;
  cbNotAll.Checked:=
    StrToBool(app.UserProfile.Get(inupUser,'','OKRUGL2_NOTALL',BoolToStr(false)));
  label2.Caption:=GetLayerName(layer);
  except

  end;
end;

function TfOkruglForm2.NeedRound(z: double): boolean;
var zz:double;
begin
  zz:=Round(z*prec)/prec;
  Result:= Abs(zz-z)>0.0000000001;

end;

procedure TfOkruglForm2.OkruglOneShape(cntr, checkcntr: IIngeoContour);
var
  i: Integer;
  vi: Integer;
  cntp: IIngeoContourPart;
  x,y,cv,x1,y1,x2,y2:double;
begin
  
  for i := 0 to cntr.Count - 1 do
  begin
    cntp:=cntr[i];
    for vi := 0 to cntp.VertexCount - 1 do
    begin
      cntp.GetVertex(vi,x,y,cv);
      if NeedRound(x) or NeedRound(y) or (not cbNotAll.Checked)  then
      begin
        x1:=RoundDown(x);
        x2:=RoundUp(x);
        y1:=RoundDown(y);
        y2:=RoundUp(y);
        cntp.SetVertex(vi,x1,y1,cv);
        if CheckPoint(cntr,checkcntr) then
           continue;
        cntp.SetVertex(vi,x1,y2,cv);
        if CheckPoint(cntr,checkcntr) then
           continue;
        cntp.SetVertex(vi,x2,y2,cv);
        if CheckPoint(cntr,checkcntr) then
           continue;
        cntp.SetVertex(vi,x2,y1,cv);
        if CheckPoint(cntr,checkcntr) then
           continue;

      end;

    end;

  end;

end;

function TfOkruglForm2.RoundDown(z: double): double;
begin
  Result:=Floor(z*prec)/prec;
end;

function TfOkruglForm2.RoundUp(z: double): double;
begin
  Result:=Ceil(z*prec)/prec;
end;

procedure TfOkruglForm2.SaveParams;
var
  z: string;
  index: Integer;
begin
  try
  app.UserProfile.Put(inupUser,'','OKRUGL2_LAYER',layer);
  app.UserProfile.Put(inupUser,'','OKRUGL2_TYPE', InttoStr(rgType.ItemIndex));
  app.UserProfile.Put(inupUser,'','OKRUGL2_NOTALL',BoolToStr(cbNotAll.Checked));
  except

  end;
end;

procedure TfOkruglForm2.SelectLayer;
var f:tfSelectLayer;
begin
  f:=TfSelectLayer.Create(self);
  if (f.ShowModal=mrOk) then
  begin
    layer:=f.sellayer;
    Label2.Caption:=f.selname;
  end;
end;

procedure TfOkruglForm2.StartOkrugl;
var
  i: Integer;
  sobjs:array of IIngeoMapObject;
  mobjs:IIngeoMapObjects;
  x1,y1,x2,y2:double;
  checkcntr:IIngeoContour;
  si: Integer;
  step:Extended;
begin
  if app.Selection.Count=0 then
  begin
    ShowMessage('Не выбраны объекты!');
    exit;
  end;
  if not TryStrToFloat( eSetkaStep.Text,step) then
  begin
    ShowMessage('Не верное число для округления!');
    exit;

  end;
 // if rgType.ItemIndex=0 then
 //true if do not intersect
  intersectionflag:=rgType.ItemIndex=0;
  prec:=Round(1/step);
  mobjs:=app.ActiveDb.MapObjects;
  SetLength(sobjs,app.Selection.Count);
  for i := 0 to app.Selection.Count - 1 do
  begin
    sobjs[i]:=mobjs.GetObject(app.Selection.IDs[i]);
  end;
  x1:=sobjs[0].X1;
  y1:=sobjs[0].Y1;
  x2:=sobjs[0].X2;
  y2:=sobjs[0].Y2;
  for i := 1 to High(sobjs)  do
  begin
    x1:= Min(x1,sobjs[i].X1);
    y1:=Min(y1,sobjs[i].Y1);
    x2:=Max(x2, sobjs[i].X2);
    y2:=Max(y2,sobjs[i].Y2);
  end;
  checkcntr:=GetCheckCntr(x1,y1,x2,y2);
  for i := 0 to High(sobjs)  do
  begin
    for si := 0 to sobjs[i].Shapes.Count - 1 do
    begin
      if sobjs[i].Shapes[si].DefineGeometry then
      begin
        OkruglOneShape(sobjs[i].Shapes[si].Contour,checkcntr);
      end;
    end;
  end;
  mobjs.UpdateChanges;
  ShowMessage('Завершено!');
end;

end.
