unit quickplan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dllform, Ingeo_TLB;
const scales:array [0..11] of integer=(
      100,200,500,1000,2000,5000,10000,25000,50000,100000,200000,500000);
type
  TfQuickPlan = class(TM2AddonForm)
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    ePlanW: TEdit;
    ePlanH: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    rtf:TStringList;
    procedure MakePlan;
    procedure RTFSetHeader;
    procedure  PreTextOut;
    procedure ImageOut;
    procedure PostTextOut;
    procedure CloseRTF;
    procedure SaveRTF;
    procedure OpenRTF;
    procedure InitPlan;
    procedure DrawPlan;

    { Private declarations }
  public
    tmpfilename:string;
    x,y:array of double;
    plan:TMetafile;
    plancv:TMetafileCanvas;
    ph,pw:double;
    { Public declarations }
  end;

var
  fQuickPlan: TfQuickPlan;

implementation
uses addn, ShellAPI, math;
{$R *.dfm}

procedure TfQuickPlan.Button1Click(Sender: TObject);
begin
  if gAddon2.Selection.Count=0 then
  begin
    ShowMessage('Объект(ы) не выделен(ы)!');
    exit;
  end;
  MakePlan;
end;

procedure TfQuickPlan.CloseRTF;
begin
  rtf.Add('}');
end;

procedure TfQuickPlan.DrawPlan;
var scale,w,h,cx,cy,rx1,rx2,ry1,ry2:double;
  i,res: Integer;
  tmpfname:string;
  tmpf:PChar;
  tmpf2: PAnsiChar;
  bmp:TBitmap;
begin
  rx1:=x[0];rx2:=rx1;
  ry1:=y[0];ry2:=ry1;
  for i := 1 to Length(x) - 1 do
  begin
    rx1:=Min(x[i],rx1);
    rx2:=Max(x[i],rx2);
    ry1:=Min(y[i],ry1);
    ry2:=Max(y[i],ry2);
  end;
  cx:=(rx1+rx2)/2;
  cy:=(ry1+ry2)/2;
  pw:=12;
  ph:=12;
  if not TryStrToFloat(ePlanW.Text,pw) then
  begin
    ShowMessage('Неверно введено число - ширина плана!');
  end;
  if not TryStrToFloat(ePlanH.Text,ph) then
  begin
    ShowMessage('Неверно введено число - высота плана!');
  end;
  res:=200;
  scale:=scales[0];
  for i := Low(scales) to High(scales) do
  begin
    w:=(ry2-ry1)/scales[i]*100;
    h:=(rx2-rx1)/scales[i]*100;
    if (h<ph) and (w<pw) then
    begin
      scale:=scales[i];
      break;
    end;
  end;
  GetMem(tmpf,10000);
  GetMem(tmpf2,10000);
  GetTempPath(10000,tmpf);
  GetTempFileName(tmpf,'qp_',1,tmpf2);
  tmpfname:=StrPas(tmpf2)+'.bmp';
  gAddon2.ActiveProjectView.MakeImageFile(res,res,Round(ph/2.54*res),Round(pw/2.54*res),
      cx,cy,1/scale,90,True,clWhite,pchar(tmpfname));
  plan:=TMetafile.Create;
  plan.Width:=Round(pw/2.54*res);
  plan.Height:=Round(ph/2.54*res);
//  plan.Enhanced:=True;
  plancv:=TMetafileCanvas.Create(plan,Canvas.Handle);
  bmp:=TBitmap.Create;
  bmp.LoadFromFile(tmpfname);
  plancv.Draw(0,0,bmp);

  plancv.Free;
  plan.SetSize(Round(pw/2.54*res),Round(ph/2.54*res));
  plan.MMWidth:=Round(pw*1000);
  plan.MMHeight:=Round(ph*1000);
end;

procedure TfQuickPlan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfQuickPlan.FormCreate(Sender: TObject);
begin
  rtf:=TStringList.Create;
end;

procedure TfQuickPlan.ImageOut;
var m:TMemoryStream;
    b:PByte;
  i: Integer;
  s,ts:string;
begin
  m:=TMemoryStream.Create;
  plan.SaveToStream(m);
  b:=PByte(m.Memory);
  ts:='';
  rtf.Add('{\pict\emfblip\picw'+IntToStr(plan.MMWidth)+'\pich'+IntToStr(plan.MMHeight));
  rtf.Add('\picwgoal'+IntToStr(Round(pw/2.54*1440))+'\pichgoal'+IntToStr(Round(ph/2.54*1440)));

  for i := 0 to m.Size - 1 do
  begin
    s:=IntToHex(b^,2);
    inc(b);
    ts:=ts+s;
  end;
  rtf.Add(ts);
  rtf.Add('}');
end;

procedure TfQuickPlan.InitPlan;
var obj:IIngeoMapObject;
    sp:IIngeoShape;
    cntp:IIngeoContourPart;
    wx,wy,wc:Double;
    oi,si,vi,c:integer;
  i: Integer;
  ci,pcount: Integer;
begin
  SetLength(x,1000);
  SetLength(y,1000);
  pcount:=0;
  for oi := 0 to gAddon2.Selection.Count - 1 do
  begin
    obj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[oi]);
    for si := 0 to obj.Shapes.Count - 1 do
    begin
      if obj.Shapes[si].DefineGeometry then
      begin
        sp:=obj.Shapes[si];
        for ci := 0 to sp.Contour.Count - 1 do
        begin
          cntp:=sp.Contour.Item[ci];
          for vi := 0 to cntp.VertexCount - 1 do
          begin
            cntp.GetVertex(vi,wx,wy,wc);
            x[pcount]:=wx;
            y[pcount]:=wy;
            inc(pcount);
            if pcount>=Length(x) then
            begin
              SetLength(x,Length(x)+1000);
              SetLength(y,Length(y)+1000);
            end;
          end;

        end;
      end;
    end;

  end;
  SetLength(x,pcount);
  SetLength(y,pcount);
  DrawPlan;
end;

procedure TfQuickPlan.MakePlan;
begin
  InitPlan;
  rtf.Clear;
  RTFSetHeader;
  PreTextOut;
  ImageOut;
  PostTextOut;
  CloseRTF;
  SaveRTF;
  OpenRTF;
end;

procedure TfQuickPlan.OpenRTF;
begin

end;

procedure TfQuickPlan.PostTextOut;
var i:integer;
begin
  rtf.Add('\par Координаты поворотных точек \par');
{rtf.Add('\par \trowd \trqc\trgaph108\trrh280\trleft36');
rtf.Add('\clbrdrt\brdrth \clbrdrl\brdrth \clbrdrb\brdrdb');
rtf.Add('\clbrdrr\brdrdb \cellx3636\clbrdrt\brdrth');
rtf.Add('\clbrdrl\brdrdb \clbrdrb\brdrdb \clbrdrr\brdrdb');
rtf.Add('\cellx7236\clbrdrt\brdrth \clbrdrl\brdrdb');
rtf.Add('\clbrdrb\brdrdb \clbrdrr\brdrdb \cellx10836');}
  rtf.Add('{');
  for i := 0 to Length(x) - 1 do
  begin
    rtf.Add('\trowd \trgaph108\trql\ltrrow\trbdrt\brdrs \trbrdrb\brdrs '+
    '\trbrdrl\brdrs \trbrdrr\brdrs \trbdrh\brdrs \trbrdrv\brdrs   \trrh0 \clbrdrt\brdrs'+
'\clbrdrl\brdrs \clbrdrb \brdrs \clbrdrr\brdrs \cellx1200'+
'\clbrdrt\brdrs\clbrdrl\brdrs \clbrdrb \brdrs \clbrdrr\brdrs\cellx3200'+
'\clbrdrt\brdrs\clbrdrl\brdrs \clbrdrb \brdrs \clbrdrr\brdrs\cellx5200'+
''+
''+
''+
'');
    rtf.Add('\pard\intbl '+IntToStr(i+1)+'\cell');
    rtf.Add('\pard\intbl '+Format('%.2f',[x[i]])+'\cell');
    rtf.Add('\pard\intbl '+Format('%.2f',[y[i]])+'\cell \row');
  end;
  rtf.Add('}');
  rtf.Add('\par Геоданные');
end;

procedure TfQuickPlan.PreTextOut;
begin
  rtf.Add('\pard\plain План земельного участка \par')
end;

procedure TfQuickPlan.RTFSetHeader;
begin
  rtf.Add('{\rtf\ansi\deff0{\fonttbl{\f0\froman Tms Rmn;}}{\colortbl\red0\blue0\green0}');
end;

procedure TfQuickPlan.SaveRTF;
begin
  if SaveDialog1.Execute then
  begin
    tmpfilename:=SaveDialog1.FileName;
    rtf.SaveToFile(tmpfilename);
    ShellExecute(Handle,'open',Pchar( tmpfilename),nil,nil,sw_Show);
  end;
end;

end.
