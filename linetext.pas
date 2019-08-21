unit linetext;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, M2Addon, DllForm, Ingeo_TLB;
const key='\Software\Azamatov\LINETEXT';
type
  TfLineText = class(TM2AddonForm)
    Label1: TLabel;
    cbInterval: TComboBox;
    cbUpStyle: TComboBox;
    Label2: TLabel;
    cbDownStyle: TComboBox;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    cbUpIndent: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    cbdownIndent: TComboBox;
    cbEnableUpStyle: TCheckBox;
    cbeNableDownStyle: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    stllist:array of string;
    mobjs:IIngeoMapObjects;
    interval,upsize,downsize:double;
    downstl,upstl:string;
    procedure LoadParams;
    procedure SaveParams;
    procedure LoadStyles;
    procedure MakeTexts;
    procedure MakeObjText(objid:string);
    procedure MakeContourText(obj:IINgeoMapObject;cntr:IIngeoContour);
    procedure CalcTExtPos(lx,ly,x,y,bx,by:double;var x1,y1,x2,y2,x3,y3,x4,y4:double);
    procedure CalcTExtPos2(lx,ly,x,y,cl:double;var x1,y1,x2,y2,x3,y3,x4,y4:double);
    procedure CreateShapes(obj:IIngeoMapObject;x1,y1,x2,y2,x3,y3,x4,y4:double);


    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLineText: TfLineText;
  lastupindex,lastdownindex:integer;
//  0 pi/2     up    left and forward
//           down  right and forward

// 0 -pi/2   up   left and forward
//           down right and forward

//pi/2 pi   up    right and backward
//          down  left backward

//-pi/2 -pi  up    right and back
//           down  left and back
implementation
uses registry, addn, math;
{$R *.dfm}

procedure TfLineText.Button1Click(Sender: TObject);
begin
  MakeTexts;
end;

procedure TfLineText.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfLineText.CalcTExtPos(lx, ly, x, y, bx, by: double; var x1, y1, x2, y2, x3, y3, x4, y4: double);
var a,l,ex,ey,s:double;
begin
  l:=SQRT(SQR(lx-x)+SQR(ly-y));
  ex:=(x-lx)/l;
  ey:=(y-ly)/l;
  a:=ArcTan2(x-lx,y-ly);
  if (a>-(pi/2)) and (a<(pi/2)) then
  begin
    s:=1;
  end
  else
  begin
    s:=-1;
  end;
  x1:=bx+ey*s*upsize;    //1 2   -2   1 right     2 -1   left
  y1:=by-ex*s*upsize;
  x2:=x1+ex*s;
  y2:=y1+ey*s;

  x3:=bx-ey*s*downsize;
  y3:=by+ex*s*downsize;
  x4:=x3+ex*s;
  y4:=y3+ey*s;



end;

procedure TfLineText.CalcTExtPos2(lx, ly, x, y, cl: double; var x1, y1, x2, y2, x3, y3, x4, y4: double);
var bx,by,a,l,ex,ey,s:double;
begin
  l:=SQRT(SQR(lx-x)+SQR(ly-y));
  ex:=(x-lx)/l;
  ey:=(y-ly)/l;
  bx:=lx+ex*cl;
  by:=ly+ey*cl;
  a:=ArcTan2(x-lx,y-ly);
  if (a>(-pi/2)) and (a<(pi/2)) then
  begin
    s:=1;
  end
  else
  begin
    s:=-1;
  end;
  x1:=bx+ey*s*upsize;
  y1:=by-ex*s*upsize;
  x2:=x1+ex*s;
  y2:=y1+ey*s;

  x3:=bx-ey*s*downsize;
  y3:=by+ex*s*downsize;
  x4:=x3+ex*s;
  y4:=y3+ey*s;



end;

procedure TfLineText.CreateShapes(obj: IIngeoMapObject; x1, y1, x2, y2, x3, y3, x4, y4: double);
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    shp:IIngeoShape;
begin
   if cbEnableUpStyle.checked then
   begin
     shp:=obj.Shapes.Insert(-1,upstl);
     cntp:=shp.Contour.Insert(-1);
     cntp.InsertVertex(-1,x1,y1,0);
     cntp.InsertVertex(-1,x2,y2,0);
   end;

   if cbeNableDownStyle.checked then
   begin
     shp:=obj.Shapes.Insert(-1,downstl);
     cntp:=shp.Contour.Insert(-1);
     cntp.InsertVertex(-1,x3,y3,0);
     cntp.InsertVertex(-1,x4,y4,0);
   end;


end;

procedure TfLineText.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
  lastupindex:=cbUpStyle.ItemIndex;
  lastdownindex:=cbDownStyle.ItemIndex;
  action:=caFree;
end;

procedure TfLineText.FormShow(Sender: TObject);
begin
  LoadParams;
  LOadStyles;
end;

procedure TfLineText.LoadParams;
var r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(key,true);
  try
    cbInterval.Text:=r.ReadString(cbInterval.Name);
    cbUpStyle.Text:=r.ReadString(cbUpStyle.Name);
    cbDownStyle.Text:=r.ReadString(cbDownStyle.Name);
    cbUpIndent.Text:=r.ReadString(cbUpIndent.Name);
    cbdownIndent.Text:=r.ReadString(cbdownIndent.Name);
    cbEnableUpStyle.Checked:=r.ReadBool(cbEnableUpStyle.Name);
    cbeNableDownStyle.Checked:=r.ReadBool(cbeNableDownStyle.Name);
  finally

  end;
  r.Free;
end;

procedure TfLineText.LoadStyles;
var alar:IIngeoLayer;
  i: Integer;
  stl:IIngeoStyle;
begin
  alar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
  SetLength(stllist,alar.Styles.Count);
  for i := 0 to alar.Styles.Count - 1 do
  begin
    stl:=alar.Styles.Item[i];
    stllist[i]:=stl.ID;
    cbUpStyle.Items.Add(stl.Name);
  end;
  cbDownStyle.Items:=cbUpStyle.Items;//.Add(stl.Name);
  cbUpStyle.ItemIndex:=lastupindex;
  cbDownStyle.ItemIndex:=lastdownindex;

end;

procedure TfLineText.MakeContourText(obj: IINgeoMapObject; cntr: IIngeoContour);
var
  j,i: Integer;
  cntp:IIngeoContourPart;
  cl,tl,l,lx,ly,lcv,x,y,bx,by:double;
  x1,y1,x2,y2,x3,y3,x4,y4:double;
begin
  for i := 0 to cntr.Count - 1 do
  begin
    cntp:=cntr.Item[i];
    cntp.GetVertex(0,lx,ly,lcv);
    tl:=0;
    for j := 1 to cntp.VertexCount - 1 do
    begin
      cntp.GetVertex(j,x,y,lcv);
      if lcv<>0 then
        continue;
      l:=SQRT(SQR(lx-x)+SQR(ly-y));
      if (l+tl)>interval then
      begin
        if (l/interval)>2 then
        begin
           cl:=interval-tl;
           while cl<l do
           begin
             CalcTExtPos2(lx,ly,x,y,cl,x1,y1,x2,y2,x3,y3,x4,y4);
             CreateShapes(obj, x1,y1,x2,y2,x3,y3,x4,y4);
             cl:=cl+interval;
           end;
        end else
        begin
           bx:=(lx+x)/2;
           by:=(ly+y)/2;
           CalcTExtPos(lx,ly,x,y,bx,by,x1,y1,x2,y2,x3,y3,x4,y4);
           CreateShapes(obj, x1,y1,x2,y2,x3,y3,x4,y4);
           tl:=l/2;
        end;   //if
      end else tl:=tl+l; //if
      lx:=x;ly:=y;
    end; //for j
  end; //for i

end;

procedure TfLineText.MakeObjText(objid: string);
var obj:IIngeoMapObject;
  i: Integer;
begin
  obj:=mobjs.GetObject(objid);
  for i := 0 to obj.Shapes.Count - 1 do
  begin
    if obj.Shapes.Item[i].DefineGeometry then
       MakeContourText(obj,obj.Shapes.Item[i].Contour);
  end;

end;

procedure TfLineText.MakeTexts;
var
  i: Integer;
begin
  if gAddon2.Selection.Count=0 then
  begin
    ShowMessage('Не выбран ни один объект!');
    exit;
  end;
  if  not TryStrToFloat(cbInterval.Text,interval) then
  begin
    ShowMessage('Не верно введен интервал!');
    exit;
  end;
  if  not TryStrToFloat(cbUpIndent.Text,upsize) then
  begin
    ShowMessage('Не верно введен верхний отступ!');
    exit;
  end;
  if  not TryStrToFloat(cbdownIndent.Text,downsize) then
  begin
    ShowMessage('Не верно введен нижний отступ!');
    exit;
  end;
  if cbeNableDownStyle.Checked then
      downstl:=stllist[cbDownStyle.ItemIndex];
  if cbEnableUpStyle.Checked then
      upstl:=stllist[cbUpStyle.ItemIndex];

  mobjs:=gAddon2.ActiveDb.MapObjects;
  mobjs.TransactionName:='Надписи под и над объектом';
  for i := 0 to gAddon2.Selection.Count - 1 do
  begin
    MakeObjTExt(gAddon2.Selection.IDs[i]);
  end;
  mobjs.UpdateChanges;
end;

procedure TfLineText.SaveParams;
var r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(key,true);
  r.WriteString(cbInterval.Name,cbInterval.Text);
  r.WriteString(cbUpIndent.Name,cbUpIndent.Text);
  r.WriteString(cbdownIndent.Name,cbdownIndent.Text);
  r.WriteBool(cbEnableUpStyle.Name,cbEnableUpStyle.Checked);
  r.WriteBool(cbeNableDownStyle.Name,cbeNableDownStyle.Checked);
  r.CloseKey;
  r.Free;
end;
initialization
  lastupindex:=-1;
  lastdownindex:=-1;
end.
