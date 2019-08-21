unit tabimport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, strutils, math, Ingeo_TLB,InScripting_TLB, M2Addon, dllform;

type
  TfTabImport = class(TM2AddonForm)
    Label1: TLabel;
    Button1: TButton;
    mStatus: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ImportTAB(fname:string);
    function ReadFloat(var s:string):double;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTabImport: TfTabImport;

implementation
uses addn;
{$R *.dfm}

procedure TfTabImport.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ImportTAB(OpenDialog1.FileName);
  end;
end;

procedure TfTabImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfTabImport.ImportTAB(fname: string);
var tabf:TStringList;
    rw,rh,x,y,minx,miny,maxx,maxy:double;
    cs,rname:string;
  i: Integer;
  rmap:IIngeoRasterMap;
begin
  tabf:=TStringList.Create;
  try
  tabf.LoadFromFile(fname);
  except
    on e: Exception do
    begin
      ShowMessage('Не удается загрущить файл!'+e.Message);
    end;
  end;
  i:=0;
  while true do
  begin
    if i>=tabf.Count then
    begin
      ShowMessage('Не найдена запись "file"!');
      exit;
    end;
    cs:=ansiUpperCase( Trim(tabf[i]));
    if AnsiStartsText('FILE',cs) then
    begin
      rname:=Trim(Copy(cs,5,300));
      rname:=AnsiDequotedStr(rname,'"');
      break;
    end;
    inc(i);
  end;
  inc(i);
    maxx:=-1e7;
    maxy:=-1e7;
    minx:=1e7;
    miny:=1e7;
  while True do
  begin
    if i>=tabf.Count then
    begin
//      ShowMessage('Не найдена запись "file"!');
      break;
    end;
    cs:=ansiUpperCase( Trim(tabf[i]));
    if AnsiStartsText('(',cs) then
    begin
      y:=ReadFloat(cs);
      x:=ReadFloat(cs);
      minx:=Min(minx,x);
      miny:=Min(miny,y);
      maxx:=Max(maxx,x);
      maxy:=Max(maxy,y);
    end;
    inc(i);
 end; //while
 rw:=maxy-miny;
 rh:=maxx-minx;
 mStatus.Lines.Add(Format('minx=%f  miny=%f   maxx=%f  maxy=%f rw=%f  rh=%f',[minx,miny,maxx,maxy,rw,rh]));
 rmap:=gAddon2.ActiveProjectView.Project.Area.Maps.AddRasterMap;
 rmap.Name:=rname;
 rmap.CellSizeX:=rh;
 rmap.CellSizeY:=rw;
 rmap.OffsetX:=minx;
 rmap.OffsetY:=miny;
 rmap.CellDivX:=1;
 rmap.CellDivY:=1;
 rmap.Update;
 GAddon2.ActiveProjectView.Project.Contents.Add(rmap.ID);

// gAddon2.:=rmap;
 mStatus.Lines.Add(
   Format('щелкните мышью центре карты и привяжите растровый файл %s',
          [rname]));

 gAddon2.MainWindow.MapWindow.Navigator.ZoomToFitWorldRect(minx,miny,maxx,maxy);
 for i := 0 to gAddon2.ActiveProjectView.MapViews.Count  - 1 do
 begin
   if gAddon2.ActiveProjectView.MapViews.Item[i].Map.ID=rmap.ID then
   begin
     gAddon2.ActiveProjectView.SelectedMapView:=gAddon2.ActiveProjectView.MapViews.Item[i];
     exit;
   end;
 end;

end;

function TfTabImport.ReadFloat(var s: string): double;
const nums:set of char=['0'..'9','-','.'];
var ts:string;
    fs: TFormatSettings;
begin
  Result:=-1;
  while not (s[1] in nums) do
  begin
    Delete(s,1,1);
    if Length(s)=0 then
      exit;
  end;
  ts:='';
  while (s[1] in nums) do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
    if Length(s)=0 then
      break;
  end;
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT,fs);
  fs.DecimalSeparator:='.';
  TRyStrToFloat(ts,Result,fs)
end;

end.
